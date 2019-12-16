require File.join(File.dirname(__FILE__), 'spec_helper')
require 'rdf/ntriples'
require 'set'

::RSpec::Matchers.define :have_result_set do |expected|
  match do |result|
    expect(result.map(&:to_h).to_set).to eq expected.to_set
  end
end

describe RDF::Query do
  EX = RDF::Vocabulary.new('http://example.org/')
  FOAF = RDF::Vocab::FOAF

  context "when created" do
    let(:pattern) {RDF::Query::Pattern.new(RDF::URI("a"), RDF::URI("b"), "c")}

    it "should be instantiable" do
      expect { RDF::Query.new }.not_to raise_error
    end

    it "adds patterns from closure" do
      expect(RDF::Query.new { pattern [RDF::URI("a"), RDF::URI("b"), "c"] }.patterns).to eq [pattern]
    end

    it "adds patterns from argument" do
      expect(RDF::Query.new(pattern).patterns).to eq [pattern]
    end

    it "adds patterns from array" do
      expect(RDF::Query.new([pattern]).patterns).to eq [pattern]
    end

    it "adds patterns from hash" do
      expect(RDF::Query.new(RDF::URI("a") => { RDF::URI("b")  => "c" }).patterns).to eq [pattern]
    end

    it "sets graph_name to a URI" do
      expect(RDF::Query.new(graph_name: RDF::URI("a")).graph_name).to eq RDF::URI("a")
    end

    it "sets graph_name to false" do
      expect(RDF::Query.new(graph_name: false).graph_name).to be_falsey
    end
  end

  describe "#empty?" do
    context "A query with no patterns" do
      subject {RDF::Query.new}
      it {is_expected.to be_empty}
    end

    context "A query with patterns" do
      subject {RDF::Query.new(RDF::URI("a") => { RDF::URI("b")  => "c" })}
      it {is_expected.not_to be_empty}
    end
  end

  describe "#dup" do
    let(:orig) {RDF::Query.new { pattern [RDF::URI("a"), RDF::URI("b"), "c"] }}
    subject {orig.dup}
    it {is_expected.not_to equal orig}
    its(:patterns) {is_expected.not_to equal orig.patterns}
    its(:patterns) {is_expected.to eq orig.patterns}
  end

  describe "#options" do
    subject {RDF::Query.new(RDF::Query::Pattern.new(), extra: :value)}
    its(:options) {is_expected.to include(extra: :value)}
  end

  context "BGPs" do
    context "with empty query" do
      subject {RDF::Query.new}
      {
        "empty graph" => RDF::Graph.new,
        "full graph" => RDF::Graph.load(fixture_path('test.nt'))
      }.each do |which, graph|
        context which do
          it "returns a single empty solution (query execute)" do
            expect(subject.execute(graph).map(&:to_h)).to eq [{}]
          end
          it "yields a single empty solution (query execute)" do
            expect {|b| subject.execute(graph, &b)}.to yield_successive_args(RDF::Query::Solution.new)
          end
          it "returns a single empty solution (graph execute)" do
            expect(graph.query(subject).map(&:to_h)).to eq [{}]
          end
          it "yields a single empty solution (graph execute)" do
            expect {|b| graph.query(subject, &b)}.to yield_successive_args(RDF::Query::Solution.new)
          end
        end
      end
    end

    context "querying for a specific statement" do
      let!(:graph) {
        RDF::Graph.new do |g|
          g << [EX.x1, EX.p1, EX.x2]
        end
      }

      it "returns an empty solution sequence if the statement does not exist" do
        query = RDF::Query.new do |q|
          q << [EX.x1, EX.p2, EX.x2] # nonexistent statement
        end
        expect(query.execute(graph)).to be_empty
        expect(graph.query(query)).to be_empty
      end

      it "returns an empty solution sequence if the statement does not exist as part of a multi-pattern bgp" do
        query = RDF::Query.new do |q|
          q << [EX.x1, EX.p2, EX.x2] # nonexistent statement
          q << [:s, :p, :o]
        end
        expect(query.execute(graph)).to be_empty
        expect(graph.query(query)).to be_empty
      end

      it "should return a solution sequence with a single empty set if the statement exists" do
        query = RDF::Query.new do |q|
          q << [EX.x1, EX.p1, EX.x2]
        end
        expect(query.execute(graph).map(&:to_h)).to eq [{}]
        expect(graph.query(query).map(&:to_h)).to eq [{}]
      end
    end

    context "querying for a literal" do
      it "should return a sequence with an existing literal" do
        graph = RDF::Graph.new do |g|
          g << [EX.x1, EX.p1, 123.0]
        end
        query = RDF::Query.new do |q|
          q << [:s, EX.p1, 123.0]
        end
        expect(query.execute(graph).map(&:to_h)).to eq [{s: EX.x1}]
        expect(graph.query(query).map(&:to_h)).to eq [{s: EX.x1}]
      end
    end

    context "with graph_names" do
      let!(:repo) {
        RDF::Repository.new do |r|
          r << [EX.s1, EX.p1, EX.o1]
          r << [EX.s2, EX.p2, EX.o2, EX.c]
        end
      }
      subject {RDF::Query.new {pattern [:s, :p, :o]}}

       context "with no graph_name" do
         it "returns statements differing in context (direct execute)" do
           expect(subject.execute(repo).map(&:to_h))
             .to contain_exactly({s: EX.s1, p: EX.p1, o: EX.o1},
                                 {s: EX.s2, p: EX.p2, o: EX.o2})
         end
         it "returns statements differing in context (graph execute)" do
           expect(repo.query(subject).map(&:to_h))
             .to contain_exactly({s: EX.s1, p: EX.p1, o: EX.o1},
                                 {s: EX.s2, p: EX.p2, o: EX.o2})
         end
       end

       context "with default graph" do
         it "returns statement from default graph" do
           subject.graph_name = false
           expect(subject.execute(repo).map(&:to_h)).to eq [
             {s: EX.s1, p: EX.p1, o: EX.o1}]
           expect(repo.query(subject).map(&:to_h)).to eq [
             {s: EX.s1, p: EX.p1, o: EX.o1}]
         end
       end

       context "with constant graph_name" do
         it "returns statement from specified graph_name" do
           subject.graph_name = EX.c
           expect(subject.execute(repo).map(&:to_h)).to eq [
             {s: EX.s2, p: EX.p2, o: EX.o2}]
           expect(repo.query(subject).map(&:to_h)).to eq [
             {s: EX.s2, p: EX.p2, o: EX.o2}]
         end
       end

       context "with variable graph_name" do
         it "returns statement having a graph_name" do
           subject.graph_name = RDF::Query::Variable.new(:c)
           expect(subject.execute(repo).map(&:to_h)).to eq [
             {s: EX.s2, p: EX.p2, o: EX.o2, c: EX.c}]
           expect(repo.query(subject).map(&:to_h)).to eq [
             {s: EX.s2, p: EX.p2, o: EX.o2, c: EX.c}]
         end
       end
    end

    context "triple pattern combinations" do
      let(:graph) {
        # Normally we would not want all of this crap in the graph for each
        # test, but this gives us the nice benefit that each test implicitly
        # tests returning only the correct results and not random other ones.
        RDF::Graph.new do |graph|
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
      }

      it "?s p o" do
        query = RDF::Query.new do |q|
          q << [:s, EX.p, 1]
        end
        expect(query.execute(graph)).to have_result_set([{ s: EX.x1 }])
        expect(graph.query(query)).to have_result_set([{ s: EX.x1 }])
      end

      it "s ?p o" do
        query = RDF::Query.new do |q|
          q << [EX.x2, :p, 2]
        end
        expect(query.execute(graph)).to have_result_set [ { p: EX.p } ]
        expect(graph.query(query)).to have_result_set [ { p: EX.p } ]
      end

      it "s p ?o" do
        query = RDF::Query.new do |query|
          query << [EX.x3, EX.p, :o]
        end
        expect(query.execute(graph)).to have_result_set [ { o: RDF::Literal.new(3) } ]
        expect(graph.query(query)).to have_result_set [ { o: RDF::Literal.new(3) } ]
      end

      it "?s p ?o" do
        query = RDF::Query.new do |query|
          query << [:s, EX.p, :o]
        end
        expect(query.execute(graph)).to have_result_set [ { s: EX.x1, o: RDF::Literal.new(1) },
                                                       { s: EX.x2, o: RDF::Literal.new(2) },
                                                       { s: EX.x3, o: RDF::Literal.new(3) }]
        expect(graph.query(query)).to have_result_set [ { s: EX.x1, o: RDF::Literal.new(1) },
                                                       { s: EX.x2, o: RDF::Literal.new(2) },
                                                       { s: EX.x3, o: RDF::Literal.new(3) }]
      end

      it "?s ?p o" do
        query = RDF::Query.new do |query|
          query << [:s, :p, 3]
        end
        expect(query.execute(graph)).to have_result_set [ { s: EX.x3, p: EX.p } ]
        expect(graph.query(query)).to have_result_set [ { s: EX.x3, p: EX.p } ]
      end

      it "s ?p ?o" do
        query = RDF::Query.new do |query|
          query << [ EX.x1, :p, :o]
        end
        expect(query.execute(graph)).to have_result_set [ { p: EX.p, o: RDF::Literal(1) } ]
        expect(graph.query(query)).to have_result_set [ { p: EX.p, o: RDF::Literal(1) } ]
      end

      it "?s p o / ?s p1 o1" do
          # pattern with variable across 2 patterns
          #self << [EX.x5, EX.p3, EX.x3]
          #self << [EX.x5, EX.p2, EX.x3]
        query = RDF::Query.new do |query|
          query << [:s, EX.p3, EX.x3]
          query << [:s, EX.p2, EX.x3]
        end
        expect(query.execute(graph)).to have_result_set [ { s: EX.x5 } ]
        expect(graph.query(query)).to have_result_set [ { s: EX.x5 } ]
      end

      it "?s1 p ?o1 / ?o1 p2 ?o2 / ?o2 p3 ?o3" do
        query = RDF::Query.new do |query|
          query << [:s, EX.pchain, :o]
          query << [:o, EX.pchain2, :o2]
          query << [:o2, EX.pchain3, :o3]
        end
        expect(query.execute(graph)).to have_result_set [ { s: EX.x6, o: EX.target, o2: EX.target2, o3: EX.target3 } ]
        expect(graph.query(query)).to have_result_set [ { s: EX.x6, o: EX.target, o2: EX.target2, o3: EX.target3 } ]
      end

      it "?same p ?same" do
        query = RDF::Query.new do |query|
          query << [:same, EX.psame, :same]
        end
        expect(query.execute(graph)).to have_result_set [ { same: EX.x4 } ]
        expect(graph.query(query)).to have_result_set [ { same: EX.x4 } ]
      end

      it "chains solutions" do
        q1 = RDF::Query.new << [:s, EX.pchain, :o]
        q2 = RDF::Query.new << [:o, EX.pchain2, :o2]
        q3 = RDF::Query.new << [:o2, EX.pchain3, :o3]
        sol1 = q1.execute(graph)
        sol2 = q2.execute(graph, solutions: sol1)
        sol3 = q3.execute(graph, solutions: sol2)
        expect(sol3).to have_result_set [ { s: EX.x6, o: EX.target, o2: EX.target2, o3: EX.target3 } ]
      end

      it "has bindings" do
        query = RDF::Query.new do |query|
          query << [:s, EX.p, :o]
        end
        bindings = query.execute(graph).bindings
        expect(bindings.keys.sort_by(&:to_s)).to eq [:o, :s]
        expect(bindings[:o].sort).to eq [RDF::Literal.new(1), RDF::Literal.new(2), RDF::Literal.new(3)]
        expect(bindings[:s].sort).to eq [EX.x1, EX.x2, EX.x3]
      end

      # From sp2b benchmark, query 7 bgp 2
      it "?class3 p o / ?doc3 p2 ?class3 / ?doc3 p3 ?bag3 / ?bag3 ?member3 ?doc" do
        @n1 = RDF::Node.new('ref1')
        @n2 = RDF::Node.new('ref2')
        @n3 = RDF::Node.new('ref3')

        graph << [EX.class1, EX.subclass, EX.document]
        graph << [EX.class2, EX.subclass, EX.document]
        graph << [EX.class3, EX.subclass, EX.other]

        graph << [EX.doc1, EX.type, EX.class1]
        graph << [EX.doc2, EX.type, EX.class1]
        graph << [EX.doc3, EX.type, EX.class2]
        graph << [EX.doc4, EX.type, EX.class2]
        graph << [EX.doc5, EX.type, EX.class3]

        graph << [EX.doc1, EX.refs, EX.bag1]
        graph << [EX.doc2, EX.refs, EX.bag2]
        graph << [EX.doc3, EX.refs, EX.bag3]
        graph << [EX.doc5, EX.refs, EX.bag5]

        graph << [EX.bag1, @n1, EX.doc11]
        graph << [EX.bag1, @n2, EX.doc12]
        graph << [EX.bag1, @n3, EX.doc13]

        graph << [EX.bag2, @n1, EX.doc21]
        graph << [EX.bag2, @n2, EX.doc22]
        graph << [EX.bag2, @n3, EX.doc23]

        graph << [EX.bag3, @n1, EX.doc31]
        graph << [EX.bag3, @n2, EX.doc32]
        graph << [EX.bag3, @n3, EX.doc33]

        graph << [EX.bag5, @n1, EX.doc51]
        graph << [EX.bag5, @n2, EX.doc52]
        graph << [EX.bag5, @n3, EX.doc53]

        query = RDF::Query.new do |query|
          query << [:class3, EX.subclass, EX.document]
          query << [:doc3, EX.type, :class3]
          query << [:doc3, EX.refs, :bag3]
          query << [:bag3, :member3, :doc]
        end

        expect(query.execute(graph)).to have_result_set [
          { doc3: EX.doc1, class3: EX.class1, bag3: EX.bag1, member3: @n1, doc: EX.doc11 },
          { doc3: EX.doc1, class3: EX.class1, bag3: EX.bag1, member3: @n2, doc: EX.doc12 },
          { doc3: EX.doc1, class3: EX.class1, bag3: EX.bag1, member3: @n3, doc: EX.doc13 },
          { doc3: EX.doc2, class3: EX.class1, bag3: EX.bag2, member3: @n1, doc: EX.doc21 },
          { doc3: EX.doc2, class3: EX.class1, bag3: EX.bag2, member3: @n2, doc: EX.doc22 },
          { doc3: EX.doc2, class3: EX.class1, bag3: EX.bag2, member3: @n3, doc: EX.doc23 },
          { doc3: EX.doc3, class3: EX.class2, bag3: EX.bag3, member3: @n1, doc: EX.doc31 },
          { doc3: EX.doc3, class3: EX.class2, bag3: EX.bag3, member3: @n2, doc: EX.doc32 },
          { doc3: EX.doc3, class3: EX.class2, bag3: EX.bag3, member3: @n3, doc: EX.doc33 }
        ]
      end

      # From sp2b benchmark, query 7 bgp 1
      it "?class subclass document / ?doc type ?class / ?doc title ?title / ?bag2 ?member2 ?doc / ?doc2 refs ?bag2" do
        @n1 = RDF::Node.new('ref1')
        @n2 = RDF::Node.new('ref2')
        @n3 = RDF::Node.new('ref3')

        graph << [EX.class1, EX.subclass, EX.document]
        graph << [EX.class2, EX.subclass, EX.document]
        graph << [EX.class3, EX.subclass, EX.other]

        graph << [EX.doc1, EX.type, EX.class1]
        graph << [EX.doc2, EX.type, EX.class1]
        graph << [EX.doc3, EX.type, EX.class2]
        graph << [EX.doc4, EX.type, EX.class2]
        graph << [EX.doc5, EX.type, EX.class3]
        # no doc6 type

        graph << [EX.doc1, EX.title, EX.title1]
        graph << [EX.doc2, EX.title, EX.title2]
        graph << [EX.doc3, EX.title, EX.title3]
        graph << [EX.doc4, EX.title, EX.title4]
        graph << [EX.doc5, EX.title, EX.title5]
        graph << [EX.doc6, EX.title, EX.title6]

        graph << [EX.doc1, EX.refs, EX.bag1]
        graph << [EX.doc2, EX.refs, EX.bag2]
        graph << [EX.doc3, EX.refs, EX.bag3]
        graph << [EX.doc5, EX.refs, EX.bag5]

        graph << [EX.bag1, @n1, EX.doc11]
        graph << [EX.bag1, @n2, EX.doc12]
        graph << [EX.bag1, @n3, EX.doc13]

        graph << [EX.bag2, @n1, EX.doc21]
        graph << [EX.bag2, @n2, EX.doc22]
        graph << [EX.bag2, @n3, EX.doc23]

        graph << [EX.bag3, @n1, EX.doc31]
        graph << [EX.bag3, @n2, EX.doc32]
        graph << [EX.bag3, @n3, EX.doc33]

        graph << [EX.bag5, @n1, EX.doc51]
        graph << [EX.bag5, @n2, EX.doc52]
        graph << [EX.bag5, @n3, EX.doc53]

        query = RDF::Query.new do |query|
          query << [:class, EX.subclass, EX.document]
          query << [:doc, EX.type, :class]
          query << [:doc, EX.title, :title]
          query << [:doc, EX.refs, :bag]
          query << [:bag, :member, :doc2]
        end

        expect(query.execute(graph)).to have_result_set [
          { doc: EX.doc1, class: EX.class1, bag: EX.bag1,
            member: @n1, doc2: EX.doc11, title: EX.title1 },
          { doc: EX.doc1, class: EX.class1, bag: EX.bag1,
            member: @n2, doc2: EX.doc12, title: EX.title1 },
          { doc: EX.doc1, class: EX.class1, bag: EX.bag1,
            member: @n3, doc2: EX.doc13, title: EX.title1 },
          { doc: EX.doc2, class: EX.class1, bag: EX.bag2,
            member: @n1, doc2: EX.doc21, title: EX.title2 },
          { doc: EX.doc2, class: EX.class1, bag: EX.bag2,
            member: @n2, doc2: EX.doc22, title: EX.title2 },
          { doc: EX.doc2, class: EX.class1, bag: EX.bag2,
            member: @n3, doc2: EX.doc23, title: EX.title2 },
          { doc: EX.doc3, class: EX.class2, bag: EX.bag3,
            member: @n1, doc2: EX.doc31, title: EX.title3 },
          { doc: EX.doc3, class: EX.class2, bag: EX.bag3,
            member: @n2, doc2: EX.doc32, title: EX.title3 },
          { doc: EX.doc3, class: EX.class2, bag: EX.bag3,
            member: @n3, doc2: EX.doc33, title: EX.title3 },
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
        # FIXME: so?
        # Use set comparison for unordered compare on 1.8.7
        expect(query.execute(graph).map(&:to_h).to_set).to eq [
          {s1: EX.x1, o1: RDF::Literal(1), s2: EX.x1, o2: RDF::Literal(1)},
          {s1: EX.x1, o1: RDF::Literal(1), s2: EX.x2, o2: RDF::Literal(2)},
          {s1: EX.x2, o1: RDF::Literal(2), s2: EX.x1, o2: RDF::Literal(1)},
          {s1: EX.x2, o1: RDF::Literal(2), s2: EX.x2, o2: RDF::Literal(2)},
        ].to_set
      end
    end

    # From data-r2/expr-equals
    context "data/r2/expr-equals" do
      let!(:graph) {
        RDF::Graph.new do |graph|
          graph << [EX.xi1, EX.p, RDF::Literal::Integer.new("1")]
          graph << [EX.xi2, EX.p, RDF::Literal::Integer.new("1")]
          graph << [EX.xi3, EX.p, RDF::Literal::Integer.new("01")]

          graph << [EX.xd1, EX.p, RDF::Literal::Double.new("1.0e0")]
          graph << [EX.xd2, EX.p, RDF::Literal::Double.new("1.0")]
          graph << [EX.xd3, EX.p, RDF::Literal::Double.new("1")]

          graph << [EX.xt1, EX.p, RDF::Literal.new("zzz", datatype: EX.myType)]

          graph << [EX.xp1, EX.p, RDF::Literal.new("zzz")]
          graph << [EX.xp2, EX.p, RDF::Literal.new("1")]

          graph << [EX.xu, EX.p, EX.z]
        end
      }

      describe "graph-1" do
        subject {
          query = RDF::Query.new {pattern [:x, EX.p, RDF::Literal::Integer.new(1)]}
          query.execute(graph)
        }

        it "has two solutions" do
          expect(subject.count).to eq 2
        end

        it "has xi1 as a solution" do
          expect(subject.filter(x: EX.xi1)).not_to be_empty
        end

        it "has xi2 as a solution" do
          expect(subject.filter(x: EX.xi2)).not_to be_empty
        end
      end


      describe "graph-2" do
        subject {
          query = RDF::Query.new {pattern [:x, EX.p, RDF::Literal::Double.new("1.0e0")]}
          query.execute(graph)
        }

        it "has one solution" do
          expect(subject.count).to eq 1
        end

        it "has xd1 as a solution" do
          expect(subject.filter(x: EX.xd1)).not_to be_empty
        end
      end
    end

    it {is_expected.not_to be_variable}
    its(:variable_count) {is_expected.to eql 0}
    its(:variables) {is_expected.to be_empty}

    context "with variables" do
      let!(:graph) {
        # Normally we would not want all of this crap in the graph for each
        # test, but this gives us the nice benefit that each test implicitly
        # tests returning only the correct results and not random other ones.
        RDF::Graph.new do |graph|
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
      }

      context "?s p o" do
        subject {RDF::Query.new(RDF::Query::Pattern.new(:s, EX.p, 1))}
        it {expect(subject.execute(graph)).to have_result_set([{ s: EX.x1 }])}
        its(:variables?) {is_expected.to be_truthy}
        its(:variable_count) {is_expected.to eql 1}
        its(:variables) {is_expected.to include(:s)}
      end

      context "s ?p o" do
        subject {RDF::Query.new(RDF::Query::Pattern.new(EX.x2, :p, 2))}
        it {expect(subject.execute(graph)).to have_result_set([{ p: EX.p }])}
        its(:variables?) {is_expected.to be_truthy}
        its(:variable_count) {is_expected.to eql 1}
        its(:variables) {is_expected.to include(:p)}
      end

      context "s p ?o" do
        subject {RDF::Query.new(RDF::Query::Pattern.new(EX.x3, EX.p, :o))}
        it {expect(subject.execute(graph)).to have_result_set([{ o: RDF::Literal.new(3) }])}
        its(:variables?) {is_expected.to be_truthy}
        its(:variable_count) {is_expected.to eql 1}
        its(:variables) {is_expected.to include(:o)}
      end

      context "?s p ?o" do
        subject {RDF::Query.new(RDF::Query::Pattern.new(:s, EX.p, :o))}
        it {expect(subject.execute(graph)).to have_result_set([
              { s: EX.x1, o: RDF::Literal.new(1) },
              { s: EX.x2, o: RDF::Literal.new(2) },
              { s: EX.x3, o: RDF::Literal.new(3) }])}
        its(:variables?) {is_expected.to be_truthy}
        its(:variable_count) {is_expected.to eql 2}
        its(:variables) {is_expected.to include(:s, :o)}
      end

      context "?s ?p o" do
        subject {RDF::Query.new(RDF::Query::Pattern.new(:s, :p, 3))}
        it {expect(subject.execute(graph)).to have_result_set([{ s: EX.x3, p: EX.p }])}
        its(:variables?) {is_expected.to be_truthy}
        its(:variable_count) {is_expected.to eql 2}
        its(:variables) {is_expected.to include(:s, :p)}
      end

      context "s ?p ?o" do
        subject {RDF::Query.new(RDF::Query::Pattern.new(EX.x1, :p, :o))}
        it {expect(subject.execute(graph)).to have_result_set([{ p: EX.p, o: RDF::Literal(1) }])}
        its(:variables?) {is_expected.to be_truthy}
        its(:variable_count) {is_expected.to eql 2}
        its(:variables) {is_expected.to include(:p, :o)}
      end

      context "GRAPH ?g {s p o}" do
        subject {RDF::Query.new(RDF::Query::Pattern.new(EX.x1, EX.p, EX.o), graph_name: RDF::Query::Variable.new("g"))}
        its(:variables?) {is_expected.to be_truthy}
        its(:variable_count) {is_expected.to eql 1}
        its(:variables) {is_expected.to include(:g)}
      end
    end

    context "with non-distinguished variables" do
      before :each do
        @graph = RDF::Graph.new do |graph|
          graph << [EX.s1, EX.p, EX.o]
          graph << [EX.s2, EX.p, EX.o]
          graph << [EX.s2, EX.p2, EX.o2]
        end
      end

      it "matches graphs with a bound non-distinguished variable" do
        query = RDF::Query.new do |query|
          query.pattern [:s, EX.p, EX.o]
          query.pattern [RDF::Query::Variable.new(:s2, distinguished: false), EX.p2, EX.o2]
        end
        expect(query.execute(@graph)).to have_result_set([{ s: EX.s1, s2: EX.s2 }, { s: EX.s2, s2: EX.s2 }])
      end

      it "matches graphs with a unbound non-distinguished variable"
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
          query.pattern [:s, EX.p2, :o], optional: true
        end
        expect(query.execute(@graph).map(&:to_h).to_set).to eq [
          {s: EX.s1},
          {s: EX.s2, o: EX.o2}
        ].to_set
      end

      it "should raise an error unless all optional patterns follow regular patterns" do
        # SPARQL requires optional patterns to follow the regular patterns.
        # In the interest of compatibility, we enforce similar
        # restrictions, because the semantics of leading optional patterns
        # are hard to get right.
        expect do
          query = RDF::Query.new(validate: true) do |query|
            query.pattern [:s, EX.p2, :o], optional: true
            query.pattern [:s, EX.p, EX.o]
          end
          query.execute(@graph)
        end.to raise_error(ArgumentError)

        expect do
          query = RDF::Query.new(validate: true) do |query|
            query.pattern [:s, EX.p, EX.o]
            query.pattern [:s, EX.p2, :o], optional: true
            query.pattern [:s, EX.x, EX.x]
          end
          query.execute(@graph)
        end.to raise_error(ArgumentError)
      end
    end

    context "with preliminary bindings" do
      let(:graph) {
        RDF::Graph.new do |graph|
          graph << [EX.x1, EX.p, EX.o1]
          graph << [EX.x1, EX.p, EX.o2]
          graph << [EX.x1, EX.p, EX.o3]
          graph << [EX.x1, EX.p, EX.o4]
          graph << [EX.x1, EX.p, EX.o5]
          graph << [EX.x1, EX.p, EX.o6]
        end
      }

      it "limits a variable to the initial bindings" do
        query = RDF::Query.new do |query|
          query << [EX.x1, EX.p, :o]
        end
        expect(query.execute(graph, bindings: { o: [EX.o1, EX.o4]})).to have_result_set [
          {o: EX.o1}, {o: EX.o4}]
      end

      it "uses bindings for multiple variables" do
        graph << [EX.x1, EX.p1, EX.o1]
        graph << [EX.x1, EX.p1, EX.o2]
        graph << [EX.x2, EX.p1, EX.o1]
        query = RDF::Query.new do |query|
          query << [:s, EX.p1, :o]
        end
        expect(query.execute(graph, bindings: {o: [EX.o1], s: [EX.x1]})).to have_result_set [
          {s: EX.x1, o: EX.o1}
        ]
      end

    end

    context "solution modifiers" do
      let!(:graph) {RDF::Repository.load(fixture_path('test.nt'))}
      subject {RDF::Query.new() { pattern [:s, :p, :o]}.execute(graph)}

      context "projection" do
        it "projects all variables" do
          subject.project(:s, :p, :o)
          subject.each do |solution|
            expect(solution.bindings.keys).to include(:s, :p, :o)
          end
        end

        it "projects some variables" do
          subject.project(:s, :p)
          subject.each do |solution|
            expect(solution.bindings.keys).to include(:s, :p)
          end
        end

        it "projects a variable" do
          subject.project(:s)
          subject.each do |solution|
            expect(solution.bindings.keys).to include(:s)
          end
        end
      end

      context "filter" do
        it "returns matching solutions" do
          expect(
            subject.
              filter(s: RDF::URI("http://example.org/resource1")).
              count
          ).to eq 1
        end

        it "accepts a block" do
          expect(
            subject.
              filter {|s| s[:s] == RDF::URI("http://example.org/resource1")}.
              count
          ).to eq 1
        end
      end

      context "order" do
        it "returns ordered solutions using a symbol" do
          orig = subject.dup
          expect(subject.order(:o).map(&:o)).to eq orig.map(&:o).sort
        end

        it "returns ordered solutions using a variable" do
          orig = subject.dup
          expect(subject.order(RDF::Query::Variable.new("o")).map(&:o)).to eq orig.map(&:o).sort
        end

        it "returns ordered solutions using a lambda" do
          orig = subject.dup
          expect(subject.order(lambda {|a, b| a[:o] <=> b[:o]}).map(&:o)).to eq orig.map(&:o).sort
        end

        it "returns ordered solutions using a lambda symbols" do
          subject.order(:s, lambda {|a, b| a[:p] <=> b[:p]}, RDF::Query::Variable.new("o"))
        end

        it "returns ordered solutions using block" do
          subject.order {|a, b| a[:p] <=> b[:p]}
        end
      end

      it "should support duplicate elimination" do
        [:distinct, :reduced].each do |op|
          solutions = RDF::Query::Solutions(subject.to_a * 2)
          expect(solutions.count).to eq graph.size * 2
          solutions.send(op)
          expect(solutions.count).to eq graph.size
        end
      end

      it "should support offsets" do
        subject.offset(10)
        expect(subject.count).to eq graph.size - 10
      end

      it "should support limits" do
        subject.limit(10)
        expect(subject.count).to eq 10
      end
    end
  end

  context "#graph_name" do
    it "returns nil by default" do
      expect(subject.graph_name).to be_nil
    end

    it "sets and returns a graph_name" do
      subject.graph_name = RDF.first
      expect(subject.graph_name).to eq RDF.first
    end
  end

  context "#graph_name=" do
    it "returns set graph_name" do
      expect((subject.graph_name = RDF::URI("c"))).to eq RDF::URI("c")
      expect((subject.graph_name = :default)).to eq :default
    end
  end

  describe "#named?" do
    it "returns false with no graph_name" do
      expect(subject.named?).to be_falsey
    end

    it "returns true with a graph_name" do
      subject.graph_name = RDF.first
      expect(subject.named?).to be_truthy
    end
  end

  describe "#unnamed?" do
    it "returns true with no graph_name" do
      expect(subject.unnamed?).to be_truthy
    end

    it "returns false with a graph_name" do
      subject.graph_name = RDF.first
      expect(subject.unnamed?).to be_falsey
    end
  end

  describe "#+" do
    it "returns a new RDF::Query" do
      rhs = RDF::Query.new
      q = subject + rhs
      expect(q).not_to be_equal(subject)
      expect(q).not_to be_equal(rhs)
    end

    it "contains patterns from each query in order" do
      subject.pattern [EX.first, EX.second, EX.third]
      rhs = RDF::Query.new
      subject.pattern [EX.a, EX.b, EX.c]
      q = subject + rhs
      expect(q.patterns).to eq [[EX.first, EX.second, EX.third], [EX.a, EX.b, EX.c]]
    end
  end

  describe "#each_solution" do
    let!(:graph) {RDF::Graph.new.insert(*RDF::Spec.triples)}
    it "enumerates solutions" do
      query = RDF::Query.new do
        pattern [:person, RDF.type, FOAF.Person]
      end
      query.execute(graph)
      expect {|b| query.each_solution(&b)}.to yield_control.at_least(3)
      query.each_solution do |solution|
        expect(solution).to be_a(RDF::Query::Solution)
      end
    end
  end

  describe "#each_statement" do
    let!(:graph) {RDF::Graph.new.insert(*RDF::Spec.triples)}
    it "enumerates solutions" do
      query = RDF::Query.new do
        pattern [:person, RDF.type, FOAF.Person]
      end
      expect {|b| query.each_statement(&b)}.to yield_control.once
      query.each_statement do |pattern|
        expect(pattern).to be_a(RDF::Query::Pattern)
      end
    end
  end

  context "validation" do
    {
      "query with no patterns" => [
        described_class.new,
        true
      ],
      "query with valid pattern" => [
        described_class.new {pattern [RDF::URI("https://rubygems.org/gems/rdf"), RDF::URI("http://purl.org/dc/terms/creator"), :var]},
        true
      ],
      "query with invalid pattern" => [
        described_class.new {pattern [RDF::URI("https://rubygems.org/gems/rdf"), "creator", :var]},
        false
      ],
      "query with optional pattern" => [
        described_class.new {
          pattern RDF::Query::Pattern.new(RDF::URI("https://rubygems.org/gems/rdf"), RDF::URI("http://purl.org/dc/terms/creator"), :var, optional: true)
        },
        true
      ],
      "query with required and optional patterns" => [
        described_class.new {
          pattern RDF::Query::Pattern.new(RDF::URI("https://rubygems.org/gems/rdf"), RDF::URI("http://purl.org/dc/terms/creator"), :var)
          pattern RDF::Query::Pattern.new(RDF::URI("https://rubygems.org/gems/rdf-spec"), RDF::URI("http://purl.org/dc/terms/creator"), :var, optional: true)
        },
        true
      ],
      "query with optional and required patterns" => [
        described_class.new {
          pattern RDF::Query::Pattern.new(RDF::URI("https://rubygems.org/gems/rdf-spec"), RDF::URI("http://purl.org/dc/terms/creator"), :var, optional: true)
          pattern RDF::Query::Pattern.new(RDF::URI("https://rubygems.org/gems/rdf"), RDF::URI("http://purl.org/dc/terms/creator"), :var)
        },
        false
      ],
    }.each do |title, (query, valid)|
      context title do
        if valid
          specify {expect(query).to be_valid}
          specify {expect(query).not_to be_invalid}
          describe "#validate!" do
            specify {expect {query.validate!}.not_to raise_error}
          end
        else
          specify {expect(query).not_to be_valid}
          specify {expect(query).to be_invalid}
          describe "#validate!" do
            specify {expect {query.validate!}.to raise_error(ArgumentError)}
          end
        end
      end
    end
  end

  context "Examples" do
    let!(:graph) {RDF::Graph.new.insert(RDF::Spec.triples.extend(RDF::Enumerable))}
    subject {
      query = RDF::Query.new do
        pattern [:person, RDF.type,  FOAF.Person]
        pattern [:person, FOAF.name, :name]
        pattern [:person, FOAF.mbox, :email]
      end
    }
    it "Constructing a basic graph pattern query (1)" do
      expect(subject).to be_a(RDF::Query)
      expect(subject.patterns.size).to eq 3
      expect(subject.patterns[0]).to eq RDF::Query::Pattern.new(:person, RDF.type,  FOAF.Person)
      expect(subject.patterns[1]).to eq RDF::Query::Pattern.new(:person, FOAF.name, :name)
      expect(subject.patterns[2]).to eq RDF::Query::Pattern.new(:person, FOAF.mbox, :email)
    end

    it "Constructing a basic graph pattern query (2)" do
      query = RDF::Query.new({
        person: {
          RDF.type  => FOAF.Person,
          FOAF.name => :name,
          FOAF.mbox => :email,
        }
      }, **{})
      expect(query).to be_a(RDF::Query)
      expect(query.patterns.size).to eq 3
      expect(query.patterns[0]).to eq RDF::Query::Pattern.new(:person, RDF.type,  FOAF.Person)
      expect(query.patterns[1]).to eq RDF::Query::Pattern.new(:person, FOAF.name, :name)
      expect(query.patterns[2]).to eq RDF::Query::Pattern.new(:person, FOAF.mbox, :email)
    end

    it "Executing a basic graph pattern query" do
      expect(subject.execute(graph).each.to_a.size).to be >= 3
    end

    it "Constructing and executing a query in one go (1)" do
      solutions = RDF::Query.execute(graph) do
        pattern [:person, RDF.type, FOAF.Person]
      end
      expect(solutions.to_a.size).to be >= 3
    end

    it "Constructing and executing a query in one go (2)" do
      solutions = RDF::Query.execute(graph, {
        person: {
          RDF.type => FOAF.Person,
        }
      })
      expect(solutions.to_a.size).to be >= 3
    end
  end
end
