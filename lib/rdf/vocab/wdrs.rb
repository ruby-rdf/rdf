# This file generated automatically using vocab-fetch from http://www.w3.org/2007/05/powder-s#
require 'rdf'
module RDF
  class WDRS < StrictVocabulary("http://www.w3.org/2007/05/powder-s#")

    # Class definitions
    property :Document, :label => 'POWDER document', :comment =>
      %(A POWDER document.)
    property :Processor, :label => 'POWDER processor', :comment =>
      %(A software agent able to process POWDER documents.)

    # Property definitions
    property :sha1sum, :label => 'SHA-1 sum', :comment =>
      %(Links to a Base64-encoded binary SHA-1 hash of the described
        resource. May be used by POWDER Processors when assessing
        trustworthiness of a DR.)
    property :authenticate, :label => 'authenticate', :comment =>
      %(A pointer to a document that describes how Description
        Resources created by a FOAF Agent or a DC Terms Agent may be
        authenticated)
    property :certified, :label => 'certified', :comment =>
      %(A property that takes a Boolean value to declare whether the
        author of the data certifies the described resource.)
    property :certifiedby, :label => 'certified by', :comment =>
      %(A property that links a resource to a POWDER document that
        certifies it.)
    property :data_error, :label => 'data error', :comment =>
      %(A property denoting a description of the specific error found
        in a given POWDER document.)
    property :describedby, :label => 'described by', :comment =>
      %(An RDF property to exactly match the describedby relationship
        type introduced in
        http://www.w3.org/TR/powder-dr/#assoc-linking and formally
        defined in appendix D of the same document, i.e. the
        relationship A 'describedby' B asserts that resource B
        provides a description of resource A. There are no constraints
        on the format or representation of either A or B, neither are
        there any further constraints on either resource.)
    property :error_code, :label => 'error code', :comment =>
      %(A property denoting the code of any error encountered by the
        POWDER processor.)
    property :hasIRI, :label => 'has IRI', :comment =>
      %(This property is meant to be used in OWL2 instead of
        wdrs:matchesregex. It denotes the string data range
        corresponding to a set of IRIs.)
    property :issuedby, :label => 'issued by', :comment =>
      %(This property denotes the author of a POWDER document.)
    property :logo, :label => 'logo', :comment =>
      %(Points to a graphic summary for the resources in a given
        class. Typically, it is a logo denoting conformance of a given
        \(set of\) resource\(s\) to a given set of criteria.)
    property :notmatchesregex, :label => 'matches regular expression', :comment =>
      %(This is the key 'exclude' property for IRI set definitions in
        POWDER-S. It is necessary to take account of the POWDER
        Semantic Extension to process this fully. The value is a
        regular expression that is matched against an IRI.)
    property :matchesregex, :label => 'matches regular expression', :comment =>
      %(This is the key 'include' property for IRI set definitions in
        POWDER-S. It is necessary to take account of the POWDER
        Semantic Extension to process this fully. The value is a
        regular expression that is matched against an IRI.)
    property :notknownto, :label => 'not known to', :comment =>
      %(Property used in results returned from a POWDER Processor that
        has no data about the candidate resource. The value is the IRI
        of the processor.)
    property :proc_error, :label => 'processing error', :comment =>
      %(A property denoting a description of the specific software
        error.)
    property :supportedby, :label => 'supported by', :comment =>
      %(A property that links a POWDER document to some other data
        source that supports the descriptions provided.)
    property :tag, :label => 'tag', :comment =>
      %(Property linking to a free-text tag which may include spaces.)
    property :text, :label => 'text that may be displayed', :comment =>
      %(This property provides a summary of the descriptorset that it
        annotates, suitable for display to end users.)
    property :validfrom, :label => 'valid from', :comment =>
      %(Provides a timestamp that a POWDER Processor may use when
        assessing trustworthiness of a POWDER document. Informally, a
        POWDER Processor should normally ignore data in the document
        before the given date.)
    property :validuntil, :label => 'valid until', :comment =>
      %(Provides a timestamp that a POWDER Processor may use when
        assessing trustworthiness of a POWDER document. Informally, a
        POWDER Processor should normally ignore data in the document
        after the given date.)
    property :hasIRI, :label => 'has IRI', :comment =>
      %(This property is meant to be used in OWL2 instead of
        wdrs:matchesregex. It denotes the string data range
        corresponding to a set of IRIs.)
    property :matchesregex, :label => 'matches regular expression', :comment =>
      %(This is the key 'include' property for IRI set definitions in
        POWDER-S. It is necessary to take account of the POWDER
        Semantic Extension to process this fully. The value is a
        regular expression that is matched against an IRI.)
    property :notmatchesregex, :label => 'matches regular expression', :comment =>
      %(This is the key 'exclude' property for IRI set definitions in
        POWDER-S. It is necessary to take account of the POWDER
        Semantic Extension to process this fully. The value is a
        regular expression that is matched against an IRI.)
    property :tag, :label => 'tag', :comment =>
      %(Property linking to a free-text tag which may include spaces.)
    property :certifiedby, :label => 'certified by', :comment =>
      %(A property that links a resource to a POWDER document that
        certifies it.)
    property :issuedby, :label => 'issued by', :comment =>
      %(This property denotes the author of a POWDER document.)
    property :logo, :label => 'logo', :comment =>
      %(Points to a graphic summary for the resources in a given
        class. Typically, it is a logo denoting conformance of a given
        \(set of\) resource\(s\) to a given set of criteria.)
    property :supportedby, :label => 'supported by', :comment =>
      %(A property that links a POWDER document to some other data
        source that supports the descriptions provided.)
    property :text, :label => 'text that may be displayed', :comment =>
      %(This property provides a summary of the descriptorset that it
        annotates, suitable for display to end users.)
    property :validfrom, :label => 'valid from', :comment =>
      %(Provides a timestamp that a POWDER Processor may use when
        assessing trustworthiness of a POWDER document. Informally, a
        POWDER Processor should normally ignore data in the document
        before the given date.)
    property :validuntil, :label => 'valid until', :comment =>
      %(Provides a timestamp that a POWDER Processor may use when
        assessing trustworthiness of a POWDER document. Informally, a
        POWDER Processor should normally ignore data in the document
        after the given date.)
  end
end
