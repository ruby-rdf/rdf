require 'rdf'
require 'rdf/readers'

class TestReaders < Test::Unit::TestCase
  include RDF

  TEST_FILE = 'test/data/test.nt'

  def open_test_file(&block)
    RDF::Reader.open(TEST_FILE, :format => :ntriples, &block)
  end

  def test_open_ntriples_file
    assert_nothing_raised { open_test_file }
  end

  def test_load_ntriples
    assert_nothing_raised do
      open_test_file do |input|
        input.each_triple do |subject, predicate, object|
          assert_kind_of Node, subject
          assert_kind_of URIRef, predicate
          assert_not_nil object
        end
      end
    end
  end

end
