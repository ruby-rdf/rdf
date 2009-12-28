require 'rdf'
require 'optparse'

module RDF
  class CLI
    ##
    # @return [String]
    def self.basename() File.basename($0) end

    ##
    # @yield  [options]
    # @yieldparam [OptionParser]
    # @return [OptionParser]
    def self.options(&block)
      options = OptionParser.new

      if block_given?
        case block.arity
          when 1 then block.call(options)
          else options.instance_eval(&block)
        end
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
    def self.exec_command(command, *args)
      if binary = RDF::CLI.find_binary(command)
        exec(binary, *args)
      else
        false
      end
    end

    ##
    # @param  [String] command
    # @return [String, nil]
    def self.find_binary(command)
      binary = File.join(File.dirname(__FILE__), '..', '..', 'bin', 'rdf-' + command)
      File.exists?(binary) ? binary : nil
    end

    ##
    # @param  [Array<String>] files
    # @yield  [statement]
    # @yieldparam [Statement]
    # @return [nil]
    def self.each_statement(*files, &block)
      files.each do |file|
        RDF::NTriples::Reader.open(file) do |reader|
          reader.each_statement(&block)
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
