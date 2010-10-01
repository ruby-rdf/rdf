module RDF; module Util
  ##
  # Wrapper for Kernel.open. Allows implementations to override to get
  # more suffisticated behavior for HTTP resources
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
    #
    # @param [String] filename_or_url to open
    # @param  [Hash{Symbol => Object}] options
    #   any options to pass through to the underlying UUID library
    # @return [IO] File stream
    # @yield [IO] File stream
    def self.open_file(filename_or_url, options = {}, &block)
      Kernel.open(filename_or_url, &block)
    end
  end # File
end; end # RDF::Util
