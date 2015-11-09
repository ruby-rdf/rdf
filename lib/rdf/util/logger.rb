module RDF; module Util
  ##
  # Helpers for logging errors, warnings and debug information.
  #
  # Modules must provide `@logger`, which returns an instance of `Logger`, or something responding to `#<<`. Logger may also be specified using an `@options` hash containing a `:logger` entry.
  # @since 2.0.0
  module Logger
    ##
    # Used for fatal errors where processing cannot continue. If `logger` is not configured, it logs to `$stderr`.
    #
    # @overload log_fatal(*args, options = {}, &block)
    #   @param [Array<String>] args
    #   @param [Array<String>] args Messages
    #   @param [Hash{Symbol => Object}] options
    #   @option options [Integer] :depth (@options[:depth] || @depth)
    #     Recursion depth for indenting output
    #   @option options [:fatal, :error, :warning, :info, :debug] level (:<<)
    #   @option options [Integer] :lineno associated with message
    #   @option options [Logger, #<<] :logger
    #   @option options [Class] :exception, (StandardError)
    #     Exception class used for raising error
    #   @yieldreturn [String] added to message
    #   @return [void]
    #   @raise Raises the provided exception class using the first element from args as the message component.
    def log_fatal(*args, &block)
      options = args.last.is_a?(Hash) ? args.pop : {}
      logger_common(*args, "Called from #{Gem.location_of_caller.join(':')}", options.merge(level: :fatal), &block)
      raise options.fetch(:exception, StandardError), args.first
    end

    ##
    # Used for non-fatal errors where processing can continue. If `logger` is not configured, it logs to `$stderr`.
    #
    # As a side-effect of setting `@logger_in_error`, which will suppress further error messages until cleared using {#recover}.
    #
    # @overload log_error(*args, options = {}, &block)
    #   @param [Array<String>] args
    #   @param [Array<String>] args Messages
    #   @param [Hash{Symbol => Object}] options
    #   @option options [Integer] :depth (@options[:depth] || @depth)
    #     Recursion depth for indenting output
    #   @option options [:fatal, :error, :warning, :info, :debug] level (:<<)
    #   @option options [Integer] :lineno associated with message
    #   @option options [Logger, #<<] :logger
    #   @option options [Class] :exception, (StandardError)
    #     Exception class used for raising error
    #   @yieldreturn [String] added to message
    #   @return [void]
    #   @raise Raises the provided exception class using the first element from args as the message component, if `:exception` option is provided.
    def log_error(*args, &block)
      return if @logger_in_error
      @logger_in_error = true
      options = args.last.is_a?(Hash) ? args.pop : {}
      logger_common(*args, options.merge(level: :error), &block)
      raise options[:exception], args.first if options[:exception]
    end

    ##
    # Recovers from an error condition. If `args` are passed, sent as an informational message
    #
    # As a side-effect of clearing `@logger_in_error`.
    #
    # @overload log_recover(*args, options = {}, &block)
    #   @param [Array<String>] args
    #   @param [Array<String>] args Messages
    #   @param [Hash{Symbol => Object}] options
    #   @option options [Integer] :depth (@options[:depth] || @depth)
    #     Recursion depth for indenting output
    #   @option options [:fatal, :error, :warning, :info, :debug] level (:<<)
    #   @option options [Integer] :lineno associated with message
    #   @option options [Logger, #<<] :logger
    #   @yieldreturn [String] added to message
    #   @return [void]
    def log_recover(*args, &block)
      @logger_in_error = nil
      return if args.empty? && !block_given?
      options = args.last.is_a?(Hash) ? args.pop : {}
      logger_common(*args, options.merge(level: :info), &block)
    end

    ##
    # Informational message.
    #
    # @overload recover(*args, options = {}, &block)
    #   @param [Array<String>] args
    #   @param [Array<String>] args Messages
    #   @param [Hash{Symbol => Object}] options
    #   @option options [Integer] :depth (@options[:depth] || @depth)
    #     Recursion depth for indenting output
    #   @option options [:fatal, :error, :warning, :info, :debug] level (:<<)
    #   @option options [Integer] :lineno associated with message
    #   @option options [Logger, #<<] :logger
    #   @yieldreturn [String] added to message
    #   @return [void]
    def log_info(*args, &block)
      options = args.last.is_a?(Hash) ? args.pop : {}
      logger_common(*args, options.merge(level: :info), &block)
    end

    ##
    # Debug message.
    #
    # @overload recover(*args, options = {}, &block)
    #   @param [Array<String>] args
    #   @param [Array<String>] args Messages
    #   @param [Hash{Symbol => Object}] options
    #   @option options [Integer] :depth (@options[:depth] || @depth)
    #     Recursion depth for indenting output
    #   @option options [:fatal, :error, :warning, :info, :debug] level (:<<)
    #   @option options [Integer] :lineno associated with message
    #   @option options [Logger, #<<] :logger
    #   @yieldreturn [String] added to message
    #   @return [void]
    def log_debug(*args, &block)
      options = args.last.is_a?(Hash) ? args.pop : {}
      logger_common(*args, options.merge(level: :info), &block)
    end

    # Increase depth around a method invocation
    # @param [Hash{Symbol}] options (@options || {})
    # @option options [Integer] :log_depth
    # @yield
    #   Yields with no arguments
    # @yieldreturn [Object] returns the result of yielding
    # @return [Object]
    def log_depth(options = nil)
      options ||= @options || {}
      options[:log_depth] ||= 0
      options[:log_depth] += 1
      ret = yield
      options[:log_depth] -= 1
      ret
    end

  private
    ##
    # Common method for logging messages
    #
    # The call is ignored, unless `@logger` or `@options[:logger]` is set, in which case it records tracing information as indicated.
    #
    # @param [Array<String>] args Messages
    # @param [Hash{Symbol => Object}] options
    # @option options [Integer] :depth (@options[:depth] || @depth)
    #   Recursion depth for indenting output
    # @option options [:fatal, :error, :warning, :info, :debug] level (:<<)
    # @option options [Integer] :lineno associated with message
    # @option options [Logger, #<<] :logger
    # @yieldreturn [String] added to message
    # @return [void]
    def logger_common(*args)
      options = args.last.is_a?(Hash) ? args.pop : {}
      logger = options[:logger] || @logger || (@options || {})[:logger]
      level = options[:level]
      logger ||= $stderr if [:fatal, :error].include?(level)
      return unless logger

      depth = options[:log_depth] || (@options || {})[:log_depth] || 0
      args << yield if block_given?
      message = args.join(": ")
      d_str = depth > 100 ? ' ' * 100 + '+' : ' ' * depth
      str = "#{d_str}#{message}"
      str = "[line #{options[:lineno]}] #{str}" if options[:lineno]

      if level && logger.respond_to?(level)
        logger.__send__(level, str)
      elsif logger.respond_to?(:write)
        logger.write "#{level.to_s.upcase} #{str}\n"
      else
        logger << "#{level.to_s.upcase} #{str}"
      end
    end
  end # Logger
end; end # RDF::Util
