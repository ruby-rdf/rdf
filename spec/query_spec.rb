require File.join(File.dirname(__FILE__), 'spec_helper')
require 'rdf/ntriples'
require 'set'

::RSpec::Matchers.define :have_result_set do |expected|
  match do |result|
    result.map(&:to_hash).to_set.should == expected.to_set
  end
end

describe RDF::Query do
  EX = RDF::EX = RDF::Vocabulary.new('http://example.org/')

  context "when created" do
    before(:each) do
      @pattern = RDF::Query::Pattern.new(RDF::URI("a"), RDF::URI("b"), "c")
    end

    it "should be instantiable" do
      lambda { RDF::Query.new }.should_not raise_error
    end
    
    it "adds patterns from closure" do
      RDF::Query.new { pattern [RDF::URI("a"), RDF::URI("b"), "c"] }.patterns.should == [@pattern]
    end
    
    it "adds patterns from argument" do
      RDF::Query.new(@pattern).patterns.should == [@pattern]
    end
    
    it "adds patterns from array" do
      RDF::Query.new([@pattern]).patterns.should == [@pattern]
    end
    it "adds patterns from hash" do
      RDF::Query.new(RDF::URI("a") => { RDF::URI("b")  => "c" }).patterns.should == [@pattern]
    end
  end

  context "BGPs" do
    context "querying for a specific statement" do

      before :each do
        @graph = RDF::Graph.new do |graph|
          graph << [EX.x1, EX.p1, EX.x2]
        end
      end

      it "returns an empty solution sequence if the statement does not exist" do
        query = RDF::Query.new do |query|
          query << [EX.x1, EX.p2, EX.x2] # nonexistent statement
        end
        query.execute(@graph).should == []
      end

      it "returns an empty solution sequence if the statement does not exist as part of a multi-pattern bgp" do
        query = RDF::Query.new do |query|
          query << [EX.x1, EX.p2, EX.x2] # nonexistent statement
          query << [:s, :p, :o]
        end
        query.execute(@graph).should == []
      end

      it "should return a solution sequence with a single empty set if the statement exists" do
        query = RDF::Query.new do |query|
          query << [EX.x1, EX.p1, EX.x2]
        end
        query.execute(@graph).map(&:to_hash).should == [{}]
      end
    end

    context "querying for a literal" do
      it "should return a sequence with an existing literal" do
        graph = RDF::Graph.new do |graph|
          graph << [EX.x1, EX.p1, 123.0]
        end
        query = RDF::Query.new do |query|
          query << [:s, EX.p1, 123.0]
        end
        query.execute(graph).map(&:to_hash).should == [{:s => EX.x1}]
      end
    end

    context "triple pattern combinations" do
      before :each do
        # Normally we would not want all of this crap in the graph for each
        # test, but this gives us the nice benefit that each test implicitly
        # tests returning only the correct results and not random other ones.
        @graph = RDF::Graph.new do |graph|
          # simple patterns
          graph << [EX.x1, EX.p, 1]
          graph << [EX.x2, EX.p, 2]
          graph << [EX.x3, EX.p, 3]

          # pattern with same variable twice
          graph << [EX.x4, EX.psame, EX.x4]

          # pattern with variable across 2 patterns
          graph << [EX.x5, EX.p3, EX.x3]
          graph << [EX.x5, EX.p2, EX.x3]

          # pattern following a chain
          graph << [EX.x6, EX.pchain, EX.target]
          graph << [EX.target, EX.pchain2, EX.target2]
          graph << [EX.target2, EX.pchain3, EX.target3]
        end
      end

      it "?s p o" do
        query = RDF::Query.new do |query|
          query << [:s, EX.p, 1]
        end
        query.execute(@graph).should have_result_set([{ :s => EX.x1 }])
      end

      it "s ?p o" do
        query = RDF::Query.new do |query|
          query << [EX.x2, :p, 2]
        end
        query.execute(@graph).should have_result_set [ { :p => EX.p } ]
      end

      it "s p ?o" do
        query = RDF::Query.new do |query|
          query << [EX.x3, EX.p, :o]
        end
        query.execute(@graph).should have_result_set [ { :o => RDF::Literal.new(3) } ]
      end

      it "?s p ?o" do
        query = RDF::Query.new do |query|
          query << [:s, EX.p, :o]
        end
        query.execute(@graph).should have_result_set [ { :s => EX.x1, :o => RDF::Literal.new(1) },
                                                       { :s => EX.x2, :o => RDF::Literal.new(2) },
                                                       { :s => EX.x3, :o => RDF::Literal.new(3) }]
      end

      it "?s ?p o" do
        query = RDF::Query.new do |query|
          query << [:s, :p, 3]
        end
        query.execute(@graph).should have_result_set [ { :s => EX.x3, :p => EX.p } ]
      end

      it "s ?p ?o" do
        query = RDF::Query.new do |query|
          query << [ EX.x1, :p, :o]
        end
        query.execute(@graph).should have_result_set [ { :p => EX.p, :o => RDF::Literal(1) } ]
      end

      it "?s p o / ?s p1 o1" do
          # pattern with variable across 2 patterns
          #self << [EX.x5, EX.p3, EX.x3]
          #self << [EX.x5, EX.p2, EX.x3]
        query = RDF::Query.new do |query|
          query << [:s, EX.p3, EX.x3]
          query << [:s, EX.p2, EX.x3]
        end
        query.execute(@graph).should have_result_set [ { :s => EX.x5 } ]
      end

      it "?s1 p ?o1 / ?o1 p2 ?o2 / ?o2 p3 ?o3" do
        query = RDF::Query.new do |query|
          query << [:s, EX.pchain, :o]
          query << [:o, EX.pchain2, :o2]
          query << [:o2, EX.pchain3, :o3]
        end
        query.execute(@graph).should have_result_set [ { :s => EX.x6, :o => EX.target, :o2 => EX.target2, :o3 => EX.target3 } ]
      end

      it "?same p ?same" do
        query = RDF::Query.new do |query|
          query << [:same, EX.psame, :same]
        end
        query.execute(@graph).should have_result_set [ { :same => EX.x4 } ]
      end

      it "chains solutions" do
        q1 = RDF::Query.new << [:s, EX.pchain, :o]
        q2 = RDF::Query.new << [:o, EX.pchain2, :o2]
        q3 = RDF::Query.new << [:o2, EX.pchain3, :o3]
        sol1 = q1.execute(@graph)
        sol2 = q2.execute(@graph, :solutions => sol1)
        sol3 = q3.execute(@graph, :solutions => sol2)
        sol3.should have_result_set [ { :s => EX.x6, :o => EX.target, :o2 => EX.target2, :o3 => EX.target3 } ]
      end
      
      it "has bindings" do
        query = RDF::Query.new do |query|
          query << [:s, EX.p, :o]
        end
        query.execute(@graph).bindings.should == {
          :s => [EX.x1, EX.x2, EX.x3],
          :o => [RDF::Literal.new(1), RDF::Literal.new(2), RDF::Literal.new(3) ]
        }
      end

      # From data-r2/expr-equals
      context "data/r2/expr-equals" do
        before(:each) do
          @graph << [EX.xi1, EX.p, RDF::Literal::Integer.new("1")]
          @graph << [EX.xi2, EX.p, RDF::Literal::Integer.new("1")]
          @graph << [EX.xi3, EX.p, RDF::Literal::Integer.new("01")]

          @graph << [EX.xd1, EX.p, RDF::Literal::Double.new("1.0e0")]
          @graph << [EX.xd2, EX.p, RDF::Literal::Double.new("1.0")]
          @graph << [EX.xd3, EX.p, RDF::Literal::Double.new("1")]

          @graph << [EX.xt1, EX.p, RDF::Literal.new("zzz", :datatype => EX.myType)]

          @graph << [EX.xp1, EX.p, RDF::Literal.new("zzz")]
          @graph << [EX.xp2, EX.p, RDF::Literal.new("1")]

          @graph << [EX.xu, EX.p, EX.z]
        end
        
        describe "graph-1" do
          before(:each) do
            query = RDF::Query.new {pattern [:x, EX.p, RDF::Literal::Integer.new(1)]}
            @solutions = query.execute(@graph)
          end

          it "has two solutions" do
            @solutions.count.should == 2
          end
          
          it "has xi1 as a solution" do
            @solutions.filter(:x => EX.xi1).should_not be_empty
          end
          
          it "has xi2 as a solution" do
            @solutions.filter(:x => EX.xi2).should_not be_empty
          end
        end

        
        describe "graph-2" do
          before(:each) do
            query = RDF::Query.new {pattern [:x, EX.p, RDF::Literal::Double.new(1.0e0)]}
            @solutions = query.execute(@graph)
          end

          it "has one solution" do
            @solutions.count.should == 1
          end
          
          it "has xd1 as a solution" do
            @solutions.filter(:x => EX.xd1).should_not be_empty
          end
        end
      end

      # From sp2b benchmark, query 7 bgp 2
      it "?class3 p o / ?doc3 p2 ?class3 / ?doc3 p3 ?bag3 / ?bag3 ?member3 ?doc" do
        @graph << [EX.class1, EX.subclass, EX.document]
        @graph << [EX.class2, EX.subclass, EX.document]
        @graph << [EX.class3, EX.subclass, EX.other]

        @graph << [EX.doc1, EX.type, EX.class1]
        @graph << [EX.doc2, EX.type, EX.class1]
        @graph << [EX.doc3, EX.type, EX.class2]
        @graph << [EX.doc4, EX.type, EX.class2]
        @graph << [EX.doc5, EX.type, EX.class3]

        @graph << [EX.doc1, EX.refs, EX.bag1]
        @graph << [EX.doc2, EX.refs, EX.bag2]
        @graph << [EX.doc3, EX.refs, EX.bag3]
        @graph << [EX.doc5, EX.refs, EX.bag5]

        @graph << [EX.bag1, RDF::Node.new('ref1'), EX.doc11]
        @graph << [EX.bag1, RDF::Node.new('ref2'), EX.doc12]
        @graph << [EX.bag1, RDF::Node.new('ref3'), EX.doc13]

        @graph << [EX.bag2, RDF::Node.new('ref1'), EX.doc21]
        @graph << [EX.bag2, RDF::Node.new('ref2'), EX.doc22]
        @graph << [EX.bag2, RDF::Node.new('ref3'), EX.doc23]

        @graph << [EX.bag3, RDF::Node.new('ref1'), EX.doc31]
        @graph << [EX.bag3, RDF::Node.new('ref2'), EX.doc32]
        @graph << [EX.bag3, RDF::Node.new('ref3'), EX.doc33]

        @graph << [EX.bag5, RDF::Node.new('ref1'), EX.doc51]
        @graph << [EX.bag5, RDF::Node.new('ref2'), EX.doc52]
        @graph << [EX.bag5, RDF::Node.new('ref3'), EX.doc53]

        query = RDF::Query.new do |query|
          query << [:class3, EX.subclass, EX.document]
          query << [:doc3, EX.type, :class3]
          query << [:doc3, EX.refs, :bag3]
          query << [:bag3, :member3, :doc]
        end

        query.execute(@graph).should have_result_set [
          { :doc3 => EX.doc1, :class3 => EX.class1, :bag3 => EX.bag1, :member3 => RDF::Node.new('ref1'), :doc => EX.doc11 },
          { :doc3 => EX.doc1, :class3 => EX.class1, :bag3 => EX.bag1, :member3 => RDF::Node.new('ref2'), :doc => EX.doc12 },
          { :doc3 => EX.doc1, :class3 => EX.class1, :bag3 => EX.bag1, :member3 => RDF::Node.new('ref3'), :doc => EX.doc13 },
          { :doc3 => EX.doc2, :class3 => EX.class1, :bag3 => EX.bag2, :member3 => RDF::Node.new('ref1'), :doc => EX.doc21 },
          { :doc3 => EX.doc2, :class3 => EX.class1, :bag3 => EX.bag2, :member3 => RDF::Node.new('ref2'), :doc => EX.doc22 },
          { :doc3 => EX.doc2, :class3 => EX.class1, :bag3 => EX.bag2, :member3 => RDF::Node.new('ref3'), :doc => EX.doc23 },
          { :doc3 => EX.doc3, :class3 => EX.class2, :bag3 => EX.bag3, :member3 => RDF::Node.new('ref1'), :doc => EX.doc31 },
          { :doc3 => EX.doc3, :class3 => EX.class2, :bag3 => EX.bag3, :member3 => RDF::Node.new('ref2'), :doc => EX.doc32 },
          { :doc3 => EX.doc3, :class3 => EX.class2, :bag3 => EX.bag3, :member3 => RDF::Node.new('ref3'), :doc => EX.doc33 }
        ]
      end

      # From sp2b benchmark, query 7 bgp 1
      it "?class subclass document / ?doc type ?class / ?doc title ?title / ?bag2 ?member2 ?doc / ?doc2 refs ?bag2" do
        @graph << [EX.class1, EX.subclass, EX.document]
        @graph << [EX.class2, EX.subclass, EX.document]
        @graph << [EX.class3, EX.subclass, EX.other]

        @graph << [EX.doc1, EX.type, EX.class1]
        @graph << [EX.doc2, EX.type, EX.class1]
        @graph << [EX.doc3, EX.type, EX.class2]
        @graph << [EX.doc4, EX.type, EX.class2]
        @graph << [EX.doc5, EX.type, EX.class3]
        # no doc6 type

        @graph << [EX.doc1, EX.title, EX.title1]
        @graph << [EX.doc2, EX.title, EX.title2]
        @graph << [EX.doc3, EX.title, EX.title3]
        @graph << [EX.doc4, EX.title, EX.title4]
        @graph << [EX.doc5, EX.title, EX.title5]
        @graph << [EX.doc6, EX.title, EX.title6]

        @graph << [EX.doc1, EX.refs, EX.bag1]
        @graph << [EX.doc2, EX.refs, EX.bag2]
        @graph << [EX.doc3, EX.refs, EX.bag3]
        @graph << [EX.doc5, EX.refs, EX.bag5]

        @graph << [EX.bag1, RDF::Node.new('ref1'), EX.doc11]
        @graph << [EX.bag1, RDF::Node.new('ref2'), EX.doc12]
        @graph << [EX.bag1, RDF::Node.new('ref3'), EX.doc13]

        @graph << [EX.bag2, RDF::Node.new('ref1'), EX.doc21]
        @graph << [EX.bag2, RDF::Node.new('ref2'), EX.doc22]
        @graph << [EX.bag2, RDF::Node.new('ref3'), EX.doc23]

        @graph << [EX.bag3, RDF::Node.new('ref1'), EX.doc31]
        @graph << [EX.bag3, RDF::Node.new('ref2'), EX.doc32]
        @graph << [EX.bag3, RDF::Node.new('ref3'), EX.doc33]

        @graph << [EX.bag5, RDF::Node.new('ref1'), EX.doc51]
        @graph << [EX.bag5, RDF::Node.new('ref2'), EX.doc52]
        @graph << [EX.bag5, RDF::Node.new('ref3'), EX.doc53]

        query = RDF::Query.new do |query|
          query << [:class, EX.subclass, EX.document]
          query << [:doc, EX.type, :class]
          query << [:doc, EX.title, :title]
          query << [:doc, EX.refs, :bag]
          query << [:bag, :member, :doc2]
        end

        query.execute(@graph).should have_result_set [
          { :doc => EX.doc1, :class => EX.class1, :bag => EX.bag1,
            :member => RDF::Node.new('ref1'), :doc2 => EX.doc11, :title => EX.title1 },
          { :doc => EX.doc1, :class => EX.class1, :bag => EX.bag1,
            :member => RDF::Node.new('ref2'), :doc2 => EX.doc12, :title => EX.title1 },
          { :doc => EX.doc1, :class => EX.class1, :bag => EX.bag1,
            :member => RDF::Node.new('ref3'), :doc2 => EX.doc13, :title => EX.title1 },
          { :doc => EX.doc2, :class => EX.class1, :bag => EX.bag2,
            :member => RDF::Node.new('ref1'), :doc2 => EX.doc21, :title => EX.title2 },
          { :doc => EX.doc2, :class => EX.class1, :bag => EX.bag2,
            :member => RDF::Node.new('ref2'), :doc2 => EX.doc22, :title => EX.title2 },
          { :doc => EX.doc2, :class => EX.class1, :bag => EX.bag2,
            :member => RDF::Node.new('ref3'), :doc2 => EX.doc23, :title => EX.title2 },
          { :doc => EX.doc3, :class => EX.class2, :bag => EX.bag3,
            :member => RDF::Node.new('ref1'), :doc2 => EX.doc31, :title => EX.title3 },
          { :doc => EX.doc3, :class => EX.class2, :bag => EX.bag3,
            :member => RDF::Node.new('ref2'), :doc2 => EX.doc32, :title => EX.title3 },
          { :doc => EX.doc3, :class => EX.class2, :bag => EX.bag3,
            :member => RDF::Node.new('ref3'), :doc2 => EX.doc33, :title => EX.title3 },
        ]
      end

      it "?s1 p ?o1 / ?s2 p ?o2" do
        graph = RDF::Graph.new do |graph|
          graph << [EX.x1, EX.p, 1]
          graph << [EX.x2, EX.p, 2]
        end
        query = RDF::Query.new do |query|
          query << [:s1, EX.p, :o1]
          query << [:s2, EX.p, :o2]
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

    context "with variables" do
      before :each do
        # Normally we would not want all of this crap in the graph for each
        # test, but this gives us the nice benefit that each test implicitly
        # tests returning only the correct results and not random other ones.
        @graph = RDF::Graph.new do |graph|
          # simple patterns
          graph << [EX.x1, EX.p, 1]
          graph << [EX.x2, EX.p, 2]
          graph << [EX.x3, EX.p, 3]

          # pattern with same variable twice
          graph << [EX.x4, EX.psame, EX.x4]

          # pattern with variable across 2 patterns
          graph << [EX.x5, EX.p3, EX.x3]
          graph << [EX.x5, EX.p2, EX.x3]

          # pattern following a chain
          graph << [EX.x6, EX.pchain, EX.target]
          graph << [EX.target, EX.pchain2, EX.target2]
          graph << [EX.target2, EX.pchain3, EX.target3]
        end
      end

      it "?s p o" do
        query = RDF::Query.new do |query|
          query << [RDF::Query::Variable.new("s"), EX.p, 1]
        end
        query.execute(@graph).should have_result_set([{ :s => EX.x1 }])
      end

      it "s ?p o" do
        query = RDF::Query.new do |query|
          query << [EX.x2, RDF::Query::Variable.new("p"), 2]
        end
        query.execute(@graph).should have_result_set [ { :p => EX.p } ]
      end

      it "s p ?o" do
        query = RDF::Query.new do |query|
          query << [EX.x3, EX.p, RDF::Query::Variable.new("o")]
        end
        query.execute(@graph).should have_result_set [ { :o => RDF::Literal.new(3) } ]
      end

      it "?s p ?o" do
        query = RDF::Query.new do |query|
          query << [RDF::Query::Variable.new("s"), EX.p, RDF::Query::Variable.new("o")]
        end
        query.execute(@graph).should have_result_set [ { :s => EX.x1, :o => RDF::Literal.new(1) },
                                                       { :s => EX.x2, :o => RDF::Literal.new(2) },
                                                       { :s => EX.x3, :o => RDF::Literal.new(3) }]
      end

      it "?s ?p o" do
        query = RDF::Query.new do |query|
          query << [RDF::Query::Variable.new("s"), RDF::Query::Variable.new("p"), 3]
        end
        query.execute(@graph).should have_result_set [ { :s => EX.x3, :p => EX.p } ]
      end

      it "s ?p ?o" do
        query = RDF::Query.new do |query|
          query << [ EX.x1, RDF::Query::Variable.new("p"), RDF::Query::Variable.new("o")]
        end
        query.execute(@graph).should have_result_set [ { :p => EX.p, :o => RDF::Literal(1) } ]
      end
    end
    
    context "with preliminary bindings" do
      before :each do
        @graph = RDF::Graph.new do |graph|
          graph << [EX.x1, EX.p, EX.o1]
          graph << [EX.x1, EX.p, EX.o2]
          graph << [EX.x1, EX.p, EX.o3]
          graph << [EX.x1, EX.p, EX.o4]
          graph << [EX.x1, EX.p, EX.o5]
          graph << [EX.x1, EX.p, EX.o6]
        end
      end

      it "limits a variable to the initial bindings" do
        query = RDF::Query.new do |query|
          query << [EX.x1, EX.p, :o]
        end
        query.execute(@graph, :bindings => { :o => [EX.o1, EX.o4]}).should have_result_set [
          {:o => EX.o1}, {:o => EX.o4}]
      end

      it "uses bindings for multiple variables" do
        @graph << [EX.x1, EX.p1, EX.o1]
        @graph << [EX.x1, EX.p1, EX.o2]
        @graph << [EX.x2, EX.p1, EX.o1]
        query = RDF::Query.new do |query|
          query << [:s, EX.p1, :o]
        end
        query.execute(@graph, :bindings => {:o => [EX.o1], :s => [EX.x1]}).should have_result_set [
          {:s => EX.x1, :o => EX.o1}
        ]
      end

    end

    context "solution modifiers" do
      before :each do
        @graph = RDF::Repository.load(fixture_path('test.nt'))
        @query = RDF::Query.new() { pattern [:s, :p, :o]}
        @solutions = @query.execute(@graph)
      end

      context "projection" do
        it "projects all variables" do
          @solutions.project(:s, :p, :o)
          @solutions.each do |solution|
            solution.bindings.keys.should include(:s, :p, :o)
          end
        end

        it "projects some variables" do
          @solutions.project(:s, :p)
          @solutions.each do |solution|
            solution.bindings.keys.should include(:s, :p)
          end
        end

        it "projects a variable" do
          @solutions.project(:s)
          @solutions.each do |solution|
            solution.bindings.keys.should include(:s)
          end
        end
      end

      context "filter" do
        it "returns matching solutions" do
          @solutions.filter(:s => RDF::URI("http://example.org/resource1"))
          @solutions.count.should == 1
        end
        
        it "accepts a block" do
          @solutions.filter {|s| s[:s] == RDF::URI("http://example.org/resource1")}
          @solutions.count.should == 1
        end
      end
      
      context "order" do
        it "returns ordered solutions using a symbol" do
          orig = @solutions.dup
          @solutions.order(:o)
          @solutions.map(&:o).should == orig.map(&:o).sort
        end

        it "returns ordered solutions using a variable" do
          orig = @solutions.dup
          @solutions.order(RDF::Query::Variable.new("o"))
          @solutions.map(&:o).should == orig.map(&:o).sort
        end

        it "returns ordered solutions using a lambda" do
          orig = @solutions.dup
          @solutions.order(lambda {|a, b| a[:o] <=> b[:o]})
          @solutions.map(&:o).should == orig.map(&:o).sort
        end

        it "returns ordered solutions using a lambda symbols" do
          @solutions.order(:s, lambda {|a, b| a[:p] <=> b[:p]}, RDF::Query::Variable.new("o"))
        end

        it "returns ordered solutions using block" do
          @solutions.order {|a, b| a[:p] <=> b[:p]}
        end
      end
      
      it "should support duplicate elimination" do
        [:distinct, :reduced].each do |op|
          solutions = @solutions * 2
          solutions.count == @graph.size * 2
          solutions.send(op)
          solutions.count == @graph.size
        end
      end

      it "should support offsets" do
        @solutions.offset(10)
        @solutions.count == (@graph.size - 10)
      end

      it "should support limits" do
        @solutions.limit(10)
        @solutions.count == 10
      end
    end
  end

  context "#context" do
    it "returns nil by default" do
      subject.context.should be_nil
    end
    
    it "sets and returns a context" do
      subject.context = RDF.first
      subject.context.should == RDF.first
    end
  end

  describe "#named?" do
    it "returns false with no context" do
      subject.named?.should be_false
    end
    
    it "returns true with a context" do
      subject.context = RDF.first
      subject.named?.should be_true
    end
  end
  
  describe "#unnamed?" do
    it "returns true with no context" do
      subject.unnamed?.should be_true
    end
    
    it "returns false with a context" do
      subject.context = RDF.first
      subject.unnamed?.should be_false
    end
  end
  
  describe "#+" do
    it "returns a new RDF::Query" do
      rhs = RDF::Query.new
      q = subject + rhs
      q.should_not be_equal(subject)
      q.should_not be_equal(rhs)
    end
    
    it "contains patterns from each query in order" do
      subject.pattern [RDF.first, RDF.second, RDF.third]
      rhs = RDF::Query.new
      subject.pattern [RDF.a, RDF.b, RDF.c]
      q = subject + rhs
      q.patterns.should == [[RDF.first, RDF.second, RDF.third], [RDF.a, RDF.b, RDF.c]]
    end
  end
end
