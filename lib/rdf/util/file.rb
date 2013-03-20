module RDF; module Util
  ##
  # Wrapper for Kernel.open. Allows implementations to override to get
  # more suffisticated behavior for HTTP resources (e.g., Accept header).
  #
  # Also supports the file: scheme for access to local files.
  #
  # Classes include this module when they represent some form of a file
  # as a base resource, for instance an HTTP resource representing the
  # serialization of a Graph.
  #
  # This module may be monkey-patched to allow for more options
  # and interfaces.
  #
  # @since 0.2.4
  module File
    # Content
    # @return [String] 
    attr_accessor :content_type
    
    ##
    # Open the file, returning or yielding an IO stream and mime_type.
    # Adds Accept header based on available reader content types to allow
    # for content negotiation based on available readers.
    #
    # @param [String] filename_or_url to open
    # @param  [Hash{Symbol => Object}] options
    #   options are ignored in this implementation. Applications are encouraged
    #   to override this implementation to provide more control over HTTP
    #   headers and redirect following.
    # @option options [Array, String] :headers
    #   HTTP Request headers, passed to Kernel.open. (Ruby >= 1.9 only)
    # @return [IO] File stream
    # @yield [IO] File stream
    # @note HTTP headers not passed to `Kernel.open` for Ruby versions < 1.9.
    def self.open_file(filename_or_url, options = {}, &block)
      filename_or_url = $1 if filename_or_url.to_s.match(/^file:(.*)$/)
      if RUBY_VERSION < "1.9"
        Kernel.open(filename_or_url.to_s, &block)
      else
        options[:headers] ||= {}
        options[:headers]['Accept'] ||= (RDF::Format.reader_types + %w(*/*;q=0.1)).join(", ")
        Kernel.open(filename_or_url.to_s, options[:headers], &block)
      end
    end
  end # File
end; end # RDF::Util
