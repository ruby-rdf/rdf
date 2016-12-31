require 'rdf'
require 'rdf/ntriples'
require 'rdf/nquads'
require 'rdf/vocab/writer'
require 'logger'
require 'optparse'
begin
  require 'linkeddata'
rescue LoadError
  # Silently load without linkeddata, but try some others
  %w(reasoner rdfa rdfxml turtle vocab json/ld ld/patch).each do |ser|
    begin
      require ser.include?('/') ? ser : "rdf/#{ser}"
    rescue LoadError
    end
  end
end

class OptionParser
  def options; @options || {}; end
  def options=(value); @options = value; end
end

module RDF
  # Individual formats can modify options by updating {Reader.options} or {Writer.options}. Format-specific commands are taken from {Format.cli_commands} for each loaded format, which returns an array of lambdas taking arguments and options.
  #
  # Other than `help`, all commands parse an input file.
  #
  # Multiple commands may be added in sequence to execute a pipeline.
  #
  # @example Creating Reader-specific options:
  #   class Reader
  #     def self.options
  #       [
  #         RDF::CLI::Option.new(
  #           symbol: :canonicalize,
  #           datatype: TrueClass,
  #           on: ["--canonicalize"],
  #           description: "Canonicalize input/output.") {true},
  #         RDF::CLI::Option.new(
  #           symbol: :uri,
  #           datatype: RDF::URI,
  #           on: ["--uri STRING"],
  #           description: "URI.") {|v| RDF::URI(v)},
  #       ]
  #     end
  #
  # @example Creating Format-specific commands:
  #   class Format
  #     def self.cli_commands
  #       {
  #         count: {
  #           description: "",
  #           parse: true,
  #           lambda: ->(argv, opts) {}
  #         },
  #       }
  #     end
  #
  # @example Adding a command manually
  #   class MyCommand
  #     RDF::CLI.add_command(:count, description: "Count statements") do |argv, opts|
  #       count = 0
  #       RDF::CLI.parse(argv, opts) do |reader|
  #         reader.each_statement do |statement|
  #           count += 1
  #         end
  #       end
  #       $stdout.puts "Parsed #{count} statements"
  #     end
  #   end
  #     
  # Format-specific commands should verify that the reader and/or output format are appropriate for the command.
  class CLI

    # Option description for use within Readers/Writers. See {RDF::Reader.options} and {RDF::Writer.options} for example usage.
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

      # Argument datatype, which may be enumerated string values
      # @return [Class, Array<String>]
      attr_reader :datatype

      # Allows multiple comma-spearated values.
      # @return [Boolean]
      attr_reader :multiple

      ##
      # Create a new option with optional callback.
      #
      # @param [Symbol] symbol
      # @param [Array<String>] on
      # @param [String] description
      # @param [Class, Array<String>] datatype of value
      # @param [Boolean] multiple can have multiple comma-separated values
      # @yield value which may be used within `OptionParser#on`
      # @yieldparam [Object] value The option value as parsed using `on` argument
      # @yieldreturn [Object] a possibly modified input value
      def initialize(symbol: nil, on: nil, description: nil, datatype: String, multiple: false, &block)
        raise ArgumentError, "symbol is a required argument" unless symbol
        raise ArgumentError, "on is a required argument" unless on
        @symbol, @on, @description, @datatype, @multiple, @callback = symbol.to_sym, Array(on), description, datatype, multiple, block
      end

      def call(arg)
        @callback ? @callback.call(arg) : arg
      end
    end

    # @private
    COMMANDS = {
      count: {
        description: "Count statements in parsed input",
        parse: false,
        help: "count [options] [args...]\nreturns number of parsed statements",
        lambda: ->(argv, opts) do
          unless repository.count > 0
            start = Time.new
            count = 0
            self.parse(argv, opts) do |reader|
              reader.each_statement do |statement|
                count += 1
              end
            end
            secs = Time.new - start
            $stdout.puts "Parsed #{count} statements with #{@readers.join(', ')} in #{secs} seconds @ #{count/secs} statements/second."
          end
        end
      },
      help: {
        description: "This message",
        parse: false,
        lambda: ->(argv, opts) {self.usage(self.options)}
      },
      lengths: {
        description: "Lengths of each parsed statement",
        parse: true,
        help: "lengths [options] [args...]\nreturns statement lengths",
        lambda: ->(argv, opts) do
          repository.each_statement do |statement|
            $stdout.puts statement.to_s.size
          end
        end
      },
      objects: {
        description: "Serialize each parsed object to N-Triples",
        parse: true,
        help: "objects [options] [args...]\nreturns unique objects",
        lambda: ->(argv, opts) do
          $stdout.puts "Objects"
          repository.each_object do |object|
            $stdout.puts object.to_ntriples
          end
        end
      },
      predicates: {
        description: "Serialize each parsed predicate to N-Triples",
        parse: true,
        help: "predicates [options] [args...]\nreturns unique predicates",
        lambda: ->(argv, opts) do
          $stdout.puts "Predicates"
          repository.each_predicate do |predicate|
            $stdout.puts predicate.to_ntriples
          end
        end
      },
      serialize: {
        description: "Serialize each parsed statement to N-Triples, or the specified output format",
        parse: true,
        help: "serialize [options] [args...]\nserialize output using specified format (or n-triples if not specified)",
        lambda: ->(argv, opts) do
          writer_class = RDF::Writer.for(opts[:output_format]) || RDF::NTriples::Writer
          out = opts[:output] || $stdout
          opts = opts.merge(prefixes: {})
          writer_opts = opts.merge(standard_prefixes: true)
          writer_class.new(out, writer_opts) do |writer|
            writer << repository
          end
        end
      },
      subjects: {
        description: "Serialize each parsed subject to N-Triples",
        parse: true,
        help: "subjects [options] [args...]\nreturns unique subjects",
        lambda: ->(argv, opts) do
          $stdout.puts "Subjects"
          repository.each_subject do |subject|
            $stdout.puts subject.to_ntriples
          end
        end
      },
      validate: {
        description: "Validate parsed input",
        parse: true,
        help: "validate [options] [args...]\nvalidates parsed input (may also be used with --validate)",
        lambda: ->(argv, opts) do
          $stdout.puts "Input is " + (repository.valid? ? "" : "in") + "valid"
        end
      }
    }

    class << self
      # Repository containing parsed statements
      # @return [RDF::Repository]
      attr_accessor :repository
    end

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
      options.banner = "Usage: #{self.basename} command+ [options] [args...]"

      options.on('-d', '--debug',   'Enable debug output for troubleshooting.') do
        opts[:logger].level = Logger::DEBUG
      end

      options.on("-e", "--evaluate STRING", "Evaluate argument as RDF input, if no files are specified") do |arg|
        opts[:evaluate] = arg
      end

      options.on("--input-format FORMAT", "--format FORMAT", "Format of input file, uses heuristic if not specified") do |arg|
        unless reader = RDF::Reader.for(arg.downcase.to_sym)
          self.abort "No reader found for #{arg.downcase.to_sym}. Available readers:\n  #{self.formats(reader: true).join("\n  ")}"
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
          self.abort "No writer found for #{arg.downcase.to_sym}. Available writers:\n  #{self.formats(writer: true).join("\n  ")}"
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
        self.usage(options)
        exit(0)
      end

      begin
        options.parse!
      rescue OptionParser::InvalidOption => e
        abort e
      end

      options
    end

    ##
    # Output usage message
    def self.usage(options, banner: nil)
      options.banner = banner if banner
      $stdout.puts options
      $stdout.puts "Note: available commands and options may be different depending on selected --input-format and/or --output-format."
      $stdout.puts "Available commands:\n\t#{self.commands.join("\n\t")}"
      $stdout.puts "Available formats:\n\t#{(self.formats).join("\n\t")}"
    end

    ##
    # Execute one or more commands, parsing input as necessary
    #
    # @param  [Array<String>] args
    # @param  [IO] output
    # @param  [Hash{Symbol => Object}] options
    # @return [Boolean]
    def self.exec(args, output: $stdout, option_parser: self.options, **options)
      output.set_encoding(Encoding::UTF_8) if output.respond_to?(:set_encoding) && RUBY_PLATFORM == "java"
      cmds, args = args.partition {|e| commands.include?(e.to_s)}

      if cmds.empty?
        usage(option_parser)
        abort "No command given"
      end

      if cmds.first == 'help'
        on_cmd = cmds[1]
        if on_cmd && COMMANDS.fetch(on_cmd.to_sym, {})[:help]
          usage(option_parser, banner: "Usage: #{self.basename.split('/').last} #{COMMANDS[on_cmd.to_sym][:help]}")
        else
          usage(option_parser)
        end
        return
      end

      @repository = RDF::Repository.new

      # Parse input files if any command requires it
      if cmds.any? {|c| COMMANDS[c.to_sym][:parse]}
        start = Time.new
        count = 0
        self.parse(args, options) do |reader|
          @repository << reader
        end
        secs = Time.new - start
        $stdout.puts "Parsed #{repository.count} statements with #{@readers.join(', ')} in #{secs} seconds @ #{count/secs} statements/second."
      end

      # Run each command in sequence
      cmds.each do |command|
        COMMANDS[command.to_sym][:lambda].call(args, output: output, **options)
      end
    rescue ArgumentError => e
      abort e.message
    end

    ##
    # @return [Array<String>] list of executable commands
    def self.commands
      # First, load commands from other formats
      unless @commands_loaded
        RDF::Format.each do |format|
          format.cli_commands.each do |command, options|
            options = {lambda: options} unless options.is_a?(Hash)
            add_command(command, options)
          end
        end
        @commands_loaded = true
      end
      COMMANDS.keys.map(&:to_s).sort
    end

    ##
    # Add a command.
    #
    # @param [#to_sym] command
    # @param [Hash{Symbol => String}] options
    # @option options [String] description
    # @option options [String] help string to display for help
    # @option options [Boolean] parse parse input files in to Repository, or not.
    # @option options [Array<RDF::CLI::Option>] options specific to this command
    # @yield argv, opts
    # @yieldparam [Array<String>] argv
    # @yieldparam [Hash] opts
    # @yieldreturn [void]
    def self.add_command(command, **options, &block)
      options[:lambda] = block if block_given?
      COMMANDS[command.to_sym] ||= options
    end

    ##
    # @return [Array<String>] list of available formats
    def self.formats(reader: false, writer: false)
      f = RDF::Format.sort_by(&:to_sym).each.
        select {|f| (reader ? f.reader : (writer ? f.writer : (f.reader || f.writer)))}.
        inject({}) do |memo, reader|
          memo.merge(reader.to_sym => reader.name)
      end
      sym_len = f.keys.map {|k| k.to_s.length}.max
      f.map {|s, t| "%*s: %s" % [sym_len, s, t]}
    end

    ##
    # Parse each file, $stdin or specified string in `options[:evaluate]`
    # yielding a reader
    #
    # @param  [Array<String>] files
    # @param  [String] evaluate from command-line, rather than referenced file
    # @param  [Symbol] format (:ntriples) Reader symbol for finding reader
    # @param  [Encoding] encoding set on the input
    # @param  [Hash{Symbol => Object}] options sent to reader
    # @yield  [reader]
    # @yieldparam [RDF::Reader]
    # @return [nil]
    def self.parse(files, evaluate: nil, format: :ntriples, encoding: Encoding::UTF_8, **options, &block)
      if files.empty?
        # If files are empty, either use options[:execute]
        input = evaluate ? StringIO.new(evaluate) : $stdin
        input.set_encoding(encoding)
        r = RDF::Reader.for(format)
        (@readers ||= []) << r
        r.new(input, options) do |reader|
          yield(reader)
        end
      else
        options[:format] = format if format
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
