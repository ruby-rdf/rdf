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
    it "should be instantiable" do
      lambda { RDF::Query.new }.should_not raise_error
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

      it "?s p ?o with duplicates" do
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

    context "with an optional pattern" do
      before :each do
        @graph = RDF::Graph.new do |graph|
          graph << [EX.s1, EX.p, EX.o]
          graph << [EX.s2, EX.p, EX.o]
          graph << [EX.s2, EX.p2, EX.o2]
        end
      end

      it "should match graphs with and without the optional pattern" do
        query = RDF::Query.new do |query|
          query.pattern [:s, EX.p, EX.o]
          query.pattern [:s, EX.p2, :o], :optional => true
        end
        query.execute(@graph).map(&:to_hash).to_set.should == [
          {:s => EX.s1},
          {:s => EX.s2, :o => EX.o2}
        ].to_set
      end

      it "should raise an error unless all optional patterns follow regular patterns" do
        # SPARQL requires optional patterns to follow the regular patterns.
        # In the interest of compatibility, we enforce similar
        # restrictions, because the semantics of leading optional patterns
        # are hard to get right.
        lambda do
          query = RDF::Query.new do |query|
            query.pattern [:s, EX.p2, :o], :optional => true
            query.pattern [:s, EX.p, EX.o]
          end
          query.execute(@graph)
        end.should raise_error(ArgumentError)

        lambda do
          query = RDF::Query.new do |query|
            query.pattern [:s, EX.p, EX.o]
            query.pattern [:s, EX.p2, :o], :optional => true
            query.pattern [:s, EX.x, EX.x]
          end
          query.execute(@graph)
        end.should raise_error(ArgumentError)
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
