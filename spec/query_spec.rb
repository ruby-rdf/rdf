require File.join(File.dirname(__FILE__), 'spec_helper')
require 'rdf/ntriples'

describe RDF::Query do
  context "when created" do
    it "should be instantiable" do
      lambda { RDF::Query.new }.should_not raise_error
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

    it "should provide single solution sets for multi-statement BGP's" do
      graph = RDF::Repository.new
      example = RDF::Vocabulary.new('http://example.org')
      graph << RDF::Statement.new(example.test1, example.property, example.test2)
      graph << RDF::Statement.new(example.test3, example.property2, example.test4)
      query = RDF::Query.new do |query|
        query << [:s1, example.property, :o1]
        query << [:s2, example.property2, :o2]
      end
      result = query.execute(graph)

      results = result.map(&:to_hash)
      results.should == [{ :s1 => example.test1, :o1 => example.test2, :s2 => example.test3, :o2 => example.test4 }]
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
