require 'rdf'

class TestRDF < Test::Unit::TestCase
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

    assert_kind_of Resource, eg['arbitrary']
    assert_equal eg['name'].uri, 'http://example.org/test#name'
    assert_equal eg.name.uri, 'http://example.org/test#name'
    assert_equal eg.compound_name.uri, 'http://example.org/test#compound-name'
  end

  def test_literal_languages
    assert_equal Literal.new('', :language => :en).language, :en
  end

  def test_literal_datatypes
    assert_equal Literal.new('').type, nil
    assert_equal Literal.new(false).type, XSD.boolean
    assert_equal Literal.new(true).type, XSD.boolean
    assert_equal Literal.new(123).type, XSD.int
    assert_equal Literal.new(9223372036854775807).type, XSD.long
    assert_equal Literal.new(3.1415).type, XSD.double
    assert_equal Literal.new(Time.now).type, XSD.dateTime
    require 'date'
    assert_equal Literal.new(Date.new(2000)).type, XSD.date
    assert_equal Literal.new(DateTime.new(2000)).type, XSD.dateTime
  end

  def test_literal_values
    assert_equal Literal.new(1.0/0.0).value, 'INF'
    assert_equal Literal.new(-1.0/0.0).value, '-INF'
  end

  def test_literal_equality
    assert_equal Literal.new(123), Literal.new(123)
    assert_not_equal Literal.new(3), Literal.new(3.0)
    assert_not_equal Literal.new(3), Literal.new(3, :type => XSD.long)
    assert_equal Literal.new('abc'), Literal.new('abc')
    assert_not_equal Literal.new('abc'), Literal.new('abc', :language => :en)
  end

end
