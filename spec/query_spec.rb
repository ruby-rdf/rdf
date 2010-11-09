require File.join(File.dirname(__FILE__), 'spec_helper')
require 'rdf/ntriples'

describe RDF::Query do
  RDF::EX = RDF::Vocabulary.new('http://example.org/')

  context "when created" do
    it "should be instantiable" do
      lambda { RDF::Query.new }.should_not raise_error
    end
  end

  context "querying for a specific statement" do
    it "should return an empty solution sequence if the statement does not exist" do
      graph = RDF::Graph.new do
        self << [EX.test1, EX.property1, EX.test2]
      end
      query = RDF::Query.new do
        self << [EX.test1, EX.property1, EX.test99] # nonexistent statement
        self << [:s, :p, :o]
      end
      query.execute(graph).should == []
    end
  end

  context "querying" do
    it "should provide single solution sets for multi-statement BGPs" do
      graph = RDF::Repository.new do
        self << [EX.test1, EX.property1, EX.test2]
        self << [EX.test3, EX.property2, EX.test4]
      end
      query = RDF::Query.new do
        self << [:s1, EX.property1, :o1]
        self << [:s2, EX.property2, :o2]
      end
      result = query.execute(graph)
      #result.map(&:to_hash).should == [{:s1 => EX.test1, :o1 => EX.test2, :s2 => EX.test3, :o2 => EX.test4}] # FIXME
    end
  end

  context "solution modifiers" do
    before :each do
      @graph = RDF::Repository.load(fixture_path('test.nt'))
      @query = RDF::Query.new(:solutions => @graph.map { |stmt| stmt.to_hash(:s, :p, :o) })
    end

    it "should support projection" do
      @query.project(:s, :p, :o)
      @query.solutions.each do |vars, vals|
        vars.keys.should include(:s, :p, :o)
      end

      @query.project(:s, :p)
      @query.solutions.each do |vars, vals|
        vars.keys.should include(:s, :p)
        vars.keys.should_not include(:o)
      end

      @query.project(:s)
      @query.solutions.each do |vars, vals|
        vars.keys.should include(:s)
        vars.keys.should_not include(:p, :o)
      end
    end

    it "should support duplicate elimination" do
      [:distinct, :reduced].each do |op|
        @query.solutions *= 2
        @query.count == @graph.size * 2
        @query.send(op)
        @query.count == @graph.size
      end
    end

    it "should support offsets" do
      @query.offset(10)
      @query.count == (@graph.size - 10)
    end

    it "should support limits" do
      @query.limit(10)
      @query.count == 10
    end
  end
end
