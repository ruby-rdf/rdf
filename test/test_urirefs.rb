require 'rdf'

class TestURIRefs < Test::Unit::TestCase
  include RDF
  include RDF::Namespaces

  URI = 'http://rdfrb.org/#test-urirefs'

  def test_known_uris
    URIRef.new(URI)
    assert URIRef.known?(URI)
  end

  def test_interned_equality
    assert_same URIRef.new(URI), URIRef.new(URI)
  end

  def test_qnames
    assert_equal 'dc:title', DC.title.qname
    assert_nil URIRef.new(URI).qname
  end

  def test_to_uri
    assert_same URI, URIRef.new(URI).to_uri
  end

  def test_to_s
    assert_equal "<#{URI}>", URIRef.new(URI).to_s
    assert_equal '<dc:title>', DC.title.to_s
  end

end
