module RDF
  ##
  # Hypertext Transfer Protocol (HTTP) vocabulary.
  #
  # @see http://www.w3.org/2006/http
  class HTTP < Vocabulary("http://www.w3.org/2006/http#")
    property :abs_path
    property :absoluteURI
    property :authority
    property :body
    property :connectionAuthority
    property :elementName
    property :elementValue
    property :fieldName
    property :fieldValue
    property :header
    property :param
    property :paramName
    property :paramValue
    property :request
    property :requestURI
    property :response
    property :responseCode
    property :version
  end
end
