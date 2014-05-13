# -*- encoding: utf-8 -*-
# This file generated automatically using vocab-fetch from http://www.w3.org/1999/02/22-rdf-syntax-ns#
require 'rdf'
module RDF
  class RDFV < StrictVocabulary("http://www.w3.org/1999/02/22-rdf-syntax-ns#")

    # Class definitions
    property :Alt, :label => 'Alt', :comment =>
      %(The class of containers of alternatives.)
    property :Bag, :label => 'Bag', :comment =>
      %(The class of unordered containers.)
    property :List, :label => 'List', :comment =>
      %(The class of RDF Lists.)
    property :Property, :label => 'Property', :comment =>
      %(The class of RDF properties.)
    property :Seq, :label => 'Seq', :comment =>
      %(The class of ordered containers.)
    property :Statement, :label => 'Statement', :comment =>
      %(The class of RDF statements.)

    # Property definitions
    property :first, :label => 'first', :comment =>
      %(The first item in the subject RDF list.)
    property :object, :label => 'object', :comment =>
      %(The object of the subject RDF statement.)
    property :predicate, :label => 'predicate', :comment =>
      %(The predicate of the subject RDF statement.)
    property :rest, :label => 'rest', :comment =>
      %(The rest of the subject RDF list after the first item.)
    property :subject, :label => 'subject', :comment =>
      %(The subject of the subject RDF statement.)
    property :type, :label => 'type', :comment =>
      %(The subject is an instance of a class.)
    property :value, :label => 'value', :comment =>
      %(Idiomatic property used for structured values.)

    # Datatype definitions
    property :HTML, :label => 'HTML', :comment =>
      %(The datatype of RDF literals storing fragments of HTML content)
    property :PlainLiteral, :label => 'PlainLiteral', :comment =>
      %(The class of plain \(i.e. untyped\) literal values, as used in
        RIF and OWL 2)
    property :XMLLiteral, :label => 'XMLLiteral', :comment =>
      %(The datatype of XML literal values.)
    property :langString, :label => 'langString', :comment =>
      %(The datatype of language-tagged string values)

    # Extra definitions
    property :about, {:comment=>"RDF/XML attribute declaring subject"}
    property :datatype, {:comment=>"RDF/XML literal datatype"}
    property :Description, {:comment=>"RDF/XML node element"}
    property :ID, {:comment=>"RDF/XML attribute creating a Reification"}
    property :li, {:comment=>"RDF/XML container membership list element"}
    property :nil, {:comment=>"The empty list, with no items in it. If the rest of a list is nil then the list has no more items in it."}
    property :nodeID, {:comment=>"RDF/XML Blank Node identifier"}
    property :object, {:comment=>"RDF/XML reification object"}
    property :parseType, {:comment=>"Parse type for RDF/XML, either Collection, Literal or Resource"}
    property :predicate, {:comment=>"RDF/XML reification predicate"}
    property :resource, {:comment=>"RDF/XML attribute declaring object"}
    property :Statement, {:comment=>"RDF/XML reification Statement"}
    property :subject, {:comment=>"RDF/XML reification subject"}
    property :Bag, {:comment=>"RDF/XML Bag container"}
    property :Alt, {:comment=>"RDF/XML Alt container"}
    property :Seq, {:comment=>"RDF/XML Seq container"}
  end
end
