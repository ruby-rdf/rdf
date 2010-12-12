require File.join(File.dirname(__FILE__), 'spec_helper')
require 'rdf/ntriples'
require 'set'

Spec::Matchers.define :have_result_set do |expected|
  match do |result|
    result.map(&:to_hash).to_set.should == expected.to_set
  end
end




describe RDF::Query do
  EX = RDF::EX = RDF::Vocabulary.new('http://example.org/')

  context "when created" do
    it "should be instantiable" do
      lambda { RDF::Query.new }.should_not raise_error
    end
  end

  context "BGPs" do
    context "querying for a specific statement" do
  
      before :each do
        @graph = RDF::Graph.new do
          self << [EX.x1, EX.p1, EX.x2]
        end
      end
  
      it "returns an empty solution sequence if the statement does not exist" do
        query = RDF::Query.new do
          self << [EX.x1, EX.p2, EX.x2] # nonexistent statement
          self << [:s, :p, :o]
        end
        query.execute(@graph).should == []
      end
  
      it "should return a solution sequence with a single empty set if the statement exists" do
        query = RDF::Query.new do
          self << [EX.x1, EX.p1, EX.x2]
        end
        query.execute(@graph).map(&:to_hash).should == [{}]
      end
    end
 
    context "querying for a literal" do
      it "should return a sequence with an existing literal" do
        graph = RDF::Graph.new do
          self << [EX.x1, EX.p1, 123.0]
        end
        query = RDF::Query.new do
          self << [:s, EX.p1, 123.0]
        end
        query.execute(graph).map(&:to_hash).should == [{:s => EX.x1}]
      end
    end

    context "triple pattern combinations" do
      before :each do
        # Normally we would not want all of this crap in the graph for each
        # test, but this gives us the nice benefit that each test implicitly
        # tests returning only the correct results and not random other ones.
        @graph = RDF::Graph.new do
          # simple patterns
          self << [EX.x1, EX.p, 1]
          self << [EX.x2, EX.p, 2]
          self << [EX.x3, EX.p, 3]

          # pattern with same variable twice
          self << [EX.x4, EX.psame, EX.x4]

          # pattern with variable across 2 patterns
          self << [EX.x5, EX.p3, EX.x3]
          self << [EX.x5, EX.p2, EX.x3]

          # pattern following a chain
          self << [EX.x6, EX.pchain, EX.target]
          self << [EX.target, EX.pchain2, EX.target2]
          self << [EX.target2, EX.pchain3, EX.target3]
        end
      end

      it "?s p o" do
        query = RDF::Query.new do
          self << [:s, EX.p, 1]
        end
        query.execute(@graph).should have_result_set([{ :s => EX.x1 }])
      end
    end

    context "with pre-existing constraints" do
      # TODO
    end

    context "querying with unioned triple patterns" do
      it "should return a union of solution sequences" do
        graph = RDF::Graph.new do
          self << [EX.x1, EX.p, 1]
          self << [EX.x2, EX.p, 2]
        end
        query = RDF::Query.new do
          self << [:s1, EX.p, :o1]
          self << [:s2, EX.p, :o2]
        end
        # Use set comparison for unordered compare on 1.8.7
        query.execute(graph).map(&:to_hash).to_set.should == [
          {:s1 => EX.x1, :o1 => RDF::Literal(1), :s2 => EX.x1, :o2 => RDF::Literal(1)},
          {:s1 => EX.x1, :o1 => RDF::Literal(1), :s2 => EX.x2, :o2 => RDF::Literal(2)},
          {:s1 => EX.x2, :o1 => RDF::Literal(2), :s2 => EX.x1, :o2 => RDF::Literal(1)},
          {:s1 => EX.x2, :o1 => RDF::Literal(2), :s2 => EX.x2, :o2 => RDF::Literal(2)},
        ].to_set
      end
    end
  
    context "solution modifiers" do
      before :each do
        pending "TODO"
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
end
