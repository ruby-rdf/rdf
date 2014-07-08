# -*- encoding: utf-8 -*-
# This file generated automatically using vocab-fetch from http://www.w3.org/2006/http#
require 'rdf'
module RDF
  class HT < RDF::StrictVocabulary("http://www.w3.org/2006/http#")

    # Class definitions
    term :ConnectRequest,
      comment: %(The CONNECT request).freeze,
      label: "Connect".freeze,
      subClassOf: "ht:Request".freeze,
      type: "rdfs:Class".freeze
    term :Connection,
      comment: %(An HTTP connection).freeze,
      label: "Connection".freeze,
      type: "rdfs:Class".freeze
    term :DeleteRequest,
      comment: %(The DELETE request).freeze,
      label: "Delete".freeze,
      subClassOf: "ht:Request".freeze,
      type: "rdfs:Class".freeze
    term :GetRequest,
      comment: %(The GET request).freeze,
      label: "Get".freeze,
      subClassOf: "ht:Request".freeze,
      type: "rdfs:Class".freeze
    term :HeadRequest,
      comment: %(The HEAD request).freeze,
      label: "Head".freeze,
      subClassOf: "ht:Request".freeze,
      type: "rdfs:Class".freeze
    term :HeaderElement,
      comment: %(An element of a comma-separated list in a field value).freeze,
      label: "Header element".freeze,
      type: "rdfs:Class".freeze
    term :HeaderName,
      label: "HeaderName".freeze,
      type: "owl:Class".freeze
    term :MessageHeader,
      comment: %(A message header according to section 4.2 of HTTP 1.1).freeze,
      label: "Message header".freeze,
      type: "rdfs:Class".freeze
    term :NewResponseCode,
      comment: %(New HTTP Response Code. If you want to define new header names, subclass this stub.).freeze,
      label: "New Response Code".freeze,
      type: ["owl:Thing".freeze, "rdfs:Class".freeze]
    term :OptionsRequest,
      comment: %(The OPTIONS request).freeze,
      label: "Options".freeze,
      subClassOf: "ht:Request".freeze,
      type: "rdfs:Class".freeze
    term :Param,
      comment: %(A parameter for a header element).freeze,
      label: "Parameter".freeze,
      type: "rdfs:Class".freeze
    term :PostRequest,
      comment: %(The POST request).freeze,
      label: "Post".freeze,
      subClassOf: "ht:Request".freeze,
      type: "rdfs:Class".freeze
    term :PutRequest,
      comment: %(The PUT request).freeze,
      label: "Put".freeze,
      subClassOf: "ht:Request".freeze,
      type: "rdfs:Class".freeze
    term :Request,
      comment: %(An HTTP request).freeze,
      label: "Request".freeze,
      type: "rdfs:Class".freeze
    term :RequestURI,
      comment: %(The HTTP request URI).freeze,
      label: "Request URI".freeze,
      type: "rdfs:Class".freeze
    term :Response,
      comment: %(The HTTP Response).freeze,
      label: "Response".freeze,
      type: "rdfs:Class".freeze
    term :ResponseCode,
      comment: %(The HTTP Response Code).freeze,
      label: "Response code".freeze,
      type: ["owl:Class".freeze, "rdfs:Class".freeze]
    term :TraceRequest,
      comment: %(The TRACE request).freeze,
      label: "Trace".freeze,
      subClassOf: "ht:Request".freeze,
      type: "rdfs:Class".freeze

    # Property definitions
    property :abs_path,
      comment: %(An absolute path used as request URI).freeze,
      label: "Absolute path".freeze,
      subPropertyOf: "ht:requestURI".freeze,
      type: "rdf:Property".freeze
    property :absoluteURI,
      comment: %(An absolute request URI).freeze,
      label: "Absolute request URI".freeze,
      subPropertyOf: "ht:requestURI".freeze,
      type: "rdf:Property".freeze
    property :authority,
      comment: %(An authority used as request URI).freeze,
      label: "Authority".freeze,
      subPropertyOf: "ht:requestURI".freeze,
      type: "rdf:Property".freeze
    property :body,
      comment: %(The HTTP entity body).freeze,
      label: "Entity body".freeze,
      type: "rdf:Property".freeze
    property :connectionAuthority,
      comment: %(An HTTP Connection authority).freeze,
      domain: "ht:Connection".freeze,
      label: "Connection authority".freeze,
      type: "rdf:Property".freeze
    property :elementName,
      comment: %(Has an element name).freeze,
      domain: "ht:HeaderElement".freeze,
      label: "Element name".freeze,
      range: "rdfs:Literal".freeze,
      type: "rdf:Property".freeze
    property :elementValue,
      comment: %(Has an element value).freeze,
      domain: "ht:HeaderElement".freeze,
      label: "Element value".freeze,
      range: "rdfs:Literal".freeze,
      type: "rdf:Property".freeze
    property :fieldName,
      comment: %(Has a field name).freeze,
      domain: "ht:MessageHeader".freeze,
      label: "Field name".freeze,
      type: "rdf:Property".freeze
    property :fieldValue,
      comment: %(Has a field value).freeze,
      domain: "ht:MessageHeader".freeze,
      label: "Field value".freeze,
      type: "rdf:Property".freeze
    property :header,
      comment: %(Has a header).freeze,
      label: "Header".freeze,
      range: "ht:MessageHeader".freeze,
      type: "rdf:Property".freeze
    property :param,
      comment: %(Has a parameter).freeze,
      domain: "ht:HeaderElement".freeze,
      label: "Parameter".freeze,
      range: "ht:Param".freeze,
      type: "rdf:Property".freeze
    property :paramName,
      comment: %(Has a parameter name).freeze,
      domain: "ht:Param".freeze,
      label: "Parameter name".freeze,
      range: "rdfs:Literal".freeze,
      type: "rdf:Property".freeze
    property :paramValue,
      comment: %(Has a parameter value).freeze,
      domain: "ht:Param".freeze,
      label: "Parameter value".freeze,
      range: "rdfs:Literal".freeze,
      type: "rdf:Property".freeze
    property :request,
      comment: %(Has an HTTP request).freeze,
      domain: "ht:Connection".freeze,
      label: "Request".freeze,
      range: "ht:Request".freeze,
      type: "rdf:Property".freeze
    property :requestURI,
      comment: %(Has an HTTP request URI).freeze,
      domain: "ht:Request".freeze,
      label: "Request URI".freeze,
      range: "ht:RequestURI".freeze,
      type: "rdf:Property".freeze
    property :response,
      comment: %(Has an HTTP response).freeze,
      domain: "ht:Request".freeze,
      label: "Response".freeze,
      range: "ht:Response".freeze,
      type: "rdf:Property".freeze
    property :responseCode,
      comment: %(Has an HTTP response code).freeze,
      domain: "ht:Response".freeze,
      label: "Response code".freeze,
      type: "rdf:Property".freeze
    property :version,
      comment: %(The HTTP version).freeze,
      label: "Version".freeze,
      type: "rdf:Property".freeze

    # Extra definitions
    term :"",
      comment: [%(A namespace for describing HTTP messages
   \(http://www.w3.org/Protocols/rfc2616/rfc2616.html\)).freeze, %(This has been obsoleted by http://www.w3.org/2011/http.rdfs).freeze],
      label: "".freeze,
      "rdfs:seeAlso" => %(http://www.w3.org/2011/http.rdfs).freeze
    term :"100",
      label: "Continue".freeze,
      type: "owl:Thing".freeze
    term :"101",
      label: "Switching Protocols".freeze,
      type: "owl:Thing".freeze
    term :"200",
      label: "OK".freeze,
      type: "owl:Thing".freeze
    term :"201",
      label: "Created".freeze,
      type: "owl:Thing".freeze
    term :"202",
      label: "Accepted".freeze,
      type: "owl:Thing".freeze
    term :"203",
      label: "Non-Authoritative Information".freeze,
      type: "owl:Thing".freeze
    term :"204",
      label: "No Content".freeze,
      type: "owl:Thing".freeze
    term :"205",
      label: "Reset Content".freeze,
      type: "owl:Thing".freeze
    term :"206",
      label: "Partial Content".freeze,
      type: "owl:Thing".freeze
    term :"300",
      label: "Multiple Choices".freeze,
      type: "owl:Thing".freeze
    term :"301",
      label: "Moved Permanently".freeze,
      type: "owl:Thing".freeze
    term :"302",
      label: "Found".freeze,
      type: "owl:Thing".freeze
    term :"303",
      label: "See Other".freeze,
      type: "owl:Thing".freeze
    term :"304",
      label: "Not Modified".freeze,
      type: "owl:Thing".freeze
    term :"305",
      label: "Use Proxy".freeze,
      type: "owl:Thing".freeze
    term :"306",
      label: "(Unused)".freeze,
      type: "owl:Thing".freeze
    term :"307",
      label: "Temporary Redirect".freeze,
      type: "owl:Thing".freeze
    term :"400",
      label: "Bad Request".freeze,
      type: "owl:Thing".freeze
    term :"401",
      label: "Unauthorized".freeze,
      type: "owl:Thing".freeze
    term :"402",
      label: "Payment Required".freeze,
      type: "owl:Thing".freeze
    term :"403",
      label: "Forbidden".freeze,
      type: "owl:Thing".freeze
    term :"404",
      label: "Not Found".freeze,
      type: "owl:Thing".freeze
    term :"405",
      label: "Method Not Allowed".freeze,
      type: "owl:Thing".freeze
    term :"406",
      label: "Not Acceptable".freeze,
      type: "owl:Thing".freeze
    term :"407",
      label: "Proxy Authentication Required".freeze,
      type: "owl:Thing".freeze
    term :"408",
      label: "Request Timeout".freeze,
      type: "owl:Thing".freeze
    term :"409",
      label: "Conflict".freeze,
      type: "owl:Thing".freeze
    term :"410",
      label: "Gone".freeze,
      type: "owl:Thing".freeze
    term :"411",
      label: "Length Required".freeze,
      type: "owl:Thing".freeze
    term :"412",
      label: "Precondition Failed".freeze,
      type: "owl:Thing".freeze
    term :"413",
      label: "Request Entity Too Large".freeze,
      type: "owl:Thing".freeze
    term :"414",
      label: "Request-URI Too Long".freeze,
      type: "owl:Thing".freeze
    term :"415",
      label: "Unsupported Media Type".freeze,
      type: "owl:Thing".freeze
    term :"416",
      label: "Requested Range Not Satisfiable".freeze,
      type: "owl:Thing".freeze
    term :"417",
      label: "Expectation Failed".freeze,
      type: "owl:Thing".freeze
    term :"500",
      label: "Internal Server Error".freeze,
      type: "owl:Thing".freeze
    term :"501",
      label: "Not Implemented".freeze,
      type: "owl:Thing".freeze
    term :"502",
      label: "Bad Gateway".freeze,
      type: "owl:Thing".freeze
    term :"503",
      label: "Service Unavailable".freeze,
      type: "owl:Thing".freeze
    term :"504",
      label: "Gateway Timeout".freeze,
      type: "owl:Thing".freeze
    term :"505",
      label: "HTTP Version Not Supported".freeze,
      type: "owl:Thing".freeze
    term :asterisk,
      comment: %(An asterisk used as request URI).freeze,
      label: "Asterisk".freeze,
      type: "owl:Thing".freeze
  end
end
