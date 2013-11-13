require 'rdf'
require 'rdf/vocab'

describe RDF::StrictVocabulary do
  subject :test_vocab do
    Class.new(RDF::StrictVocabulary.create("http://example.com/test#")) do
      property :Class
      property :prop
      property :prop2, :label => "Test property label", :comment => " Test property comment"
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
    test_vocab[:prop].should be_a(RDF::URI)
    test_vocab["prop2"].should be_a(RDF::URI)
  end

  it "should not respond to [] with properties that have not been defined" do
    expect{ test_vocab["not_a_prop"] }.to raise_error(KeyError)
    expect{ test_vocab[:not_a_prop] }.to raise_error(KeyError)
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
