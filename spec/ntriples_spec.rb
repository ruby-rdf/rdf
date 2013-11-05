# -*- encoding: utf-8 -*-
require File.join(File.dirname(__FILE__), 'spec_helper')
require 'rdf/ntriples'
require 'rdf/spec/format'
require 'rdf/spec/reader'
require 'rdf/spec/writer'

describe RDF::NTriples::Format do
  before(:each) do
    @format_class = RDF::NTriples::Format
  end
  
  # @see lib/rdf/spec/format.rb in rdf-spec
  include RDF_Format

  subject {@format_class}

  describe ".for" do
    formats = [
      :ntriples,
      'etc/doap.nt',
      {:file_name      => 'etc/doap.nt'},
      {:file_extension => 'nt'},
      {:content_type   => 'text/plain'},
      {:content_type   => 'application/n-triples'},
    ].each do |arg|
      it "discovers with #{arg.inspect}" do
        expect(RDF::Format.for(arg)).to eq subject
      end
    end

    {
      :ntriples => "<a> <b> <c> .",
      :literal => '<a> <b> "literal" .',
      :multi_line => %(<a>\n  <b>\n  "literal"\n .),
    }.each do |sym, str|
      it "detects #{sym}" do
        expect(subject.for {str}).to eq subject
      end
    end
  end

  describe "#to_sym" do
    specify {expect(subject.to_sym).to eq :ntriples}
  end

  describe "#name" do
    specify {expect(subject.name).to eq "N-Triples"}
  end
  
  describe ".detect" do
    {
      :ntriples => "<a> <b> <c> .",
      :literal => '<a> <b> "literal" .',
      :multi_line => %(<a>\n  <b>\n  "literal"\n .),
    }.each do |sym, str|
      it "detects #{sym}" do
        expect(subject.detect(str)).to be_true
      end
    end

    {
      :nquads        => "<a> <b> <c> <d> . ",
      :nq_literal    => '<a> <b> "literal" <d> .',
      :nq_multi_line => %(<a>\n  <b>\n  "literal"\n <d>\n .),
      :turtle        => "@prefix foo: <bar> .\n foo:a foo:b <c> .",
      :trig          => "{<a> <b> <c> .}",
      :rdfxml        => '<rdf:RDF about="foo"></rdf:RDF>',
      :n3            => '@prefix foo: <bar> .\nfoo:bar = {<a> <b> <c>} .',
    }.each do |sym, str|
      it "does not detect #{sym}" do
        expect(subject.detect(str)).to be_false
      end
    end
  end
end

describe RDF::NTriples::Reader do
  let!(:doap) {File.expand_path("../../etc/doap.nt", __FILE__)}
  let!(:doap_count) {File.open(doap).each_line.to_a.length}
  before(:each) do
    @reader = RDF::NTriples::Reader.new
  end
  
  # @see lib/rdf/spec/reader.rb in rdf-spec
  include RDF_Reader

  describe ".for" do
    formats = [
      :ntriples,
      'etc/doap.nt',
      {:file_name      => 'etc/doap.nt'},
      {:file_extension => 'nt'},
      {:content_type   => 'application/n-triples'},
      {:content_type   => 'text/plain'},
    ].each do |arg|
      it "discovers with #{arg.inspect}" do
        expect(RDF::Reader.for(arg)).to eq RDF::NTriples::Reader
      end
    end

    context "content_type text/plain with non-N-Triples content" do
      {
        :nquads        => "<a> <b> <c> <d> . ",
        :nq_literal    => '<a> <b> "literal" <d> .',
        :nq_multi_line => %(<a>\n  <b>\n  "literal"\n <d>\n .),
      }.each do |sym, str|
        it "does not detect #{sym}" do
          f = RDF::Reader.for(:content_type => "text/plain", :sample => str)
          expect(f).not_to eq RDF::NTriples::Reader
        end
      end
    end
  end

  it "should return :ntriples for to_sym" do
    expect(@reader.class.to_sym).to eq :ntriples
    expect(@reader.to_sym).to eq :ntriples
  end

  describe ".initialize" do
    it "reads doap string" do
      g = RDF::Graph.new << RDF::NTriples::Reader.new(File.read(doap))
      expect(g.count).to eq doap_count
    end
    it "reads doap IO" do
      g = RDF::Graph.new
      RDF::NTriples::Reader.new(File.open(doap)) do |r|
        g << r
      end
      expect(g.count).to eq doap_count
    end
  end

  describe ".open" do
    it "reads doap string" do
      g = RDF::Graph.new
      RDF::NTriples::Reader.open(doap) do |r|
        g << r
      end
      expect(g.count).to eq doap_count
    end
  end
end

describe RDF::NTriples::Writer do
  before(:each) do
    @writer_class = RDF::NTriples::Writer
    @writer = RDF::NTriples::Writer.new
  end

  describe ".for" do
    formats = [
      :ntriples,
      'etc/doap.nt',
      {:file_name      => 'etc/doap.nt'},
      {:file_extension => 'nt'},
      {:content_type   => 'text/plain'},
      {:content_type   => 'application/n-triples'},
    ].each do |arg|
      it "discovers with #{arg.inspect}" do
        expect(RDF::Writer.for(arg)).to eq RDF::NTriples::Writer
      end
    end
  end

  # @see lib/rdf/spec/writer.rb in rdf-spec
  include RDF_Writer

  it "should return :ntriples for to_sym" do
    expect(RDF::NTriples::Writer.to_sym).to eq :ntriples
  end

  context "validataion" do
    it "defaults validation to true" do
      expect(subject).to be_validate
    end

    shared_examples "validation" do |statement, valid|
      context "given #{statement}" do
        let(:graph) {RDF::Graph.new << statement}
        subject {RDF::NTriples::Writer.buffer(:validate => true) {|w| w << graph}}
        if valid
          specify {expect {subject}.not_to raise_error}
        else
          specify {expect {subject}.to raise_error(RDF::WriterError)}
        end
      end
    end
    {
      RDF::Statement.new(RDF::URI("http://rubygems.org/gems/rdf"), RDF::DC.creator, RDF::URI("http://ar.to/#self")) => true,
      RDF::Statement.new(RDF::Node("node"), RDF::DC.creator, RDF::URI("http://ar.to/#self")) => true,
      RDF::Statement.new(RDF::URI("http://rubygems.org/gems/rdf"), RDF::DC.creator, RDF::Node("node")) => true,
      RDF::Statement.new(RDF::URI("http://rubygems.org/gems/rdf"), RDF::DC.creator, RDF::Literal("literal")) => true,
      RDF::Statement.new(RDF::URI('file:///path/to/file with spaces.txt'), RDF::DC.creator, RDF::URI("http://ar.to/#self")) => false,
      RDF::Statement.new(nil, RDF::DC.creator, RDF::URI("http://ar.to/#self")) => false,
      RDF::Statement.new(RDF::URI("http://rubygems.org/gems/rdf"), nil, RDF::URI("http://ar.to/#self")) => false,
      RDF::Statement.new(RDF::URI("http://rubygems.org/gems/rdf"), RDF::DC.creator, nil) => false,
      RDF::Statement.new(RDF::Literal("literal"), RDF::DC.creator, RDF::URI("http://ar.to/#self")) => false,
      RDF::Statement.new(RDF::URI("http://rubygems.org/gems/rdf"), RDF::Node("node"), RDF::URI("http://ar.to/#self")) => false,
      RDF::Statement.new(RDF::URI("http://rubygems.org/gems/rdf"), RDF::Literal("literal"), RDF::URI("http://ar.to/#self")) => false,
    }.each do |st, valid|
      include_examples "validation", st, valid
    end
  end

  # Fixme, these should go in rdf/spec/writer.rb
  context "c14n" do
    shared_examples "c14n" do |statement, result|
      context "given #{statement}" do
        let(:graph) {RDF::Graph.new << statement}
        subject {RDF::NTriples::Writer.buffer(:validate => false, :canonicalize => true) {|w| w << graph}}
        if result
          specify {expect(subject).to eq "#{result}\n"}
        else
          specify {expect {subject}.to raise_error(RDF::WriterError)}
        end
      end
    end
    {
      RDF::Statement.new(RDF::URI("http://rubygems.org/gems/rdf"), RDF::DC.creator.dup, RDF::URI("http://ar.to/#self")) =>
        RDF::Statement.new(RDF::URI("http://rubygems.org/gems/rdf"), RDF::DC.creator.dup, RDF::URI("http://ar.to/#self")),
      RDF::Statement.new(RDF::URI("http://rubygems.org/gems/rdf"), RDF::DC.creator.dup, RDF::Literal("literal")) =>
        RDF::Statement.new(RDF::URI("http://rubygems.org/gems/rdf"), RDF::DC.creator.dup, RDF::Literal("literal")),
      RDF::Statement.new(RDF::URI('file:///path/to/file with spaces.txt'), RDF::DC.creator.dup, RDF::URI("http://ar.to/#self")) =>
        RDF::Statement.new(RDF::URI('file:///path/to/file%20with%20spaces.txt'), RDF::DC.creator.dup, RDF::URI("http://ar.to/#self")),
      RDF::Statement.new(nil, RDF::DC.creator.dup, RDF::URI("http://ar.to/#self")) => nil,
      RDF::Statement.new(RDF::URI("http://rubygems.org/gems/rdf"), nil, RDF::URI("http://ar.to/#self")) => nil,
      RDF::Statement.new(RDF::URI("http://rubygems.org/gems/rdf"), RDF::DC.creator.dup, nil) => nil,
      RDF::Statement.new(RDF::Literal("literal"), RDF::DC.creator.dup, RDF::URI("http://ar.to/#self")) => nil,
      RDF::Statement.new(RDF::URI("http://rubygems.org/gems/rdf"), RDF::Literal("literal"), RDF::URI("http://ar.to/#self")) => nil,
    }.each do |st, result|
      include_examples "c14n", st, result
    end
  end
end

describe RDF::NTriples do
  let(:testfile) {fixture_path('test.nt')}

  before :each do
    @reader = RDF::NTriples::Reader
    @writer = RDF::NTriples::Writer
  end

  context "when created" do
    it "should accept files" do
      expect { @reader.new(File.open(testfile)) }.not_to raise_error
    end

    it "should accept IO streams" do
      expect { @reader.new(StringIO.new('')) }.not_to raise_error
    end

    it "should accept strings" do
      expect { @reader.new('') }.not_to raise_error
    end
  end

  context "when decoding text" do
    # @see http://www.w3.org/TR/rdf-testcases/#ntrip_strings
    it "should correctly unescape ASCII characters (#x0-#x7F)" do
      (0x00..0x7F).each do |u|
        expect(@reader.unescape(@writer.escape(u.chr))).to eq u.chr
      end
    end

    # @see http://www.w3.org/TR/rdf-testcases/#ntrip_strings
    it "should correctly unescape Unicode characters (#x80-#x10FFFF)", :ruby => 1.9 do
      (0x7F..0xFFFF).to_a.sample(100).each do |u|
        begin
          next unless (c = u.chr(::Encoding::UTF_8)).valid_encoding?
          expect(@reader.unescape(@writer.escape(c))).to eq c
        rescue RangeError
        end
      end
      (0x10000..0x2FFFF).to_a.sample(100).each do |u| # NB: there's nothing much beyond U+2FFFF
        begin
          next unless (c = u.chr(::Encoding::UTF_8)).valid_encoding?
          expect(@reader.unescape(@writer.escape(c))).to eq c
        rescue RangeError
        end
      end
    end

    context "unescape Unicode strings", :ruby => 1.9 do
      strings = {
        "\u677E\u672C \u540E\u5B50" => "松本 后子",
        "D\u00FCrst"                => "Dürst",
        "\\U00015678another"         => "\u{15678}another",
      }
      strings.each do |string, unescaped|
        specify string do
          unescaped = unescaped.dup.encode!(Encoding::UTF_8) if unescaped.respond_to?(:encode!)
          expect(@reader.unescape(string.dup)).to eq unescaped
        end
      end
    end

    context "unescape escaped Unicode strings" do
      strings = {
        "_\\u221E_"                 => "_\xE2\x88\x9E_", # U+221E, infinity symbol
        "_\\u6C34_"                 => "_\xE6\xB0\xB4_", # U+6C34, 'water' in Chinese
        "\\u677E\\u672C \\u540E\\u5B50" => "松本 后子",
        "D\\u00FCrst"                => "Dürst",
      }
      strings.each do |string, unescaped|
        specify string do
          unescaped = unescaped.dup.encode!(Encoding::UTF_8) if unescaped.respond_to?(:encode!)
          expect(@reader.unescape(string.dup)).to eq unescaped
        end
      end
    end
  end

  context "when encoding text to ASCII" do
    let(:encoding) { "".respond_to?(:encoding) ? ::Encoding::ASCII : nil}

    # @see http://www.w3.org/TR/rdf-testcases/#ntrip_strings
    it "should correctly escape ASCII characters (#x0-#x7F)" do
      (0x00..0x08).each { |u| expect(@writer.escape(u.chr, encoding)).to eq "\\u#{u.to_s(16).upcase.rjust(4, '0')}" }
      expect(@writer.escape(0x09.chr, encoding)).to eq "\\t"
      expect(@writer.escape(0x0A.chr, encoding)).to eq "\\n"
      (0x0B..0x0C).each { |u| expect(@writer.escape(u.chr, encoding)).to eq "\\u#{u.to_s(16).upcase.rjust(4, '0')}" }
      expect(@writer.escape(0x0D.chr, encoding)).to eq "\\r"
      (0x0E..0x1F).each { |u| expect(@writer.escape(u.chr, encoding)).to eq "\\u#{u.to_s(16).upcase.rjust(4, '0')}" }
      (0x20..0x21).each { |u| expect(@writer.escape(u.chr, encoding)).to eq u.chr }
      expect(@writer.escape(0x22.chr, encoding)).to eq "\\\""
      (0x23..0x5B).each { |u| expect(@writer.escape(u.chr, encoding)).to eq u.chr }
      expect(@writer.escape(0x5C.chr, encoding)).to eq "\\\\"
      (0x5D..0x7E).each { |u| expect(@writer.escape(u.chr, encoding)).to eq u.chr }
      expect(@writer.escape(0x7F.chr, encoding)).to eq "\\u007F"
    end

    # @see http://www.w3.org/TR/rdf-testcases/#ntrip_strings
    # @see http://en.wikipedia.org/wiki/Mapping_of_Unicode_characters#Planes
    it "should correctly escape Unicode characters (#x80-#x10FFFF)", :ruby => 1.9 do
      (0x80..0xFFFF).to_a.sample(100).each do |u|
        begin
          next unless (c = u.chr(::Encoding::UTF_8)).valid_encoding?
          expect(@writer.escape(c, encoding)).to eq "\\u#{u.to_s(16).upcase.rjust(4, '0')}"
        rescue RangeError
        end
      end
      (0x10000..0x2FFFF).to_a.sample(100).each do |u| # NB: there's nothing much beyond U+2FFFF
        begin
          next unless (c = u.chr(::Encoding::UTF_8)).valid_encoding?
          expect(@writer.escape(c, encoding)).to eq "\\U#{u.to_s(16).upcase.rjust(8, '0')}"
        rescue RangeError
        end
      end
    end

    it "should correctly escape Unicode strings" do
      strings = {
        "_\xE2\x88\x9E_" => "_\\u221E_", # U+221E, infinity symbol
        "_\xE6\xB0\xB4_" => "_\\u6C34_", # U+6C34, 'water' in Chinese
      }
      strings.each do |string, escaped|
        string = string.dup.encode!(Encoding::UTF_8) if string.respond_to?(:encode!)
        expect(@writer.escape(string)).to eq escaped
      end
    end

    # @see http://github.com/bendiken/rdf/issues/#issue/7
    it "should correctly handle RDF.rb issue #7" do
      input  = %Q(<http://openlibrary.org/b/OL3M> <http://RDVocab.info/Elements/titleProper> "Jh\xC5\xABl\xC4\x81." .)
      output = %Q(<http://openlibrary.org/b/OL3M> <http://RDVocab.info/Elements/titleProper> "Jh\\u016Bl\\u0101." .)
      writer = RDF::NTriples::Writer.new(StringIO.new, :encoding => :ascii)
      expect(writer.format_statement(RDF::NTriples.unserialize(input))).to eq output
    end
  end

  context "when encoding text to UTF-8" do
    let(:encoding) { "".respond_to?(:encoding) ? ::Encoding::UTF_8 : nil}

    # @see http://www.w3.org/TR/rdf-testcases/#ntrip_strings
    it "should correctly escape ASCII characters (#x0-#x7F)" do
      (0x00..0x07).each { |u| expect(@writer.escape(u.chr, encoding)).to eq "\\u#{u.to_s(16).upcase.rjust(4, '0')}" }
      expect(@writer.escape(0x08.chr, encoding)).to eq (encoding ? "\\b" : "\\u0008")
      expect(@writer.escape(0x09.chr, encoding)).to eq "\\t"
      expect(@writer.escape(0x0A.chr, encoding)).to eq "\\n"
      (0x0B..0x0B).each { |u| expect(@writer.escape(u.chr, encoding)).to eq "\\u#{u.to_s(16).upcase.rjust(4, '0')}" }
      expect(@writer.escape(0x0C.chr, encoding)).to eq (encoding ? "\\f" : "\\u000C")
      expect(@writer.escape(0x0D.chr, encoding)).to eq "\\r"
      (0x0E..0x1F).each { |u| expect(@writer.escape(u.chr, encoding)).to eq "\\u#{u.to_s(16).upcase.rjust(4, '0')}" }
      (0x20..0x21).each { |u| expect(@writer.escape(u.chr, encoding)).to eq u.chr }
      expect(@writer.escape(0x22.chr, encoding)).to eq "\\\""
      (0x23..0x5B).each { |u| expect(@writer.escape(u.chr, encoding)).to eq u.chr }
      expect(@writer.escape(0x5C.chr, encoding)).to eq "\\\\"
      (0x5D..0x7E).each { |u| expect(@writer.escape(u.chr, encoding)).to eq u.chr }
      expect(@writer.escape(0x7F.chr, encoding)).to eq "\\u007F"
    end

    # @see http://www.w3.org/TR/rdf-testcases/#ntrip_strings
    # @see http://en.wikipedia.org/wiki/Mapping_of_Unicode_characters#Planes
    it "should not escape Unicode characters (#x80-#x10FFFF)", :ruby => 1.9 do
      (0x80..0xFFFF).to_a.sample(100).each do |u|
        begin
          next unless (c = u.chr(::Encoding::UTF_8)).valid_encoding?
          expect(@writer.escape(c, encoding)).to eq c
        rescue RangeError
        end
      end
      (0x10000..0x2FFFF).to_a.sample(100).each do |u| # NB: there's nothing much beyond U+2FFFF
        begin
          next unless (c = u.chr(::Encoding::UTF_8)).valid_encoding?
          expect(@writer.escape(c, encoding)).to eq c
        rescue RangeError
        end
      end
    end

    it "should not escape Unicode strings", :ruby => 1.9 do
      strings = [
        "_\u221E_", # U+221E, infinity symbol
        "_\u6C34_", # U+6C34, 'water' in Chinese
      ]
      strings.each do |string|
        string = string.dup.encode!(Encoding::UTF_8) if string.respond_to?(:encode!)
        expect(@writer.escape(string, encoding)).to eq string
      end
    end
  end

  context "when reading" do
    it "should parse empty lines" do
      ["\n", "\r\n", "\r"].each do |input|
        expect { expect(@reader.new(input).to_a).to be_empty }.not_to raise_error
      end
    end

    it "should parse comment lines" do
      ["#\n", "# \n"].each do |input|
        expect { expect(@reader.new(input).to_a).to be_empty }.not_to raise_error
      end
    end

    it "should parse comment lines preceded by whitespace" do
      ["\t#\n", " #\n"].each do |input|
        expect { expect(@reader.new(input).to_a).to be_empty }.not_to raise_error
      end
    end

    it "should parse W3C's test data" do
      expect(@reader.new(File.open(testfile)).to_a.size).to eq 30
    end

    it "should parse terms" do
      bnode = @reader.unserialize('_:foobar')
      expect(bnode).not_to be_nil
      expect(bnode).to be_a_node
      expect(bnode.id).to eq 'foobar'

      uri = @reader.unserialize('<http://ar.to/#self>')
      expect(uri).not_to be_nil
      expect(uri).to be_a_uri
      expect(uri.to_s).to eq 'http://ar.to/#self'

      hello = @reader.unserialize('"Hello"')
      expect(hello).not_to be_nil
      expect(hello).to be_a_literal
      expect(hello.value).to eq 'Hello'

      stmt = @reader.unserialize("<http://rubygems.org/gems/rdf> <http://purl.org/dc/terms/creator> <http://ar.to/#self> .")
      expect(stmt).not_to be_nil
      expect(stmt).to be_a_statement
    end

    describe "with nodes" do
      it "should read two named nodes as the same node" do
        stmt = @reader.unserialize("_:a <http://www.w3.org/2002/07/owl#sameAs> _:a .")
        expect(stmt.subject).to eq stmt.object
        expect(stmt.subject).to be_eql(stmt.object)
      end
      
      it "should read two named nodes in different instances as different nodes" do
        stmt1 = @reader.unserialize("_:a <http://www.w3.org/2002/07/owl#sameAs> _:a .")
        stmt2 = @reader.unserialize("_:a <http://www.w3.org/2002/07/owl#sameAs> _:a .")
        expect(stmt1.subject).to eq stmt2.subject
        expect(stmt1.subject).not_to be_eql(stmt2.subject)
      end
    end
    
    describe "with literal encodings" do
      {
        'Dürst'          => '_:a <http://pred> "D\u00FCrst" .',
        'simple literal' => '<http://subj> <http://pred>  "simple literal" .',
        'backslash:\\'   => '<http://subj> <http://pred> "backslash:\\\\" .',
        'dquote:"'       => '<http://subj> <http://pred> "dquote:\"" .',
        "newline:\n"     => '<http://subj> <http://pred> "newline:\n" .',
        "return\r"       => '<http://subj> <http://pred> "return\r" .',
        "tab:\t"         => '<http://subj> <http://pred> "tab:\t" .',
        "form feed:\f"   => '<http://subj> <http://pred> "form feed:\u000C" .',
        "backspace:\b"   => '<http://subj> <http://pred> "backspace:\u0008" .',
        "é"              => '<http://subj> <http://pred> "\u00E9" .',
        "€"              => '<http://subj> <http://pred> "\u20AC" .',
      }.each_pair do |contents, triple|
        specify "test #{contents}" do
          stmt = @reader.unserialize(triple)
          expect(stmt.object.value).to eq contents
        end
      end

      it 'should parse a value that was written without passing through the writer encoding' do
        nt = "<http://subj> <http://pred> \"Procreation Metaphors in S\xC3\xA9an \xC3\x93 R\xC3\xADord\xC3\xA1in's Poetry\" .".force_encoding("ASCII-8BIT")
        if defined?(::Encoding)
          statement = @reader.unserialize(nt)
          expect(statement.object.value).to eq("Procreation Metaphors in Séan Ó Ríordáin's Poetry")
        else
          pending("Not supported on Ruby 1.8")
        end
      end

      it "should parse long literal with escape" do
        nt = %(<http://subj> <http://pred> "\\U00015678another" .)
        if defined?(::Encoding)
          statement = @reader.unserialize(nt)
          expect(statement.object.value).to eq "\u{15678}another"
        else
          pending("Not supported on Ruby 1.8")
        end
      end

      {
        "three uris"  => "<http://example.org/resource1> <http://example.org/property> <http://example.org/resource2> .",
        "spaces and tabs throughout" => " 	 <http://example.org/resource3> 	 <http://example.org/property>	 <http://example.org/resource2> 	.	 ",
        "line ending with CR NL" => "<http://example.org/resource4> <http://example.org/property> <http://example.org/resource2> .\r\n",
        "literal escapes (1)" => '<http://example.org/resource7> <http://example.org/property> "simple literal" .',
        "literal escapes (2)" => '<http://example.org/resource8> <http://example.org/property> "backslash:\\\\" .',
        "literal escapes (3)" => '<http://example.org/resource9> <http://example.org/property> "dquote:\"" .',
        "literal escapes (4)" => '<http://example.org/resource10> <http://example.org/property> "newline:\n" .',
        "literal escapes (5)" => '<http://example.org/resource11> <http://example.org/property> "return:\r" .',
        "literal escapes (6)" => '<http://example.org/resource12> <http://example.org/property> "tab:\t" .',
        "Space is optional before final . (2)" => ['<http://example.org/resource14> <http://example.org/property> "x".', '<http://example.org/resource14> <http://example.org/property> "x" .'],

        "XML Literals as Datatyped Literals (1)" => '<http://example.org/resource21> <http://example.org/property> ""^^<http://www.w3.org/2000/01/rdf-schema#XMLLiteral> .',
        "XML Literals as Datatyped Literals (2)" => '<http://example.org/resource22> <http://example.org/property> " "^^<http://www.w3.org/2000/01/rdf-schema#XMLLiteral> .',
        "XML Literals as Datatyped Literals (3)" => '<http://example.org/resource23> <http://example.org/property> "x"^^<http://www.w3.org/2000/01/rdf-schema#XMLLiteral> .',
        "XML Literals as Datatyped Literals (4)" => '<http://example.org/resource23> <http://example.org/property> "\""^^<http://www.w3.org/2000/01/rdf-schema#XMLLiteral> .',
        "XML Literals as Datatyped Literals (5)" => '<http://example.org/resource24> <http://example.org/property> "<a></a>"^^<http://www.w3.org/2000/01/rdf-schema#XMLLiteral> .',
        "XML Literals as Datatyped Literals (6)" => '<http://example.org/resource25> <http://example.org/property> "a <b></b>"^^<http://www.w3.org/2000/01/rdf-schema#XMLLiteral> .',
        "XML Literals as Datatyped Literals (7)" => '<http://example.org/resource26> <http://example.org/property> "a <b></b> c"^^<http://www.w3.org/2000/01/rdf-schema#XMLLiteral> .',
        "XML Literals as Datatyped Literals (8)" => '<http://example.org/resource26> <http://example.org/property> "a\n<b></b>\nc"^^<http://www.w3.org/2000/01/rdf-schema#XMLLiteral> .',
        "XML Literals as Datatyped Literals (9)" => '<http://example.org/resource27> <http://example.org/property> "chat"^^<http://www.w3.org/2000/01/rdf-schema#XMLLiteral> .',

        "Plain literals with languages (1)" => '<http://example.org/resource30> <http://example.org/property> "chat"@fr .',
        "Plain literals with languages (2)" => '<http://example.org/resource31> <http://example.org/property> "chat"@en .',

        "Typed Literals" => '<http://example.org/resource32> <http://example.org/property> "abc"^^<http://example.org/datatype1> .',
      }.each_pair do |name, nt|
        specify "test #{name}" do
          statement = @reader.unserialize(Array(nt).first)
          expect(@writer.serialize(statement).chomp).to eq Array(nt).last.gsub(/\s+/, " ").strip
        end
      end
    end

    describe "with URI i18n URIs" do
      {
        %(<http://a/b#Dürst> <http://www.w3.org/1999/02/22-rdf-syntax-ns#type> "URI straight in UTF8".) => %(<http://a/b#D\\u00FCrst> <http://www.w3.org/1999/02/22-rdf-syntax-ns#type> "URI straight in UTF8" .),
        %(<http://a/b#a> <http://a/b#related> <http://a/b#\u3072\u3089\u304C\u306A>.) => %(<http://a/b#a> <http://a/b#related> <http://a/b#\\u3072\\u3089\\u304C\\u306A> .),
      }.each_pair do |src, res|
        specify src do
          begin
            stmt1 = @reader.unserialize(src)
            stmt2 = @reader.unserialize(res)
            expect(stmt1).to eq stmt2
          rescue
            if defined?(::Encoding)
              raise
            else
              pending("Unicode URIs not supported on Ruby 1.8") { raise }
            end
          end
        end
      end
    end

    context "with invalid input" do
      {
        "nt-syntax-bad-struct-01" => %q(<http://example/s> <http://example/p> <http://example/o>, <http://example/o2> .),
        "nt-syntax-bad-struct-02" => %q(<http://example/s> <http://example/p> <http://example/o>; <http://example/p2>, <http://example/o2> .),
        "nt-syntax-bad-lang-01" => %q(<http://example/s> <http://example/p> "string"@1 .),
        "nt-syntax-bad-string-05" => %q(<http://example/s> <http://example/p> """abc""" .),
        "nt-syntax-bad-num-01" => %q(<http://example/s> <http://example/p> 1 .),
        "nt-syntax-bad-num-02" => %q(<http://example/s> <http://example/p> 1.0 .),
        "nt-syntax-bad-num-03" => %q(<http://example/s> <http://example/p> 1.0e0 .),
      }.each do |name, nt|
        it name do
          expect {@reader.new(nt, :validate => true).to_a}.to raise_error(RDF::ReaderError)
        end
      end
    end
  end

  context "when writing" do
    let!(:stmt) {
      s = RDF::URI("http://rubygems.org/gems/rdf")
      p = RDF::DC.creator
      o = RDF::URI("http://ar.to/#self")
      RDF::Statement.new(s, p, o)
    }
    let!(:stmt_string) {
      "<http://rubygems.org/gems/rdf> <http://purl.org/dc/terms/creator> <http://ar.to/#self> ."
    }
    let!(:graph) {
      RDF::Graph.new << stmt
    }

    it "should correctly format statements" do
      expect(@writer.new.format_statement(stmt)).to eq stmt_string
    end

    context "should correctly format blank nodes" do
      specify {expect(@writer.new.format_node(RDF::Node.new('foobar'))).to eq '_:foobar'}
      specify {expect(@writer.new.format_node(RDF::Node.new(''))).not_to eq '_:'}
    end

    it "should correctly format URI references" do
      expect(@writer.new.format_uri(RDF::URI('http://rdf.rubyforge.org/'))).to eq '<http://rdf.rubyforge.org/>'
    end

    it "should correctly format plain literals" do
      expect(@writer.new.format_literal(RDF::Literal.new('Hello, world!'))).to eq '"Hello, world!"'
    end

    it "should correctly format language-tagged literals" do
      expect(@writer.new.format_literal(RDF::Literal.new('Hello, world!', :language => :en))).to eq '"Hello, world!"@en'
    end

    it "should correctly format datatyped literals" do
      expect(@writer.new.format_literal(RDF::Literal.new(3.1415))).to eq '"3.1415"^^<http://www.w3.org/2001/XMLSchema#double>'
    end

    it "should correctly format language-tagged literals with rdf:langString" do
      l = RDF::Literal.new('Hello, world!', :language => :en, :datatype => RDF.langString)
      expect(@writer.new.format_literal(l)).to eq '"Hello, world!"@en'
    end

    it "should output statements to a string buffer" do
      output = @writer.buffer { |writer| writer << stmt }
      expect(output).to eq "#{stmt_string}\n"
    end

    it "should dump statements to a string buffer" do
      output = StringIO.new
      @writer.dump(graph, output)
      expect(output.string).to eq "#{stmt_string}\n"
    end

    it "should dump arrays of statements to a string buffer" do
      output = StringIO.new
      @writer.dump(graph.to_a, output)
      expect(output.string).to eq "#{stmt_string}\n"
    end

    it "should dump statements to a file" do
      require 'tmpdir' # for Dir.tmpdir
      @writer.dump(graph, filename = File.join(Dir.tmpdir, "test.nt"))
      expect(File.read(filename)).to eq "#{stmt_string}\n"
      File.unlink(filename)
    end

    context ":encoding", :ruby => "1.9" do
      %w(US-ASCII UTF-8).each do |encoding_name|
        context encoding_name do
          let(:encoding) { ::Encoding.find(encoding_name)}
          it "dumps to String" do
            s = @writer.dump(graph, nil, :encoding => encoding)
            expect(s).to be_a(String)
            expect(s.encoding).to eq encoding
          end

          it "dumps to file" do
            output = StringIO.new
            s = @writer.dump(graph, output, :encoding => encoding)
            expect(output.external_encoding).to eq encoding
          end

          it "takes encoding from file external_encoding" do
            output = StringIO.new
            output.set_encoding encoding
            s = @writer.dump(graph, output)
            expect(output.external_encoding).to eq encoding
          end
        end
      end
    end
  end

  context "Examples" do
    it "needs specs for documentation examples"
  end
end
