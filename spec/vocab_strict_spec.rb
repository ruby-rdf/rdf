require 'rdf'
require 'rdf/vocab/strict'

describe RDF::StrictVocabulary do
  subject :test_vocab do
    Class.new(RDF::StrictVocabulary.create("http://example.com/test#")) do
      property :prop

      graph do |graph|
        data = StringIO.new(<<-graph)
        <http://example.com/test#Class> <http://www.w3.org/1999/02/22-rdf-syntax-ns#type> <http://www.w3.org/2000/01/rdf-schema#Class> .
        <http://example.com/test#prop2> <http://www.w3.org/1999/02/22-rdf-syntax-ns#type> <http://www.w3.org/1999/02/22-rdf-syntax-ns#Property> .
        <http://example.com/test#prop2> <http://www.w3.org/2000/01/rdf-schema#label> "Test property label" .
        <http://example.com/test#prop2> <http://www.w3.org/2000/01/rdf-schema#comment> "Test property comment" .
        graph
        RDF::Reader.for(:ntriples).new(data) do |reader|
          graph.insert(reader)
        end
      end
    end
  end

  it "should not have Vocabulary::method_missing" do
    expect do
      test_vocab.a_missing_method
    end.to raise_error(NoMethodError)
  end

  it "should not have Vocabulary#method_missing" do
    expect do
      test_vocab.new.a_missing_method
    end.to raise_error(NoMethodError)
  end

  it "should respond to methods for which a property has been defined explicitly" do
    test_vocab.prop.should be_a(RDF::URI)
  end

  it "should respond to methods for which a property has been defined by a graph" do
    test_vocab.prop2.should be_a(RDF::URI)
  end

  it "should respond to methods for which a class has been defined by a graph" do
    test_vocab.Class.should be_a(RDF::URI)
  end

  it "should respond to label_for from base RDFS" do
    test_vocab.label_for("prop2").should == "Test property label"
  end

  it "should respond to comment_for from base RDFS" do
    test_vocab.comment_for(:prop2).should == "Test property comment"
  end
end
