module RDF
  Namespace.register!(
    :rdf     => 'http://www.w3.org/1999/02/22-rdf-syntax-ns#',
    :rdfs    => 'http://www.w3.org/2000/01/rdf-schema#',
    :xsd     => 'http://www.w3.org/2001/XMLSchema#',
    :xsi     => 'http://www.w3.org/2001/XMLSchema-instance#',
    :owl     => 'http://www.w3.org/2002/07/owl#',
    :dc      => 'http://purl.org/dc/elements/1.1/',
    :dcterms => 'http://purl.org/dc/terms/',
    :foaf    => 'http://xmlns.com/foaf/0.1/',
    :doap    => 'http://usefulinc.com/ns/doap#',
    :skos    => 'http://www.w3.org/2004/02/skos/core#')

  module Namespaces
    RDF  = Namespace[:rdf]
    RDFS = Namespace[:rdfs]
    XSD  = Namespace[:xsd]
    OWL  = Namespace[:owl]
    DC   = Namespace[:dc]
    FOAF = Namespace[:foaf]
    DOAP = Namespace[:doap]
    SKOS = Namespace[:skos]
  end
end
