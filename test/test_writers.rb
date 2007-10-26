require 'rdf'
require 'rdf/writers'
require 'stringio'

class TestWriters < Test::Unit::TestCase
  include RDF

  RDFRB   = URIRef.new('http://rubyforge.org/projects/rdfrb/')
  DOAP    = Namespaces::DOAP
  TRIPLES =
    [[RDFRB, DOAP.name,      'RDF.rb'],
     [RDFRB, DOAP.shortdesc, Literal.new('RDF API for Ruby', :language => :en)],
     [RDFRB, DOAP.homepage,  URIRef.new('http://rdfrb.org/')]]

  NTRIPLES = <<-EOF.map { |s| s.lstrip }.join
    <http://rubyforge.org/projects/rdfrb/> <http://usefulinc.com/ns/doap#name> "RDF.rb" .
    <http://rubyforge.org/projects/rdfrb/> <http://usefulinc.com/ns/doap#shortdesc> "RDF API for Ruby"@en .
    <http://rubyforge.org/projects/rdfrb/> <http://usefulinc.com/ns/doap#homepage> <http://rdfrb.org/> .
  EOF

  def test_known_writer_instantiation
    assert_nothing_raised do
      [:ntriples, :turtle, :notation3, :rdfxml, :trix].each do |format|
        klass = RDF::Writer.for(format)

        assert_kind_of Class, klass
        assert_kind_of RDF::Writer, klass.new
      end
    end
  end

  def test_unknown_writer_instantiation
    assert_raise(LoadError) do
      klass = RDF::Writer.for(:unknown)
    end
  end

  def test_abstract_writer_not_implemented
    RDF::Writer.new do |out|
      assert_raise(ArgumentError) { out << nil }
      assert_raise(NotImplementedError) { out.write_triple nil, nil, nil }
    end
  end

  def test_triples_to_ntriples
    buffer = RDF::Writer.for(:ntriples).open do |out|
      TRIPLES.each { |triple| out << triple }
    end
    assert_equal NTRIPLES, buffer
  end

  def test_statements_to_ntriples
    buffer = RDF::Writer.for(:ntriples).open do |out|
      TRIPLES.each { |triple| out << Statement.new(*triple) }
    end
    assert_equal NTRIPLES, buffer
  end

  def test_resources_to_ntriples
    buffer = RDF::Writer.for(:ntriples).open do |out|
      out << Resource.new(RDFRB, :doap) do |node|
        TRIPLES.each { |s, p, o| node[p] = o }
      end
    end
    # The triples may not have been written out in any specific order, so we
    # must compare the output in a manner that is not order-sensitive
    assert_equal NTRIPLES.split("\n").sort, buffer.split("\n").sort
  end

  def test_statements_to_rdfxml
    buffer = RDF::Writer.for(:rdfxml).open do |out|
      #out.write_statements(TRIPLES.map { |triple| Statement.new(*triple) })
    end
    #assert_equal RDFXML, buffer # TODO
  end

end
