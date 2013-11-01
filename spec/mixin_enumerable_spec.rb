require File.join(File.dirname(__FILE__), 'spec_helper')
require 'rdf/spec/enumerable'

describe RDF::Enumerable do
  before :each do
    # The available reference implementations are `RDF::Repository` and
    # `RDF::Graph`, but a plain Ruby array will do fine as well:
    @enumerable = RDF::Spec.quads.extend(RDF::Enumerable)
  end

  # @see lib/rdf/spec/enumerable.rb in rdf-spec
  include RDF_Enumerable

  context "Examples" do
    before(:each) {$stdout = StringIO.new}
    after(:each) {$stdout = STDOUT}
    subject {@enumerable}

    context "Checking whether any statements exist" do
      subject {[].extend(RDF::Enumerable)}
      it {should be_empty}
    end

    context "Checking how many statements exist" do
      its(:count) {should == subject.size}
    end

    context "Checking whether a specific statement exists" do
      let(:statement) {subject.detect {|s| s.to_a.none?(&:node?)}}
      it {should have_statement(statement)}
      it {should have_triple(statement.to_a)}
      xit {should have_quad(statement.to_a)}
    end

    context "Checking whether a specific value exists" do
      it {should have_subject(RDF::URI("http://rubygems.org/gems/rdf"))}
      it {should have_predicate(RDF::DC.creator)}
      it {should have_object(RDF::Literal("A Ruby library for working with Resource Description Framework (RDF) data.", :language => :en))}
      it {should have_context(RDF::URI("http://ar.to/#self"))}
    end

    it "Enumerating all statements" do
      subject.each_statement {|statement| $stdout.puts statement.inspect}
      $stdout.rewind
      expect($stdout.read).not_to be_empty
    end

    it "Enumerating all statements in the form of triples" do
      subject.each_triple do |subject, predicate, object|
        $stdout.puts [subject, predicate, object].inspect
      end
      $stdout.rewind
      expect($stdout.read).not_to be_empty
    end

    it "Enumerating all statements in the form of quads" do
      subject.each_quad do |subject, predicate, object, context|
        $stdout.puts [subject, predicate, object, context].inspect
      end
      $stdout.rewind
      expect($stdout.read).not_to be_empty
    end

    context "Enumerating all terms" do
      %w(each_subject each_predicate each_object each_context).each do |method|
        it "##{method}" do
          subject.send(method.to_sym) {|term| $stdout.puts term.inspect}
          $stdout.rewind
          expect($stdout.read).not_to be_empty
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
      %w(subjects predicates objects contexts).each do |method|
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
