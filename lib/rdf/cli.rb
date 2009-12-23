require 'rdf'
require 'optparse'

module RDF
  class CLI
    def self.basename() File.basename($0) end

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

    def self.exec_command(command, *args)
      if binary = RDF::CLI.find_binary(command)
        exec(binary, *args)
      else
        false
      end
    end

    def self.find_binary(command)
      binary = File.join(File.dirname(__FILE__), '..', '..', 'bin', 'rdf-' + command)
      File.exists?(binary) ? binary : nil
    end

    def self.each_statement(*files, &block)
      files.each do |file|
        RDF::Reader::NTriples.open(file) do |reader|
          reader.each_statement(&block)
        end
      end
    end

    def self.abort(msg)
      Kernel.abort "#{basename}: #{msg}"
    end
  end
end
