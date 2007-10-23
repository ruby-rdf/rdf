module RDF
  Namespace.register!(
    :rdf     => 'http://www.w3.org/1999/02/22-rdf-syntax-ns#',
    :rdfs    => 'http://www.w3.org/2000/01/rdf-schema#',
    :xsd     => 'http://www.w3.org/2001/XMLSchema#',
    :xsi     => 'http://www.w3.org/2001/XMLSchema-instance#',
    :owl     => 'http://www.w3.org/2002/07/owl#',
    :dc      => 'http://purl.org/dc/elements/1.1/',
    :dcterms => 'http://purl.org/dc/terms/')

  module Namespaces
    RDF  = Namespace[:rdf]
    RDFS = Namespace[:rdfs]
    XSD  = Namespace[:xsd]
    OWL  = Namespace[:owl]
    DC   = Namespace[:dc]
  end
end
