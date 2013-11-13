# This file generated automatically using vocab-fetch from http://www.w3.org/2006/http#
require 'rdf'
module RDF
  class HTTP < StrictVocabulary("http://www.w3.org/2006/http#")

    # Class definitions
    property :ConnectRequest, :label => 'Connect', :comment =>
      %(The CONNECT request)
    property :Connection, :label => 'Connection', :comment =>
      %(An HTTP connection)
    property :DeleteRequest, :label => 'Delete', :comment =>
      %(The DELETE request)
    property :GetRequest, :label => 'Get', :comment =>
      %(The GET request)
    property :HeadRequest, :label => 'Head', :comment =>
      %(The HEAD request)
    property :HeaderElement, :label => 'Header element', :comment =>
      %(An element of a comma-separated list in a field value)
    property :MessageHeader, :label => 'Message header', :comment =>
      %(A message header according to section 4.2 of HTTP 1.1)
    property :NewResponseCode, :label => 'New Response Code', :comment =>
      %(New HTTP Response Code. If you want to define new header
        names, subclass this stub.)
    property :OptionsRequest, :label => 'Options', :comment =>
      %(The OPTIONS request)
    property :Param, :label => 'Parameter', :comment =>
      %(A parameter for a header element)
    property :PostRequest, :label => 'Post', :comment =>
      %(The POST request)
    property :PutRequest, :label => 'Put', :comment =>
      %(The PUT request)
    property :Request, :label => 'Request', :comment =>
      %(An HTTP request)
    property :RequestURI, :label => 'Request URI', :comment =>
      %(The HTTP request URI)
    property :Response, :label => 'Response', :comment =>
      %(The HTTP Response)
    property :ResponseCode, :label => 'Response code', :comment =>
      %(The HTTP Response Code)
    property :ResponseCode, :label => 'Response code', :comment =>
      %(The HTTP Response Code)
    property :TraceRequest, :label => 'Trace', :comment =>
      %(The TRACE request)
    property :HeaderName

    # Property definitions
    property :abs_path, :label => 'Absolute path', :comment =>
      %(An absolute path used as request URI)
    property :absoluteURI, :label => 'Absolute request URI', :comment =>
      %(An absolute request URI)
    property :authority, :label => 'Authority', :comment =>
      %(An authority used as request URI)
    property :connectionAuthority, :label => 'Connection authority', :comment =>
      %(An HTTP Connection authority)
    property :elementName, :label => 'Element name', :comment =>
      %(Has an element name)
    property :elementValue, :label => 'Element value', :comment =>
      %(Has an element value)
    property :body, :label => 'Entity body', :comment =>
      %(The HTTP entity body)
    property :fieldName, :label => 'Field name', :comment =>
      %(Has a field name)
    property :fieldValue, :label => 'Field value', :comment =>
      %(Has a field value)
    property :header, :label => 'Header', :comment =>
      %(Has a header)
    property :param, :label => 'Parameter', :comment =>
      %(Has a parameter)
    property :paramName, :label => 'Parameter name', :comment =>
      %(Has a parameter name)
    property :paramValue, :label => 'Parameter value', :comment =>
      %(Has a parameter value)
    property :request, :label => 'Request', :comment =>
      %(Has an HTTP request)
    property :requestURI, :label => 'Request URI', :comment =>
      %(Has an HTTP request URI)
    property :response, :label => 'Response', :comment =>
      %(Has an HTTP response)
    property :responseCode, :label => 'Response code', :comment =>
      %(Has an HTTP response code)
    property :version, :label => 'Version', :comment =>
      %(The HTTP version)
  end
end
