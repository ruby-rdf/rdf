require 'rdf'
require 'rdf/ntriples'
require 'rdf/nquads'
require 'logger'
require 'optparse'
begin
  gem 'linkeddata'
  require 'linkeddata'
rescue LoadError
  # Silently load without linkeddata, but try some others
  %w(rdfa rdfxml turtle).each do |ser|
    begin
      require "rdf/#{ser}"
    rescue LoadError
    end
  end

  begin
    require 'json/ld'
  rescue LoadError
  end
end

class OptionParser
  def options; @options || {}; end
  def options=(value); @options = value; end
end

module RDF
  class CLI

    # Option description for use within Readers/Writers
    class Option
      # Symbol used for this option when calling `Reader.new`
      # @return [Symbol]
      attr_reader :symbol

      # Arguments passed to OptionParser#on
      # @return [Array<String>]
      attr_reader :on

      # Description of this option (optional)
      # @return [String]
      attr_reader :description

      ##
      # Create a new option with optional callback.
      #
      # @param [Symbol] symbol
      # @param [Array<String>] on
      # @param [String] description
      # @param [Class] datatype datatype of value
      # @yield value which may be used within `OptionParser#on`
      # @yieldparam [Object] value The option value as parsed using `on` argument
      # @yieldreturn [Object] a possibly modified input value
      def initialize(symbol: nil, on: nil, description: nil, datatype: String, &block)
        raise ArgumentError, "symbol is a required argument" unless symbol
        raise ArgumentError, "on is a required argument" unless on
        @symbol, @on, @description, @datatype, @callback = symbol.to_sym, Array(on), description, datatype, block
      end

      def call(arg)
        @callback ? @callback.call(arg) : arg
      end
    end

    COMMANDS = {
      "count"       => lambda do |argv, opts|
        start = Time.new
        count = 0
        self.parse(argv, opts) do |reader|
          reader.each_statement do |statement|
            count += 1
          end
        end
        secs = Time.new - start
        $stdout.puts "Parsed #{count} statements with #{@readers.join(', ')} in #{secs} seconds @ #{count/secs} statements/second."
      end,
      "lenghts"     => lambda do |argv, opts|
        self.parse(argv, opts) do |reader|
          reader.each_statement do |statement|
            $stdout.puts statement.to_s.size
          end
        end
      end,
      "objects"     => lambda do |argv, opts|
        $stdout.set_encoding(Encoding::UTF_8) if RUBY_PLATFORM == "java"
        self.parse(argv, opts) do |reader|
          reader.each_statement do |statement|
            $stdout.puts statement.object.to_ntriples
          end
        end
      end,
      "predicates"   => lambda do |argv, opts|
        $stdout.set_encoding(Encoding::UTF_8) if RUBY_PLATFORM == "java"
        self.parse(argv, opts) do |reader|
          reader.each_statement do |statement|
            $stdout.puts statement.predicate.to_ntriples
          end
        end
      end,
      "serialize" => lambda do |argv, opts|
        writer_class = RDF::Writer.for(opts[:output_format]) || RDF::NTriples::Writer
        out = opts[:output] || $stdout
        out.set_encoding(Encoding::UTF_8) if out.respond_to?(:set_encoding) && RUBY_PLATFORM == "java"
        opts = opts.merge(prefixes: {})
        writer_opts = opts.merge(standard_prefixes: true)
        self.parse(argv, opts) do |reader|
          writer_class.new(out, writer_opts) do |writer|
            writer << reader
          end
        end
      end,
      "subjects"   => lambda do |argv, opts|
        $stdout.set_encoding(Encoding::UTF_8) if RUBY_PLATFORM == "java"
        self.parse(argv, opts) do |reader|
          reader.each_statement do |statement|
            $stdout.puts statement.subject.to_ntriples
          end
        end
      end,
      "validate"   => lambda do |argv, opts|
        start = Time.new
        count = 0
        valid = true
        self.parse(argv, opts) do |reader|
          reader.each_statement do |statement|
            count += 1
            valid = false if statement.invalid?
          end
        end
        secs = Time.new - start
        $stdout.puts "Validated #{count} statements with #{@readers.join(', ')} in #{secs} seconds @ #{count/secs} statements/second."
      end
    }

    ##
    # @return [String]
    def self.basename() File.basename($0) end

    ##
    # @yield  [options]
    # @yieldparam [OptionParser]
    # @return [OptionParser]
    def self.options(&block)
      options = OptionParser.new
      logger = Logger.new($stderr)
      logger.level = Logger::ERROR
      logger.formatter = lambda {|severity, datetime, progname, msg| "#{severity} #{msg}\n"}
      opts = options.options = {
        debug:          false,
        evaluate:       nil,
        format:         nil,
        output:         $stdout,
        output_format:  :ntriples,
        logger:         logger
      }

      # Add default Reader and Writer options
      RDF::Reader.options.each do |cli_opt|
        next if opts.has_key?(cli_opt.symbol)
        on_args = cli_opt.on || []
        on_args << cli_opt.description if cli_opt.description
        options.on(*on_args) do |arg|
          opts[cli_opt.symbol] = cli_opt.call(arg)
        end
      end
      RDF::Writer.options.each do |cli_opt|
        next if opts.has_key?(cli_opt.symbol)
        on_args = cli_opt.on || []
        on_args << cli_opt.description if cli_opt.description
        options.on(*on_args) do |arg|
          opts[cli_opt.symbol] = cli_opt.call(arg)
        end
      end

      # Command-specific options
      if block_given?
        case block.arity
          when 1 then block.call(options)
          else options.instance_eval(&block)
        end
      end
      options.banner ||= "Usage: #{self.basename} [options] command [args...]"

      options.on('-d', '--debug',   'Enable debug output for troubleshooting.') do
        opts[:logger].level = Logger::DEBUG
      end

      options.on("-e", "--evaluate STRING", "Evaluate argument as RDF input, if no files are specified") do |arg|
        opts[:evaluate] = arg
      end

      options.on("--input-format FORMAT", "--format FORMAT", "Format of input file, uses heuristic if not specified") do |arg|
        unless reader = RDF::Reader.for(arg.downcase.to_sym)
          $stderr.puts "No reader found for #{arg.downcase.to_sym}. Available readers:\n  #{self.formats(reader: true).join("\n  ")}"
          exit(1)
        end

        # Add format-specific reader options
        reader.options.each do |cli_opt|
          next if opts.has_key?(cli_opt.symbol)
          on_args = cli_opt.on || []
          on_args << cli_opt.description if cli_opt.description
          options.on(*on_args) do |arg|
            opts[cli_opt.symbol] = cli_opt.call(arg)
          end
        end
        opts[:format] = arg.downcase.to_sym
      end

      options.on("-o", "--output FILE", "File to write output, defaults to STDOUT") do |arg|
        opts[:output] = File.open(arg, "w")
      end

      options.on("--output-format FORMAT", "Format of output file, defaults to NTriples") do |arg|
        unless writer = RDF::Writer.for(arg.downcase.to_sym)
          $stderr.puts "No writer found for #{arg.downcase.to_sym}. Available writers:\n  #{self.formats(writer: true).join("\n  ")}"
          exit(1)
        end

        # Add format-specific writer options
        writer.options.each do |cli_opt|
          next if opts.has_key?(cli_opt.symbol)
          on_args = cli_opt.on || []
          on_args << cli_opt.description if cli_opt.description
          options.on(*on_args) do |arg|
            opts[cli_opt.symbol] = cli_opt.call(arg)
          end
        end
        opts[:output_format] = arg.downcase.to_sym
      end

      options.on_tail("-h", "--help", "Show this message") do
        $stdout.puts options
        $stdout.puts "Available commands:\n\t#{self.commands.join("\n\t")}"
        $stdout.puts "Available formats:\n\t#{(self.formats).join("\n\t")}"
        exit
      end

      begin
        options.parse!
      rescue OptionParser::InvalidOption => e
        abort e
      end

      options
    end

    ##
    # @param  [String] command
    # @param  [Array<String>] args
    # @return [Boolean]
    def self.exec_command(command, args, options = {})
      unless COMMANDS.has_key?(command)
        abort "#{File.basename($0)}: unknown command `#{command}'"
      end

      COMMANDS[command].call(args, options)
    end

    ##
    # @return [Array<String>] list of executable commands
    def self.commands
      COMMANDS.keys
    end

    ##
    # @return [Array<String>] list of available formats
    def self.formats(reader: false, writer: false)
      f = RDF::Format.each.
        select {|f| (reader ? f.reader : (writer ? f.writer : true))}.
        inject({}) do |memo, reader|
          memo.merge(reader.to_sym => reader.name)
      end
      sym_len = f.keys.map {|k| k.to_s.length}.max
      f.map {|s, t| "%*s: %s" % [sym_len, s, t]}
    end

    ##
    # Parse each file, STDIN or specified string in `options[:evaluate]`
    # yielding a reader
    #
    # @param  [Array<String>] files
    # @yield  [reader]
    # @yieldparam [RDF::Reader]
    # @return [nil]
    def self.parse(files, options = {}, &block)
      if files.empty?
        # If files are empty, either use options[:execute]
        input = options[:evaluate] ? StringIO.new(options[:evaluate]) : STDIN
        input.set_encoding(options.fetch(:encoding, Encoding::UTF_8))
        RDF::Reader.for(options[:format] || :ntriples).new(input, options) do |reader|
          yield(reader)
        end
      else
        files.each do |file|
          RDF::Reader.open(file, options) do |reader|
            (@readers ||= []) << reader.class.to_s
            yield(reader)
          end
        end
      end
    end

    ##
    # @param  [String] msg
    # @return [void]
    def self.abort(msg)
      Kernel.abort "#{basename}: #{msg}"
    end
  end
end
