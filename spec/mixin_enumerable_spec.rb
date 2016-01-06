require File.join(File.dirname(__FILE__), 'spec_helper')
require 'rdf/spec/enumerable'

describe RDF::Enumerable do
  # @see lib/rdf/spec/enumerable.rb in rdf-spec
  it_behaves_like 'an RDF::Enumerable' do
    # The available reference implementations are `RDF::Repository` and
    # `RDF::Graph`, but a plain Ruby array will do fine as well:
    let(:enumerable) { RDF::Spec.quads.extend(described_class) }
  end

  context "Examples" do
    subject { RDF::Spec.quads.extend(described_class) }

    context "Checking whether any statements exist" do
      subject {[].extend(RDF::Enumerable)}
      it {is_expected.to be_empty}
    end

    context "Checking how many statements exist" do
      its(:count) {is_expected.to eq subject.size}
    end

    context "Checking whether a specific statement exists" do
      let(:statement) {subject.detect {|s| s.to_a.none?(&:node?)}}
      it {is_expected.to have_statement(statement)}
      it {is_expected.to have_triple(statement.to_a)}
      it do
        quad = statement.to_a
        quad[3] ||= nil
        is_expected.to have_quad(quad)
      end
    end

    context "Checking whether a specific value exists" do
      it {is_expected.to have_subject(RDF::URI("http://rubygems.org/gems/rdf"))}
      it {is_expected.to have_predicate(RDF.type)}
      it {is_expected.to have_object(RDF::Literal("A Ruby library for working with Resource Description Framework (RDF) data.", language: :en))}
      it {is_expected.to have_graph(RDF::URI("http://ar.to/#self"))}
    end

    it "Enumerating all statements" do
      expect {
        subject.each_statement {|statement| $stdout.puts statement.inspect}
      }.to write(:something)
    end

    it "Enumerating all statements in the form of triples" do
      expect {
        subject.each_triple do |subject, predicate, object|
          $stdout.puts [subject, predicate, object].inspect
        end
      }.to write(:something)
    end

    it "Enumerating all statements in the form of quads" do
      expect {
        subject.each_quad do |subject, predicate, object, graph_name|
          $stdout.puts [subject, predicate, object, graph_name].inspect
        end
      }.to write(:something)
    end

    context "Enumerating all terms" do
      %w(each_subject each_predicate each_object each_graph).each do |method|
        it "##{method}" do
          expect {
            subject.send(method.to_sym) {|term| $stdout.puts term.inspect}
          }.to write(:something)
        end
      end
    end

    context "Obtaining all statements" do
      %w(statements triples quads).each do |method|
        it "##{method}" do
          expect(subject.send(method.to_sym).to_a).not_to be_empty
        end
      end
    end

    context "Obtaining all unique values" do
      %w(subjects predicates objects).each do |method|
        it "##{method}" do
          expect(subject.send(method.to_sym).to_a).not_to be_empty
        end
      end
    end

    describe "#dump" do
      it "Serializing into N-Triples format" do
        expect(subject.dump(:ntriples)).not_to be_empty
      end
    end
  end
end
