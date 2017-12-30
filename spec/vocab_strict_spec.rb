require 'rdf'
require 'rdf/vocabulary'

describe RDF::StrictVocabulary do
  subject :test_vocab do
    Class.new(RDF::StrictVocabulary.create("http://example.com/test#")) do
      property :Class
      property :prop
      property :prop2, label: "Test property label", comment: "Test property comment"
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

  it "should respond to [] with properties that have been defined" do
    expect(test_vocab[:prop]).to be_a(RDF::URI)
    expect(test_vocab["prop2"]).to be_a(RDF::URI)
  end

  it "should list properties that have been defined" do
    expect([test_vocab.prop, test_vocab.Class, test_vocab.prop2] - test_vocab.properties).to be_empty
  end

  it "should not respond to [] with properties that have not been defined" do
    expect{ test_vocab["not_a_prop"] }.to raise_error(KeyError)
    expect{ test_vocab[:not_a_prop] }.to raise_error(KeyError)
  end

  it "should respond to methods for which a property has been defined explicitly" do
    expect(test_vocab.prop).to be_a(RDF::URI)
  end

  it "should respond to methods for which a property has been defined by a graph" do
    expect(test_vocab.prop2).to be_a(RDF::URI)
  end

  it "should respond to methods for which a class has been defined by a graph" do
    expect(test_vocab.Class).to be_a(RDF::URI)
  end

  it "should respond to label from base RDFS" do
    expect(test_vocab["prop2"].label.to_s).to eql "Test property label"
  end

  it "should respond to comment from base RDFS" do
    expect(test_vocab[:prop2].comment.to_s).to eql "Test property comment"
  end
end
