require File.join(File.dirname(__FILE__), 'spec_helper')

describe RDF::Queryable do
  before :each do
    @statements = RDF::NTriples::Reader.new(File.open(etc_file("doap.nt"))).to_a
    @queryable  = @statements.extend(RDF::Queryable)
    @subject    = RDF::URI.new("http://rubygems.org/gems/rdf")
  end

  it "should support #query" do
    @queryable.respond_to?(:query).should be_true
  end

  context "#query" do
    it "should require an argument" do
      lambda { @queryable.query }.should raise_error(ArgumentError)
    end

    it "should accept a triple argument" do
      lambda { @queryable.query([nil, nil, nil]) }.should_not raise_error(ArgumentError)
    end

    it "should accept a hash argument" do
      lambda { @queryable.query({}) }.should_not raise_error(ArgumentError)
    end

    it "should accept a statement argument" do
      lambda { @queryable.query(RDF::Statement.new(nil, nil, nil)) }.should_not raise_error(ArgumentError)
    end

    it "should accept a pattern argument" do
      lambda { @queryable.query(RDF::Query::Pattern.new(nil, nil, nil)) }.should_not raise_error(ArgumentError)
      lambda { @queryable.query(RDF::Query::Pattern.new(:s, :p, :o)) }.should_not raise_error(ArgumentError)
    end

    it "should reject other arguments" do
      lambda { @queryable.query(nil) }.should raise_error(ArgumentError)
    end

    it "should return RDF statements" do
      @queryable.query([nil, nil, nil]).each do |statement|
        statement.should be_a_statement
      end
    end

    it "should return the correct number of results for array queries" do
      @queryable.query([nil, nil, nil]).size.should == File.readlines(etc_file("doap.nt")).size
      @queryable.query([@subject, nil, nil]).size.should == File.readlines(etc_file("doap.nt")).grep(/^<http:\/\/rubygems\.org\/gems\/rdf>/).size
      @queryable.query([@subject, RDF::DOAP.name, nil]).size.should == 1
      @queryable.query([@subject, RDF::DOAP.developer, nil]).size.should == @queryable.query([nil, nil, RDF::FOAF.Person]).size
      @queryable.query([nil, nil, RDF::DOAP.Project]).size.should == 1
    end

    it "should return the correct number of results for hash queries" do
      @queryable.query({}).size.should == File.readlines(etc_file("doap.nt")).size
      @queryable.query(:subject => @subject) .size.should == File.readlines(etc_file("doap.nt")).grep(/^<http:\/\/rubygems\.org\/gems\/rdf>/).size
      @queryable.query(:subject => @subject, :predicate => RDF::DOAP.name).size.should == 1
      @queryable.query(:subject => @subject, :predicate => RDF::DOAP.developer).size.should == @queryable.query(:object => RDF::FOAF.Person).size
      @queryable.query(:object => RDF::DOAP.Project).size.should == 1
    end

    it "should not alter a given hash argument" do
      query = { :subject => @subject, :predicate => RDF::DOAP.name, :object => RDF::FOAF.Person }
      original_query = query.dup
      result = @queryable.query(query)
      query.should == original_query
    end

  end
end
