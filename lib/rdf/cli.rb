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
  #           on: ["--canonicalize"],
  #           description: "Canonicalize input/output.") {true},
  #         RDF::CLI::Option.new(
  #           symbol: :uri,
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

      # Potential values (for select or radio) or Ruby datatype
      # @return  [Class, Array<String>]
      attr_reader :datatype

      # Associated HTML form control
      # @return [:text, :textarea, :radio, :checkbox, :select, :url, :url2, :none]
      attr_reader :control

      ##
      # Create a new option with optional callback.
      #
      # @param [Symbol] symbol
      # @param [Array<String>] on
      # @param [String] description
      # @yield value which may be used within `OptionParser#on`
      # @yieldparam [Object] value The option value as parsed using `on` argument
      # @yieldparam [OptionParser] options (nil) optional OptionParser
      # @yieldreturn [Object] a possibly modified input value
      def initialize(symbol: nil, on: nil, datatype: nil, control: nil, description: nil, **options, &block)
        raise ArgumentError, "symbol is a required argument" unless symbol
        raise ArgumentError, "on is a required argument" unless on
        @symbol, @on, @datatype, @control, @description, @callback = symbol.to_sym, Array(on), datatype, control, description, block
      end

      def call(arg, options)
        if @callback
          case @callback.arity
          when 1 then @callback.call(arg)
          when 2 then @callback.call(arg, options)
          end
        else
          arg
        end
      end

      # Return version of commands appropriate for use in JSON
      def to_hash
        {
          symbol: symbol,
          datatype: datatype,
          control: control,
          description: description
        }
      end
    end

    # Built-in commands. Other commands are imported from the Format class of different readers/writers using {RDF::Format#cli_commands}. `COMMANDS` is a Hash who's keys are commands that may be executed by {RDF::CLI.exec}. The value is a hash containing the following keys:
    # * `description` used for providing information about the command.
    # * `parse` Boolean value to determine if input files should automatically be parsed into `repository`.
    # * `help` used for the CLI help output.
    # * `lambda` code run to execute command.
    # * `options` an optional array of `RDF::CLI::Option` describing command-specific options, which may also be used to remove general options.
    # @return [Hash{Symbol => Hash{Symbol => Object}}]
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
        end,
        options: [
          RDF::CLI::Option.new(symbol: :output_format, on: [])
        ]
      },
      help: {
        description: "This message",
        parse: false,
        lambda: ->(argv, opts) {self.usage(self.options)}
      },
      lengths: {
        description: "Lengths of each parsed statement",
        parse: true,
        help: "lengths [options] [args...]\nreturns lengths of each parsed statement",
        lambda: ->(argv, opts) do
          repository.each_statement do |statement|
            $stdout.puts statement.to_s.size
          end
        end,
        options: [
          RDF::CLI::Option.new(symbol: :output_format, on: [])
        ]
      },
      objects: {
        description: "Serialize each parsed object to N-Triples",
        parse: true,
        help: "objects [options] [args...]\nreturns unique objects serialized in N-Triples format",
        lambda: ->(argv, opts) do
          $stdout.puts "Objects"
          repository.each_object do |object|
            $stdout.puts object.to_ntriples
          end
        end,
        options: [
          RDF::CLI::Option.new(symbol: :output_format, on: [])
        ]
      },
      predicates: {
        parse: true,
        description: "Serialize each parsed predicate to N-Triples",
        help: "predicates [options] [args...]\nreturns unique predicates serialized in N-Triples format",
        lambda: ->(argv, opts) do
          $stdout.puts "Predicates"
          repository.each_predicate do |predicate|
            $stdout.puts predicate.to_ntriples
          end
        end,
        options: [
          RDF::CLI::Option.new(symbol: :output_format, on: [])
        ]
      },
      serialize: {
        description: "Serialize using output-format (or N-Triples)",
        parse: true,
        help: "serialize [options] [args...]\nserialize output using specified format (or N-Triples if not specified)",
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
        parse: true,
        description: "Serialize each parsed subject to N-Triples",
        help: "subjects [options] [args...]\nreturns unique subjects serialized in N-Triples format",
        lambda: ->(argv, opts) do
          $stdout.puts "Subjects"
          repository.each_subject do |subject|
            $stdout.puts subject.to_ntriples
          end
        end,
        options: [
          RDF::CLI::Option.new(symbol: :output_format, on: [])
        ]
      },
      validate: {
        description: "Validate parsed input",
        parse: true,
        help: "validate [options] [args...]\nvalidates parsed input (may also be used with --validate)",
        lambda: ->(argv, opts) do
          $stdout.puts "Input is " + (repository.valid? ? "" : "in") + "valid"
        end,
        options: [
          RDF::CLI::Option.new(symbol: :output_format, on: [])
        ]
      }
    }

    # Options to setup, may be modified by selected command. Options are also read from {RDF::Reader#options} and {RDF::Writer#options}. When a specific input- or ouput-format is selected, options are also discovered from the associated subclass reader or writer.
    # @return [Array<RDF::CLI::Option>]
    OPTIONS = [
      RDF::CLI::Option.new(
        symbol: :debug,
        control: :checkbox,
        on: ["-d", "--debug"],
        description: 'Enable debug output for troubleshooting.'),
      RDF::CLI::Option.new(
        symbol: :verbose,
        control: :checkbox,
        on: ['-v', '--verbose'],
        description: 'Enable verbose output. May be given more than once.'),
      RDF::CLI::Option.new(
        symbol: :evaluate,
        control: :textbox,
        on: ["-e", "--evaluate STRING"],
        description: "Evaluate argument as RDF input, if no files are specified"),
      RDF::CLI::Option.new(
        symbol: :output,
        control: :none,
        on: ["-o", "--output FILE"],
        description: "File to write output, defaults to STDOUT") {|arg| File.open(arg, "w")},
      RDF::CLI::Option.new(
        symbol: :format,
        control: :select,
        datatype: RDF::Format.select {|ft| ft.reader}.map(&:to_sym).sort,
        on: ["--input-format FORMAT", "--format FORMAT"],
        description: "Format of input file, uses heuristic if not specified"
      ) do |arg, options|
          unless reader = RDF::Reader.for(arg.downcase.to_sym)
            RDF::CLI.abort "No reader found for #{arg.downcase.to_sym}. Available readers:\n  #{RDF::CLI.formats(reader: true).join("\n  ")}"
          end

          # Add format-specific reader options
          reader.options.each do |cli_opt|
            next if options.options.has_key?(cli_opt.symbol)
            on_args = cli_opt.on || []
            on_args << cli_opt.description if cli_opt.description
            options.on(*on_args) do |opt_arg|
              options.options[cli_opt.symbol] = cli_opt.call(opt_arg)
            end
          end if reader
          arg.downcase.to_sym
        end,
      RDF::CLI::Option.new(
        symbol: :output_format,
        control: :select,
        datatype: RDF::Format.select {|ft| ft.writer}.map(&:to_sym).sort,
        on: ["--output-format FORMAT"],
        description: "Format of output file, defaults to NTriples"
      ) do |arg, options|
          unless writer = RDF::Writer.for(arg.downcase.to_sym)
            RDF::CLI.abort "No writer found for #{arg.downcase.to_sym}. Available writers:\n  #{self.formats(writer: true).join("\n  ")}"
          end

          # Add format-specific writer options
          writer.options.each do |cli_opt|
            next if options.options.has_key?(cli_opt.symbol)
            on_args = cli_opt.on || []
            on_args << cli_opt.description if cli_opt.description
            options.on(*on_args) do |opt_arg|
              options.options[cli_opt.symbol] = cli_opt.call(opt_arg)
            end
          end if writer
          arg.downcase.to_sym
        end,
    ] + RDF::Reader.options + RDF::Writer.options

    class << self
      # Repository containing parsed statements
      # @return [RDF::Repository]
      attr_accessor :repository
    end

    ##
    # @return [String]
    def self.basename() File.basename($0) end

    ##
    # Return OptionParser set with appropriate options
    #
    # The yield return should provide one or more commands from which additional options will be extracted.
    # @param [Array<String>] argv
    def self.options(argv)
      options = OptionParser.new
      cli_opts = OPTIONS.dup
      logger = Logger.new($stderr)
      logger.level = Logger::ERROR
      logger.formatter = lambda {|severity, datetime, progname, msg| "#{severity} #{msg}\n"}
      opts = options.options = {
        logger:         logger
      }


      # Pre-load commands
      load_commands

      # Add options for the specified command(s)
      cmds, args = argv.partition {|e| COMMANDS.include?(e.to_sym)}
      cmds.each do |cmd|
        Array(RDF::CLI::COMMANDS[cmd.to_sym][:options]).each do |option|
          # Replace any existing option with the same symbol
          cli_opts.delete_if {|cli_opt| cli_opt.symbol == option.symbol}

          # Add the option, unless `on` is empty
          cli_opts.unshift(option) unless option.on.empty?
        end
      end

      cli_opts.each do |cli_opt|
        next if opts.has_key?(cli_opt.symbol)
        on_args = cli_opt.on || []
        on_args << cli_opt.description if cli_opt.description
        options.on(*on_args) do |arg|
          opts[cli_opt.symbol] = cli_opt.call(arg, options)

          # Hacks for specific options
          opts[:logger].level = Logger::INFO if cli_opt.symbol == :verbose
          opts[:logger].level = Logger::DEBUG if cli_opt.symbol == :debug
        end
      end

      options.banner = "Usage: #{self.basename} command+ [options] [args...]"

      options.on_tail('-V', '--version', 'Display the RDF.rb version and exit.') do
        puts RDF::VERSION; exit(0)
      end

      options.on_tail("-h", "--help", "Show this message") do
        self.usage(options); exit(0)
      end

      begin
        options.parse!(args)
      rescue OptionParser::InvalidOption, OptionParser::InvalidArgument, ArgumentError => e
        abort e
      end

      options
    end

    ##
    # Output usage message
    def self.usage(options, cmd_opts = {}, banner: nil)
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
    # @param  [OptionParser] option_parser
    # @param  [Hash{Symbol => Object}] options
    # @return [Boolean]
    def self.exec(args, output: $stdout, option_parser: nil, **options)
      option_parser ||= self.options(args)
      output.set_encoding(Encoding::UTF_8) if output.respond_to?(:set_encoding) && RUBY_PLATFORM == "java"
      cmds, args = args.partition {|e| COMMANDS.include?(e.to_sym)}

      if cmds.empty?
        usage(option_parser)
        abort "No command given"
      end

      if cmds.first == 'help'
        on_cmd = cmds[1]
        cmd_opts = COMMANDS.fetch(on_cmd.to_s.to_sym, {})
        if on_cmd && cmd_opts[:help]
          usage(option_parser, cmd_opts: cmd_opts, banner: "Usage: #{self.basename.split('/').last} #{COMMANDS[on_cmd.to_sym][:help]}")
        elsif on_cmd
          usage(option_parser, cmd_opts: cmd_opts)
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
    # @overload commands
    #   @return [Array<String>] list of executable commands
    # @overload commands
    #   @param [:json] format (:json)
    #   @return [Hash{Symbol => Object}]
    #     Returns a hash structure suitably for serializing to JSON
    def self.commands(format: nil)
      # First, load commands from other formats
      load_commands

      case format
      when :json
        COMMANDS.inject({}) do |memo, (k, v)|
          v.delete(:lambda)
          v.delete(:help)
          v[:options] = Array(v[:options]).map(&:to_hash)
          v.delete(:options) if v[:options].empty?
          memo.merge(k => v)
        end.to_hash
      else
        sym_len = COMMANDS.keys.map {|k| k.to_s.length}.max
        COMMANDS.keys.sort.map do |k|
          "%*s: %s" % [sym_len, k, COMMANDS[k][:description]]
        end
      end
    end

    ##
    # Load commands from formats
    # @return [Hash{Symbol => Hash{Symbol => Object}}]
    def self.load_commands
      unless @commands_loaded
        RDF::Format.each do |format|
          format.cli_commands.each do |command, options|
            options = {lambda: options} unless options.is_a?(Hash)
            add_command(command, options)
          end
        end
        @commands_loaded = true
      end
      COMMANDS
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
      f = RDF::Format.sort_by(&:to_sym).
        select {|ft| (reader ? ft.reader : (writer ? ft.writer : (ft.reader || ft.writer)))}.
        inject({}) do |memo, r|
          memo.merge(r.to_sym => r.name)
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
