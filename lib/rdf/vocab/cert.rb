module RDF
  ##
  # W3 Authentication Certificates (CERT) vocabulary.
  #
  # @see http://www.w3.org/ns/auth/cert#
  class CERT < Vocabulary("http://www.w3.org/ns/auth/cert#")
    property :decimal
    property :hex
    property :identity
    property :public_key
  end
end
