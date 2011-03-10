module RDF
  ##
  # **`RDF::NQuads`** provides support for the N-Quads serialization format.
  #
  # This has not yet been implemented as of RDF.rb 0.3.x.
  module NQuads
    ##
    # N-Quads format specification.
    #
    # @example Obtaining an NQuads format class
    #   RDF::Format.for(:nquads)     #=> RDF::NQuads::Format
    #   RDF::Format.for("etc/doap.nq")
    #   RDF::Format.for(:file_name      => "etc/doap.nq")
    #   RDF::Format.for(:file_extension => "nq")
    #   RDF::Format.for(:content_type   => "text/x-nquads")
    #
    # @see http://sw.deri.org/2008/07/n-quads/#mediatype
    class Format < RDF::Format
      content_type     'text/x-nquads', :extension => :nq
      content_encoding 'ascii'

      reader { RDF::NQuads::Reader }
      writer { RDF::NQuads::Writer }
    end

    class Reader < NTriples::Reader
      # TODO
    end # Reader

    class Writer < NTriples::Writer
      # TODO
    end # Writer
  end # NQuads
end # RDF
