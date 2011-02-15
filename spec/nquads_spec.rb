# -*- encoding: utf-8 -*-
require File.join(File.dirname(__FILE__), 'spec_helper')
require 'rdf/nquads'
require 'rdf/spec/format'
require 'rdf/spec/reader'
require 'rdf/spec/writer'

describe RDF::NQuads::Format do
  before(:each) { pending "N-Quads is not supported yet" }
  before(:each) do
    @format_class = RDF::NQuads::Format
  end
  
  # @see lib/rdf/spec/format.rb in rdf-spec
  it_should_behave_like RDF_Format


  it "should be discoverable" do
    formats = [
      RDF::Format.for(:nquads),
      RDF::Format.for('etc/doap.nq'),
      RDF::Format.for(:file_name      => 'etc/doap.nq'),
      RDF::Format.for(:file_extension => 'nq'),
      RDF::Format.for(:content_type   => 'text/x-nquads'),
    ]
    formats.each { |format| format.should == RDF::NQuads::Format }
  end
end

describe RDF::NQuads::Reader do
  before(:each) { pending "N-Quads is not supported yet" }
  before(:each) do
    @reader = RDF::NQuads::Reader.new
  end
  
  # @see lib/rdf/spec/reader.rb in rdf-spec
  it_should_behave_like RDF_Reader


  it "should be discoverable" do
    readers = [
      RDF::Reader.for(:nquads),
      RDF::Reader.for('etc/doap.nq'),
      RDF::Reader.for(:file_name      => 'etc/doap.nq'),
      RDF::Reader.for(:file_extension => 'nq'),
      RDF::Reader.for(:content_type   => 'text/x-nquads'),
    ]
    readers.each { |reader| reader.should == RDF::NQuads::Reader }
  end
end

describe RDF::NQuads::Writer do
  before(:each) { pending "N-Quads is not supported yet" }
  before(:each) do
    @writer = RDF::NTriples::Writer.new
  end
  
  # @see lib/rdf/spec/writer.rb in rdf-spec
  it_should_behave_like RDF_Writer


  it "should be discoverable" do
    writers = [
      RDF::Writer.for(:nquads),
      RDF::Writer.for('tmp/test.nq'),
      RDF::Writer.for(:file_name      => 'tmp/test.nq'),
      RDF::Writer.for(:file_extension => 'nq'),
      RDF::Writer.for(:content_type   => 'text/x-nquads'),
    ]
    writers.each { |writer| writer.should == RDF::NQuads::Writer }
  end
end
