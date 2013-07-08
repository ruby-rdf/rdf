require File.join(File.dirname(__FILE__), 'spec_helper')
require 'rdf/spec/format'
require 'rdf/ntriples'
require 'rdf/nquads'

class RDF::Format::FooFormat < RDF::Format
  content_type     'application/test', :extension => :test
  reader { RDF::NTriples::Reader }
  def self.detect(sample)
    sample == "foo"
  end
end

class RDF::Format::BarFormat < RDF::Format
  content_type     'application/test', :extension => :test
  reader { RDF::NTriples::Reader }
  def self.detect(sample)
    sample == "bar"
  end
end

describe RDF::Format do
  before(:each) do
    @format_class = RDF::Format
  end
  
  # @see lib/rdf/spec/format.rb in rdf-spec
  include RDF_Format
  
  # If there are multiple formats that assert the same type or extension,
  # Format.for should yield to return a sample used for detection
  describe ".for" do
    {
      "path with extension" => "filename.test",
      "file_name"           => {:file_name => "filename.test"},
      "file_extension"      => {:file_extension => "test"},
      "content_type"        => {:content_type => "application/test"},
    }.each do |condition, arg|
      it "yields given conflicting #{condition}" do
        yielded = false
        RDF::Format.for(arg) { yielded = true }
        yielded.should be_true
      end

      it "returns detected format given conflicting #{condition}" do
        RDF::Format.for(arg) { "foo" }.should == RDF::Format::FooFormat
        RDF::Format.for(arg) { "bar" }.should == RDF::Format::BarFormat
      end
    end
  end

  describe ".reader_symbols" do
    it "returns symbols of available readers" do
      [:ntriples, :nquads, :fooformat, :barformat].each do |sym|
        RDF::Format.reader_symbols.should include(sym)
      end
    end
  end

  describe ".reader_types" do
    it "returns content-types of available readers" do
      %w(
        application/n-triples text/plain
        application/n-quads text/x-nquads
        application/test
      ).each do |ct|
        RDF::Format.reader_types.should include(ct)
      end
    end
  end

  describe ".writer_symbols" do
    it "returns symbols of available writers" do
      [:ntriples, :nquads].each do |sym|
        RDF::Format.writer_symbols.should include(sym)
      end
      [:fooformat, :barformat].each do |sym|
        RDF::Format.writer_symbols.should_not include(sym)
      end
    end
  end

  describe ".writer_types" do
    it "returns content-types of available writers" do
      %w(
        application/n-triples text/plain
        application/n-quads text/x-nquads
      ).each do |ct|
        RDF::Format.writer_types.should include(ct)
      end
      RDF::Format.writer_types.should_not include("application/test")
    end
  end

  RDF::Format.each do |format|
    context format.name do
      subject {format}
      let(:content_types) {
        RDF::Format.content_types.map {|ct, f| ct if f.include?(format)}.compact
      }
      let(:file_extensions) {
        RDF::Format.file_extensions.map {|ext, f| ext if f.include?(format)}.compact
      }
      its(:content_type) {should =~ content_types}
      its(:file_extension) {should =~ file_extensions}
    end
  end

  context "Examples" do
    require 'rdf/ntriples'
    before(:each) {$stdout = StringIO.new}
    after(:each) {$stdout = STDOUT}
    subject {RDF::Format}

    its(:each) do
      RDF::Format.each {|klass| $stdout.puts klass.name}
      $stdout.rewind
      $stdout.read.should_not be_empty
    end

    its(:"for") do
      [
        :ntriples,
        "etc/doap.nt",
        {:file_name => "etc/doap.nt"},
        {:file_extension => "nt"},
        {:content_type => "application/n-triples"}
      ].each do |arg|
        subject.for(arg).should == RDF::NTriples::Format
      end
    end

    its(:content_types) {should include({"application/n-triples" => [RDF::NTriples::Format]})}
    its(:file_extensions) {should include({:nt => [RDF::NTriples::Format]})}

    it "Defining a new RDF serialization format class" do
      expect {
        class RDF::NTriples::Format < RDF::Format
          content_type     'application/n-triples', :extension => :nt
          content_encoding 'utf-8'
          
          reader RDF::NTriples::Reader
          writer RDF::NTriples::Writer
        end
      }.not_to raise_error
    end

    it "Instantiating an RDF reader or writer class (1)" do
      expect {
        subject.for(:ntriples).reader.new($stdin)  { |reader|}
        subject.for(:ntriples).writer.new($stdout) { |writer|}
      }.not_to raise_error
    end

    it "Instantiating an RDF reader or writer class (2)" do
      expect {
        RDF::Reader.for(:ntriples).new($stdin)  { |reader|}
        RDF::Writer.for(:ntriples).new($stdout) { |writer|}
      }.not_to raise_error
    end

    describe ".name" do
      specify {RDF::NTriples::Format.name.should == "N-Triples"}
    end

    describe ".detect" do
      specify {RDF::NTriples::Format.detect("<a> <b> <c> .").should be_true}
    end
  end
end
