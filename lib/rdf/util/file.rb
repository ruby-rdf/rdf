require 'net/http'
require 'openssl'
require 'link_header'
require 'time'

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
    # When retrieving documents over HTTP(S), use the mechanism described in [Providing and Discovering URI Documentation](http://www.w3.org/2001/tag/awwsw/issue57/latest/) to pass the appropriate `base_uri` to the block or as the return.
    #
    # @param [String] filename_or_url to open
    # @param  [Hash{Symbol => Object}] options
    #   options are ignored in this implementation. Applications are encouraged
    #   to override this implementation to provide more control over HTTP
    #   headers and redirect following. If opening as a file,
    #   options are passed to `Kernel.open`.
    # @option options [Array, String] :headers
    #   HTTP Request headers, passed to Kernel.open.
    # @return [IO, RemoteDocument] File stream with no block, and the block return otherwise
    # @yield [IO, RemoteDocument] File stream
    def self.open_file(filename_or_url, options = {}, &block)
      filename_or_url = $1 if filename_or_url.to_s.match(/^file:(.*)$/)
      if filename_or_url.to_s =~ /^https?/
        # Open as a URL with Net::HTTP
        headers = options.fetch(:headers, {})
        # Receive text/html and text/plain at a lower priority than other formats
        reader_types = RDF::Format.reader_types.map do |t|
          t.to_s =~ /text\/(?:plain|html)/  ? "#{t};q=0.5" : t
        end
        headers['Accept'] ||= (reader_types + %w(*/*;q=0.1)).join(", ")

        redirect_count = 0
        max_redirects = 5
        remote_document = nil
        parsed_url = ::URI.parse(filename_or_url.to_s)
        base_uri = parsed_url.to_s
        result = nil
        until remote_document do
          Net::HTTP::start(parsed_url.host, parsed_url.port,
                          open_timeout: 60 * 1000,
                          use_ssl: parsed_url.scheme == 'https',
                          verify_mode: OpenSSL::SSL::VERIFY_NONE
          ) do |http|
            request = Net::HTTP::Get.new(parsed_url.request_uri, headers)
            http.request(request) do |response|
              case response
              when Net::HTTPSuccess
                # found object

                # If a Location is returned, it defines the base resource for this file, not it's actual ending location
                document_options = {
                  base_uri:     RDF::URI(response["Location"] ? response["Location"] : base_uri),
                  charset:      Encoding::UTF_8,
                  code:         response.code.to_i,
                  content_type: response.content_type,
                  headers:      response.to_hash
                }.merge(response.type_params)
                document_options[:last_modified] = DateTime.parse(response["Last-Modified"]) if response["Last-Modified"]

                remote_document = RemoteDocument.new(response.body, document_options)

                # Yield the result and close, or cause it to be returned
                result = if block_given?
                  ret = yield remote_document
                  remote_document.close
                  ret
                else
                  remote_document
                end
              when Net::HTTPRedirection
                # Follow redirection
                raise IOError, "Too many redirects" if (redirect_count += 1) > max_redirects

                parsed_url = ::URI.parse(response["Location"])

                # If response is not a status 303, update base_uri too
                base_uri = parsed_url.to_s unless response.code == "303"
              else
                raise IOError, "<#{parsed_url}>: #{response.msg}(#{response.code})"
              end
            end
          end
        end
        result
      else
        # Open as a file, passing any options
        Kernel.open(filename_or_url, "r", options, &block)
      end
    end

    ##
    # A RemoteDocument contains the body and headers of a remote resource.
    #
    # Link headers are parsed using the `LinkHeader` gem
    # @see https://github.com/asplake/link_header
    class RemoteDocument < StringIO
      # Base URI based on resource location or returned Location header.
      # @return [String]
      attr_reader :base_uri

      # Content-Type of the returned resource
      # @return [String]
      attr_reader :content_type

      # Encoding of resource (from header), also applied to content
      # @return [Encoding}]
      attr_reader :charset

      # Last-Modified time from headers
      # @return [DateTime]
      attr_reader :last_modified

      # Raw headers from response
      # @return [Hash{String => Object}]
      attr_reader :headers

      # Response code
      # @return [Integer]
      attr_reader :code

      ##
      # Set content
      def initialize(body, options = {})
        super(body)
        options.each do |key, value|
          # de-quote charset
          matchdata = value.match(/^["'](.*)["']$/.freeze) if key == "charset"
          value = matchdata[1] if matchdata
          instance_variable_set(:"@#{key}", value)
        end
        @headers ||= {}
        set_encoding Encoding.find(@charset) if @charset
      end

      ##
      # Content encoding, based on {#charset} normalized to lower-case
      # @return [String]
      def content_encoding
        charset.to_s.downcase
      end

      ##
      # Return links from the Link header.
      #
      # Links can be returned in array form, or searched.
      #
      # @example
      #
      #     d = RemoteDocument.new(...)
      #     describedby = links.find_link('rel' => 'describedby)
      #
      # @return [::LinkHeader]
      def links
        @links ||= LinkHeader.parse(Array(@headers['link']).join(','))
      end

      ##
      # ETag from headers
      # @return [String]
      def etag
        Array(@headers['etag']).first
      end
    end
  end # File
end; end # RDF::Util
