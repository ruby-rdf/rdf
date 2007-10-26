require 'rdf'

class TestNamespaces < Test::Unit::TestCase
  include RDF
  include RDF::Namespaces

  def test_namespace_registration
    Namespace.register! :eg, 'http://example.org/test#'
    assert Namespace.prefixes.has_key?(:eg)

    assert_equal Namespace.prefixes[:eg], 'http://example.org/test#'

    Namespace.unregister! :eg
    assert !Namespace.prefixes.has_key?(:eg)
  end

  def test_namespace_predicates
    Namespace.register! :eg, 'http://example.org/test#'
    eg = Namespace[:eg]

    assert_kind_of URIRef, eg['arbitrary']
    assert_equal eg['arbitrary'], eg.arbitrary
    assert_equal eg['name'].to_uri, 'http://example.org/test#name'
    assert_equal eg.name.to_uri, 'http://example.org/test#name'
    assert_equal eg.compound_name.to_uri, 'http://example.org/test#compound-name'
  end

end
