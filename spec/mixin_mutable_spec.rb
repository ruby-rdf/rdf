require File.join(File.dirname(__FILE__), 'spec_helper')
require 'rdf/ntriples'

describe RDF::Mutable do
  before :each do
    @filename   = etc_file("doap.nt")
    # Possible reference implementations are RDF::Repository and RDF::Graph.
    @repo       = RDF::Repository.new
    @subject    = RDF::URI.new("http://rubygems.org/gems/rdf")
    @context    = RDF::URI.new("http://example.org/context")
  end

  it "should support #load" do
    @repo.respond_to?(:load).should be_true
  end

  context "#load" do
    it "should require an argument" do
      lambda { @repo.load }.should raise_error(ArgumentError)
    end

    it "should accept a string filename argument" do
      lambda { @repo.load(@filename) }.should_not raise_error(ArgumentError)
    end

    it "should accept an optional hash argument" do
      lambda { @repo.load(@filename,{}) }.should_not raise_error(ArgumentError)
    end

    it "should load statements" do
      @repo.load @filename
      @repo.size.should ==  File.readlines(@filename).size
      @repo.should have_subject @subject
    end

    it "should load statements with a context override" do
      @repo.load @filename, :context => @context
      @repo.should have_context @context
      @repo.query(:context => @context).size.should == @repo.size
    end

  end
end
