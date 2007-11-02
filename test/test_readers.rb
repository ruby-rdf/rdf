require 'rdf'
require 'rdf/readers'

class TestReaders < Test::Unit::TestCase
  include RDF

  FILE_NTRIPLES = 'test.nt'
  FILE_TRIX     = 'trix/examples.xml'

  # N-Triples

  def open_ntriples_file(&block)
    RDF::Reader.open("test/data/#{FILE_NTRIPLES}", :format => :ntriples, &block)
  end

  def test_ntriples_open_file
    assert_nothing_raised { open_ntriples_file }
  end

  def test_ntriples_load
    assert_nothing_raised do
      open_ntriples_file do |input|
        input.each_triple do |subject, predicate, object|
          assert_kind_of Node, subject
          assert_kind_of URIRef, predicate
          assert_not_nil object
        end
      end
    end
  end

  # TriX

  def open_trix_file(&block)
    RDF::Reader.open("test/data/#{FILE_TRIX}", :format => :trix, &block)
  end

  def test_trix_open_file
    assert_nothing_raised { open_trix_file }
  end

  def test_trix_load
    assert_nothing_raised do
      open_trix_file do |input|
        input.each_triple do |subject, predicate, object|
          assert_kind_of Node, subject
          assert_kind_of URIRef, predicate
          assert_not_nil object
        end
      end
    end
  end

end
