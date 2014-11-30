require 'net/http'
require 'rest_client'
require 'link_header'
require 'time'

module RDF; module Util
  ##
  # Wrapper for [Rest Client](https://rubygems.org/gems/rest-client).
  #
  # Also supports the file: scheme for access to local files.
  #
  # Sophisticated HTTP caching can be supplemented using [REST Client Components](https://rubygems.org/gems/rest-client-components) allowing the use of `Rack::Cache` as a local file cache.
  #
  # @since 0.2.4
  module File
    ##
    # Open the file, returning or yielding {RemoteDocument}.
    #
    # Adds Accept header based on available reader content types to allow
    # for content negotiation based on available readers.
    #
    # When retrieving documents over HTTP(S), use the mechanism described in [Providing and Discovering URI Documentation](http://www.w3.org/2001/tag/awwsw/issue57/latest/) to pass the appropriate `base_uri` to the block or as the return.
    #
    # Applications needing HTTP caching may consider [REST Client Components](https://rubygems.org/gems/rest-client-components)allowing the use of `Rack::Cache` as a local file cache.
    #
    # @example using a local HTTP cache
    #    require 'restclient/components'
    #    require 'rack/cache'
    #    RestClient.enable Rack::Cache
    #    RDF::Util::File.open_file("http://example.org/some/resource")
    #      # => Cached resource if current, otherwise returned resource
    #
    # @param [String] filename_or_url to open
    # @param  [Hash{Symbol => Object}] options
    #   options are ignored in this implementation. Applications are encouraged
    #   to override this implementation to provide more control over HTTP
    #   headers and redirect following. If opening as a file,
    #   options are passed to `Kernel.open`.
    # @option options [Array, String] :headers
    #   HTTP Request headers, passed to Kernel.open.
    # @return [IO, RemoteDocument] A {RemoteDocument} or `IO` for local files
    # @yield [IO, RemoteDocument] A {RemoteDocument} or `IO` for local files
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

        remote_document = nil
        base_uri = filename_or_url.to_s

        result = RestClient.get(base_uri, headers) do |response, request, result, &block|
          case response.code
          when 200..299
            # found object

            # If a Location is returned, it defines the base resource for this file, not it's actual ending location
            document_options = {
              base_uri:     RDF::URI(response.headers.fetch(:location, base_uri)),
              charset:      Encoding::UTF_8,
              code:         response.code.to_i,
              headers:      response.headers
            }

            remote_document = RemoteDocument.new(response.body, document_options)

            # Yield the result and close, or cause it to be returned
            result = if block_given?
              ret = yield remote_document
              remote_document.close
              ret
            else
              remote_document
            end
            
          when 300..399
            base_uri = response.headers[:location].to_s
            response.follow_redirection(request, result, &block)
          else
            raise IOError, "<#{base_uri}>: #{response.msg}(#{response.code})"
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

      # Response code
      # @return [Integer]
      attr_reader :code

      ##
      # ETag from headers
      # @return [String]
      attr_reader :etag

      # Last-Modified time from headers
      # @return [DateTime]
      attr_reader :last_modified

      # Raw headers from response
      # @return [Hash{String => Object}]
      attr_reader :headers

      # Originally requested URL
      # @return [String]
      attr_reader :requested_url

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

        # Find Content-Type
        if !@content_type && headers[:content_type]
          @content_type, *params = headers[:content_type].split(';').map(&:strip)

          # Find charset
          params.each do |param|
            p, v = param.split('=')
            next unless p.downcase == 'charset'
            @charset = v.sub(/^["']?(.*)["']?$/, '\1')
          end
        end

        @etag = headers[:etag]
        @last_modified = DateTime.parse(headers[:last_modified]) if headers[:last_modified]

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
        @links ||= LinkHeader.parse(@headers[:link])
      end
    end
  end # File
end; end # RDF::Util
