require File.join(File.dirname(__FILE__), 'spec_helper')
require 'rdf/spec/format'
require 'rdf/ntriples'
require 'rdf/nquads'

class RDF::Format::FooFormat < RDF::Format
  content_type     'application/test;q=1',
                   extension: :test
  reader { RDF::NTriples::Reader }
  def self.detect(sample)
    sample == "foo"
  end
  def self.to_sym; :foo_bar; end
end

class RDF::Format::BarFormat < RDF::Format
  content_type     'application/test',
                   extension: :test,
                   alias: 'application/x-test;q=0.1'
  reader { RDF::NTriples::Reader }
  def self.detect(sample)
    sample == "bar"
  end
  def self.to_sym; :foo_bar; end
end

describe RDF::Format do

  # @see lib/rdf/spec/format.rb in rdf-spec
  it_behaves_like 'an RDF::Format' do
    let(:format_class) { described_class }
  end

  # If there are multiple formats that assert the same type or extension,
  # Format.for should yield to return a sample used for detection
  describe ".for" do
    {
      "symbol"              => :foo_bar,
      "path with extension" => "filename.test",
      "domain with no path" => {file_name: "http://example.org"},
      "file_name"           => {file_name: "filename.test"},
      "file_extension"      => {file_extension: "test"},
      "content_type"        => {content_type: "application/test"},
      "URI"                 => RDF::URI("filename.test"),
      "fragment"            => "filename.test#fragment",
      "query"               => "filename.test?query",
    }.each do |condition, arg|
      context condition do
        it "yields given duplicates" do
          expect {|b| RDF::Format.for(arg, &b)}.to yield_control
        end

        it "returns nil last defined format for duplicates" do
          expect(RDF::Format.for(arg) || RDF::Format::BarFormat).to eq RDF::Format::BarFormat
        end

        it "returns detected format for duplicates" do
          expect(RDF::Format.for(arg) { "foo" }).to eq RDF::Format::FooFormat
          expect(RDF::Format.for(arg) { "bar" }).to eq RDF::Format::BarFormat
        end
      end
    end

    it "returns no formats if none match" do
      expect(RDF::Format.for).to be_nil
    end

    it "returns any format for content_type: */*" do
      expect(RDF::Format.for(content_type: '*/*')).to be_a(Class)
    end

    it "returns any format having appropriate prefix for content_type: application/*" do
      f = RDF::Format.for(content_type: 'application/*')
      expect(f).to be_a(Class)
      expect(f.content_type).to all(start_with('application/'))
    end
  end

  # Format.each also can take options to filter results
  describe ".each" do
    {
      "file_name"           => {file_name: "filename.test"},
      "file_extension"      => {file_extension: "test"},
      "content_type"        => {content_type: "application/test"},
    }.each do |condition, arg|
      context condition do
        it "yields matched formats" do
          expect {|b| RDF::Format.each(**arg, &b)}.to yield_successive_args(RDF::Format::FooFormat, RDF::Format::BarFormat)
        end

        it "returns detected format for duplicates" do
          expect(RDF::Format.for(**arg, sample: "foo")).to eq RDF::Format::FooFormat
          expect(RDF::Format.for(**arg, sample: "bar")).to eq RDF::Format::BarFormat
        end

        it "returns detected format for duplicates using proc" do
          expect(RDF::Format.for(**arg, sample: -> {"foo"})).to eq RDF::Format::FooFormat
          expect(RDF::Format.for(**arg, sample: -> {"bar"})).to eq RDF::Format::BarFormat
        end
      end
    end
  end

  describe ".reader_symbols" do
    it "returns symbols of available readers" do
      [:ntriples, :nquads, :foo_bar].each do |sym|
        expect(RDF::Format.reader_symbols).to include(sym)
      end
    end
  end

  describe ".reader_types" do
    it "returns content-types of available readers" do
      expect(RDF::Format.reader_types).to include(*%w(
        application/n-triples text/plain
        application/n-quads text/x-nquads
        application/test application/x-test
      ))
    end
  end

  describe ".accept_types" do
    it "returns accept-types of available readers with quality" do
      expect(RDF::Format.accept_types).to include(*%w(
        application/n-triples text/plain;q=0.2
        application/n-quads text/x-nquads;q=0.2
        application/test application/x-test;q=0.1
      ))
    end
  end

  describe ".writer_symbols" do
    it "returns symbols of available writers" do
      [:ntriples, :nquads].each do |sym|
        expect(RDF::Format.writer_symbols).to include(sym)
      end
      [:fooformat, :barformat].each do |sym|
        expect(RDF::Format.writer_symbols).not_to include(sym)
      end
    end
  end

  describe ".writer_types" do
    it "returns content-types of available writers" do
      %w(
        application/n-triples text/plain
        application/n-quads text/x-nquads
      ).each do |ct|
        expect(RDF::Format.writer_types).to include(ct)
      end
      expect(RDF::Format.writer_types).not_to include("application/test")
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
      its(:content_type) {is_expected.to match content_types}
      its(:file_extension) {is_expected.to match file_extensions}
    end
  end

  context "Examples" do
    require 'rdf/ntriples'
    subject {RDF::Format}

    its(:each) do
      expect {RDF::Format.each {|klass| $stdout.puts klass.name}}.to write(:something)
    end

    its(:"for") do
      [
        :ntriples,
        "etc/doap.nt",
        {file_name: "etc/doap.nt"},
        {file_extension: "nt"},
        {content_type: "application/n-triples"}
      ].each do |arg|
        expect(subject.for(arg)).to eq RDF::NTriples::Format
      end
    end

    it "has content-type application/n-triples" do
      expect(subject.content_types["application/n-triples"]).to include(RDF::NTriples::Format)
    end
    it "has file extension .nt" do
      expect(subject.file_extensions[:nt]).to include(RDF::NTriples::Format)
    end

    it "Defining a new RDF serialization format class" do
      expect {
        class RDF::NTriples::Format < RDF::Format
          content_type     'application/n-triples', extension: :nt
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
      specify {expect(RDF::NTriples::Format.name).to eq "N-Triples"}
    end

    describe ".detect" do
      specify {expect(RDF::NTriples::Format.detect("<a> <b> <c> .")).to be_truthy}
    end
  end
end
