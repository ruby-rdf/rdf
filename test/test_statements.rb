require 'rdf'

class TestStatements < Test::Unit::TestCase
  include RDF

  CONTEXT   = URIRef.new("file://#{File.expand_path(__FILE__)}")
  SUBJECT   = URIRef.new('http://rubyforge.org/projects/rdfrb/')
  PREDICATE = RDF::Namespaces::DOAP.name
  OBJECT    = 'RDF.rb'
  TRIPLE    = [SUBJECT, PREDICATE, OBJECT]
  QUAD      = TRIPLE + [{ :context => CONTEXT }]
  HASH      = { SUBJECT => { PREDICATE => OBJECT } }

  def test_statement_accessors
    assert_equal SUBJECT, Statement.new(*TRIPLE).subject
    assert_equal PREDICATE, Statement.new(*TRIPLE).predicate
    assert_equal OBJECT, Statement.new(*TRIPLE).object
  end

  def test_statement_equality
    assert Statement.new(*TRIPLE) == Statement.new(*TRIPLE)
  end

  def test_contextual_statements
    assert !Statement.new(*TRIPLE).context?
    assert Statement.new(*QUAD).context?
    assert_equal CONTEXT, Statement.new(*QUAD).context
  end

  def test_asserted_statements
    assert Statement.new(*TRIPLE).asserted?
  end

  def test_quoted_statements
    assert !Statement.new(*TRIPLE).quoted?
  end

  def test_array_equivalence
    assert_equal TRIPLE, Statement.new(*TRIPLE).to_a
    assert Statement.new(*TRIPLE) == TRIPLE
    (0..TRIPLE.length).each do |i|
      assert_equal TRIPLE[i], Statement.new(*TRIPLE)[i]
    end
  end

  def test_hash_equivalence
    assert_equal HASH, Statement.new(*TRIPLE).to_hash
  end

end
