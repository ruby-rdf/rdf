# -*- encoding: utf-8 -*-
require_relative 'spec_helper'
require 'rdf/ntriples'
require 'rdf/spec/format'
require 'rdf/spec/reader'
require 'rdf/spec/writer'
require 'rdf/turtle'

describe RDF::NTriples::Format do

  # @see lib/rdf/spec/format.rb in rdf-spec
  it_behaves_like 'an RDF::Format' do
    let(:format_class) { described_class }
  end

  # @see lib/rdf/spec/format.rb in rdf-spec
  it_behaves_like 'an RDF::Format' do
    let(:format_class) { described_class }
  end

  subject { described_class }

  describe ".for" do
    [
      :ntriples,
      'etc/doap.nt',
      {file_name:      'etc/doap.nt'},
      {file_extension: 'nt'},
      {content_type:   'application/n-triples'},
     ].each do |arg|
      it "discovers with #{arg.inspect}" do
        expect(RDF::Format.for(arg)).to eq subject
      end
    end

    {
      ntriples: "<a> <b> <c> .",
      literal: '<a> <b> "literal" .',
      bnode: %(<a> <b> _:c .),
    }.each do |sym, str|
      it "detects #{sym}" do
        expect(subject.detect(str)).to be_truthy
      end
    end
  end

  describe ".detect" do
    {
      ntriples: "<a> <b> <c> .",
      literal: '<a> <b> "literal" .',
      multi_line: %(<a>\n  <b>\n  "literal"\n .),
    }.each do |sym, str|
      it "detects #{sym}" do
        expect(subject.detect(str)).to be_truthy
      end
    end

    {
      nquads:        "<a> <b> <c> <d> . ",
      nq_literal:    '<a> <b> "literal" <d> .',
      nq_multi_line: %(<a>\n  <b>\n  "literal"\n <d>\n .),
      turtle:        "@prefix foo: <bar> .\n foo:a foo:b <c> .",
      trig:          "{<a> <b> <c> .}",
      rdfxml:        '<rdf:RDF about="foo"></rdf:RDF>',
      n3:            '@prefix foo: <bar> .\nfoo:bar = {<a> <b> <c>} .',
    }.each do |sym, str|
      it "does not detect #{sym}" do
        expect(subject.detect(str)).to be_falsey
      end
    end
  end

  describe "#to_sym" do
    specify {expect(subject.to_sym).to eq :ntriples}
  end

  describe "#name" do
    specify {expect(subject.name).to eq "N-Triples"}
  end
end

describe RDF::NTriples::Reader do
  let(:logger) {RDF::Spec.logger}
  let(:testfile) {fixture_path('test.nt')}
  let(:reader) {RDF::NTriples::Reader}
  let(:writer) {RDF::NTriples::Writer}
  let!(:doap) {File.expand_path("../../etc/doap.nt", __FILE__)}
  let!(:doap_count) {File.open(doap).each_line.to_a.length}
  subject { RDF::NTriples::Reader.new }

  # @see lib/rdf/spec/reader.rb in rdf-spec
  it_behaves_like 'an RDF::Reader' do
    let(:reader) { RDF::NTriples::Reader.new }
    let(:reader_input) { File.read(doap) }
    let(:reader_count) { doap_count }
  end

  describe ".for" do
    [
      :ntriples,
      'etc/doap.nt',
      {file_name:      'etc/doap.nt'},
      {file_extension: 'nt'},
      {content_type:   'application/n-triples'},
    ].each do |arg|
      it "discovers with #{arg.inspect}" do
        expect(RDF::Reader.for(arg)).to eq described_class
      end
    end

    context "content_type text/plain" do
      {
        :ntriples      => "<a> <b> <c> . ",
        :nquads        => "<a> <b> <c> <d> . ",
        :nq_literal    => '<a> <b> "literal" <d> .',
        :nq_multi_line => %(<a>\n  <b>\n  "literal"\n <d>\n .),
      }.each do |sym, str|
        it "does not detect #{sym}" do
          f = RDF::Reader.for(:content_type => "text/plain", :sample => str.freeze)
          expect(f).not_to eq described_class
        end
      end
    end
  end

  it "should return :ntriples for to_sym" do
    expect(subject.class.to_sym).to eq :ntriples
    expect(subject.to_sym).to eq :ntriples
  end

  describe ".initialize" do
    it "reads doap string" do
      g = RDF::Graph.new << described_class.new(File.read(doap))
      expect(g.count).to eq doap_count
    end
    it "reads doap IO" do
      g = RDF::Graph.new
      described_class.new(File.open(doap)) do |r|
        g << r
      end
      expect(g.count).to eq doap_count
    end

    it "should accept files" do
      expect { described_class.new(File.open(testfile)) }.not_to raise_error
    end

    it "should accept IO streams" do
      expect { described_class.new(StringIO.new('')) }.not_to raise_error
    end

    it "should accept strings" do
      expect { described_class.new('') }.not_to raise_error
    end

    it "sets version from reader option" do
      expect(described_class.new('', version: '1.2').version).to eql '1.2'
    end
  end

  describe ".open" do
    it "reads doap string" do
      g = RDF::Graph.new
      described_class.open(doap) do |r|
        g << r
      end
      expect(g.count).to eq doap_count
    end
  end

  describe ".unserialize" do
    it "parses a bnode" do
      bnode = reader.unserialize('_:foobar')
      expect(bnode).not_to be_nil
      expect(bnode).to be_a_node
      expect(bnode.id).to eq 'foobar'
    end

    it "parses an IRI" do
      uri = reader.unserialize('<http://ar.to/#self>'.freeze)
      expect(uri).not_to be_nil
      expect(uri).to be_a_uri
      expect(uri.to_s).to eq 'http://ar.to/#self'
    end

    it "parses a plain literal" do
      hello = reader.unserialize('"Hello"')
      expect(hello).not_to be_nil
      expect(hello).to be_a_literal
      expect(hello.value).to eq 'Hello'
    end

    it "parses a triple" do
      stmt = reader.unserialize("<https://rubygems.org/gems/rdf> <http://purl.org/dc/terms/creator> <http://ar.to/#self> .".freeze)
      expect(stmt).not_to be_nil
      expect(stmt).to be_a_statement
    end
  end

  describe ".parse_subject" do
    it "parses an IRI" do
      iri = reader.parse_subject("<https://rubygems.org/gems/rdf>")
      expect(iri).not_to be_nil
      expect(iri).to be_a_uri
      expect(iri.to_s).to eq 'https://rubygems.org/gems/rdf'
    end

    it "parses an BNode" do
      bn = reader.parse_subject("_:blank")
      expect(bn).not_to be_nil
      expect(bn).to be_a_node
      expect(bn.id).to eq 'blank'
    end

    it "does not parse a literal" do
      lit = reader.parse_subject("hello")
      expect(lit).to be_nil
    end

    it "does not parse a triple term" do
      tt = reader.parse_subject("<<(<https://rubygems.org/gems/rdf> <http://purl.org/dc/terms/creator> <http://ar.to/#self>)>>")
      expect(tt).to be_nil
    end
  end

  describe ".parse_predicate" do
    it "parses an IRI" do
      iri = reader.parse_predicate("<https://rubygems.org/gems/rdf>")
      expect(iri).not_to be_nil
      expect(iri).to be_a_uri
      expect(iri.to_s).to eq 'https://rubygems.org/gems/rdf'
    end

    it "does not parse an BNode" do
      bn = reader.parse_predicate("_:blank")
      expect(bn).to be_nil
    end

    it "does not parse a literal" do
      lit = reader.parse_predicate("hello")
      expect(lit).to be_nil
    end

    it "does not parse a triple term" do
      tt = reader.parse_predicate("<<(<https://rubygems.org/gems/rdf> <http://purl.org/dc/terms/creator> <http://ar.to/#self>)>>")
      expect(tt).to be_nil
    end
  end

  describe ".parse_object" do
    it "parses an IRI" do
      iri = reader.parse_object("<https://rubygems.org/gems/rdf>")
      expect(iri).not_to be_nil
      expect(iri).to be_a_uri
      expect(iri.to_s).to eq 'https://rubygems.org/gems/rdf'
    end

    it "parses an BNode" do
      bn = reader.parse_object("_:blank")
      expect(bn).not_to be_nil
      expect(bn).to be_a_node
      expect(bn.id).to eq 'blank'
    end

    it "parses a literal" do
      lit = reader.parse_object(%("hello"))
      expect(lit).not_to be_nil
      expect(lit).to be_a_literal
      expect(lit.to_s).to eq "hello"
    end

    it "does not parse a parse_object term" do
      tt = reader.parse_predicate("<<(<https://rubygems.org/gems/rdf> <http://purl.org/dc/terms/creator> <http://ar.to/#self>)>>")
      expect(tt).to be_nil
    end
  end

  describe ".parse_object" do
    it "parses an IRI" do
      iri = reader.parse_object("<https://rubygems.org/gems/rdf>")
      expect(iri).not_to be_nil
      expect(iri).to be_a_uri
      expect(iri.to_s).to eq 'https://rubygems.org/gems/rdf'
    end

    it "parses an BNode" do
      bn = reader.parse_object("_:blank")
      expect(bn).not_to be_nil
      expect(bn).to be_a_node
      expect(bn.id).to eq 'blank'
    end

    it "parses a literal" do
      lit = reader.parse_object(%("hello"))
      expect(lit).not_to be_nil
      expect(lit).to be_a_literal
      expect(lit.to_s).to eq "hello"
    end

    it "does not parse a parse_object term" do
      tt = reader.parse_predicate("<<(<https://rubygems.org/gems/rdf> <http://purl.org/dc/terms/creator> <http://ar.to/#self>)>>")
      expect(tt).to be_nil
    end
  end

  describe ".parse_node" do
    it "does not parse an IRI" do
      iri = reader.parse_node("<https://rubygems.org/gems/rdf>")
      expect(iri).to be_nil
    end

    it "parses an BNode" do
      bn = reader.parse_node("_:blank")
      expect(bn).not_to be_nil
      expect(bn).to be_a_node
      expect(bn.id).to eq 'blank'
    end

    it "does not parse a literal" do
      lit = reader.parse_node(%("hello"))
      expect(lit).to be_nil
    end

    it "does not parse a parse_object term" do
      tt = reader.parse_node("<<(<https://rubygems.org/gems/rdf> <http://purl.org/dc/terms/creator> <http://ar.to/#self>)>>")
      expect(tt).to be_nil
    end
  end

  describe ".parse_uri" do
    it "does not parse an IRI" do
      iri = reader.parse_uri("<https://rubygems.org/gems/rdf>")
      expect(iri).not_to be_nil
      expect(iri).to be_a_uri
      expect(iri.to_s).to eq 'https://rubygems.org/gems/rdf'
    end

    it "parses an BNode" do
      bn = reader.parse_uri("_:blank")
      expect(bn).to be_nil
    end

    it "does not parse a literal" do
      lit = reader.parse_uri(%("hello"))
      expect(lit).to be_nil
    end

    it "does not parse a parse_object term" do
      tt = reader.parse_uri("<<(<https://rubygems.org/gems/rdf> <http://purl.org/dc/terms/creator> <http://ar.to/#self>)>>")
      expect(tt).to be_nil
    end
  end

  describe ".parse_literal" do
    it "does not parse an IRI" do
      iri = reader.parse_literal("<https://rubygems.org/gems/rdf>")
      expect(iri).to be_nil
    end

    it "parses an BNode" do
      bn = reader.parse_literal("_:blank")
      expect(bn).to be_nil
    end

    it "does not parse a literal" do
      lit = reader.parse_literal(%("hello"))
      expect(lit).not_to be_nil
      expect(lit).to be_a_literal
      expect(lit.to_s).to eq "hello"
    end

    it "does not parse a parse_object term" do
      tt = reader.parse_literal("<<(<https://rubygems.org/gems/rdf> <http://purl.org/dc/terms/creator> <http://ar.to/#self>)>>")
      expect(tt).to be_nil
    end

    describe "literal encodings" do
      {
        'Dürst'          => '"D\u00FCrst" .',
        'simple literal' => '"simple literal" .',
        'backslash:\\'   => '"backslash:\\\\" .',
        'squote:\''      => '"squote:\'" .',
        'dquote:"'       => '"dquote:\"" .',
        "newline:\n"     => '"newline:\n" .',
        "return\r"       => '"return\r" .',
        "tab:\t"         => '"tab:\t" .',
        "form feed:\f"   => '"form feed:\u000C" .',
        "backspace:\b"   => '"backspace:\u0008" .',
        "é"              => '"\u00E9" .',
        "€"              => '"\u20AC" .',
      }.each_pair do |contents, literal|
        specify "test #{contents}" do
          lit = reader.parse_literal(literal)
          expect(lit).not_to be_nil
          expect(lit.value).to eq contents
        end
      end

      context "base direction" do
        {
          "language" => '"Hello"@en .',
          "direction" => '"Hello"@en--ltr .',
          "direction2" => '"Hello"@en--rtl .',
        }.each_pair do |name, literal|
          specify "test #{name}" do
            lit = reader.parse_literal(literal)
            expect(lit).not_to be_nil
            expect(lit.value).to eq "Hello"

            if name.include?('dir')
              expect(lit.datatype).to eql RDF.dirLangString
              expect(lit.direction).not_to be_nil
            else
              expect(lit.datatype).to eql RDF.langString
              expect(lit.direction).to be_nil
            end
          end
        end
      end
    end
  end

  describe "Grammar" do
    context "when decoding text" do
      # @see http://www.w3.org/TR/rdf-testcases/#ntrip_strings
      it "should correctly unescape ASCII characters (#x0-#x7F)" do
        (0x00..0x7F).each do |u|
          expect(reader.unescape(writer.escape(u.chr))).to eq u.chr
        end
      end

      # @see http://www.w3.org/TR/rdf-testcases/#ntrip_strings
      it "should correctly unescape Unicode characters (#x80-#x10FFFF)" do
        (0x7F..0xFFFF).to_a.sample(100).each do |u|
          begin
            next unless (c = u.chr(::Encoding::UTF_8)).valid_encoding?
            expect(reader.unescape(writer.escape(c))).to eq c
          rescue RangeError
          end
        end
        (0x10000..0x2FFFF).to_a.sample(100).each do |u| # NB: there's nothing much beyond U+2FFFF
          begin
            next unless (c = u.chr(::Encoding::UTF_8)).valid_encoding?
            expect(reader.unescape(writer.escape(c))).to eq c
          rescue RangeError
          end
        end
      end

      context "unescape Unicode strings" do
        strings = {
          "\u677E\u672C \u540E\u5B50" => "松本 后子",
          "D\u00FCrst"                => "Dürst",
          "\\U00015678another"        => "\u{15678}another",
        }
        strings.each do |string, unescaped|
          specify string do
            unescaped = unescaped.encode(Encoding::UTF_8)
            expect(reader.unescape(string)).to eq unescaped
          end
        end
      end

      context "unescape escaped Unicode strings" do
        strings = {
          # U+221E, infinity symbol
          "_\\u221E_"                    => "_\xE2\x88\x9E_",
          # U+6C34, 'water' in Chinese
          "_\\u6C34_"                    => "_\xE6\xB0\xB4_",
          "\\u677E\\u672C \\u540E\\u5B50"=> "松本 后子",
          "D\\u00FCrst"                  => "Dürst",
          "\\u0039"                      => "9",
          "\\\\u0039"                    => "\\u0039",
        }
        strings.each do |string, unescaped|
          specify string do
            unescaped = unescaped.encode(Encoding::UTF_8)
            expect(reader.unescape(string.freeze)).to eq unescaped
          end
        end
      end
    end

    context "comments" do
      {
        %(\n) => %(),
        %(\r\n) => %(),
        %(\r) => %q(),
        %(#\n) => %q(),
        %(# \n) => %q(),
        %(# <http://example/a> <http://example/b> <http://example/c> .\n) => %q(),
        %(\t#\n) => %q(),
        %( #\n) => %q(),
        %(<http://example/a> <http://example/b> <http://example/c> . # comment\n) =>
          %q(<http://example/a> <http://example/b> <http://example/c> .)
      }.each_pair do |input, output|
        it "for #{input.inspect}" do
          expect(parse(input, validate: true).dump(:ntriples)).to eq parse(output).dump(:ntriples)
        end
      end
    end

    it "W3C's test data" do
      gn = RDF::Graph.new {|g| reader.new(File.open(testfile)) {|r| g << r}}
      gt = RDF::Graph.new {|g| RDF::Turtle::Reader.new(File.open(testfile)) {|r| g << r}}
      expect(gn).to be_equivalent_graph(gt)
      expect(gn.to_a.size).to eq 31
    end

    describe "BNodes" do
      it "should read two named nodes as the same node" do
        stmt = reader.new("_:a <http://www.w3.org/2002/07/owl#sameAs> _:a .".freeze).first
        expect(stmt.subject).to eq stmt.object
        expect(stmt.subject).to be_eql(stmt.object)
      end

      it "should read two named nodes in different instances as different nodes" do
        stmt1 = reader.new("_:a <http://www.w3.org/2002/07/owl#sameAs> _:a .".freeze).first
        stmt2 = reader.new("_:a <http://www.w3.org/2002/07/owl#sameAs> _:a .".freeze).first
        expect(stmt1.subject).to eq stmt2.subject
        expect(stmt1.subject).not_to be_eql(stmt2.subject)
      end
    end

    describe "literal encodings" do
      {
        'Dürst'          => '_:a <http://pred> "D\u00FCrst" .',
        'simple literal' => '<http://subj> <http://pred>  "simple literal" .',
        'backslash:\\'   => '<http://subj> <http://pred> "backslash:\\\\" .',
        'squote:\''      => '<http://subj> <http://pred> "squote:\'" .',
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
          stmt = reader.new(triple).first
          expect(stmt.object.value).to eq contents
          ttl = RDF::Turtle::Reader.new(triple).first
          expect(stmt).to eq ttl
        end
      end

      context "base direction" do
        context "without rdfstar option" do
          it "Raises an error" do
            expect do
              expect {parse('<http://subj> <http://pred>  "Hello"@en--ltr .')}.to raise_error(RDF::ReaderError)
            end.to write(:something).to(:error)
          end
        end

        context 'parse language/direction' do
          {
            "language" => '<http://subj> <http://pred>  "Hello"@en .',
            "direction" => '<http://subj> <http://pred>  "Hello"@en--ltr .',
            "direction2" => '<http://subj> <http://pred>  "Hello"@en--rtl .',
          }.each_pair do |name, triple|
            specify "test #{name}" do
              stmt = reader.new(triple, rdfstar: true).first
              if name.include?('dir')
                expect(stmt.object.datatype).to eql RDF.dirLangString
              else
                expect(stmt.object.datatype).to eql RDF.langString
              end
            end
          end

          {
            "language with ill-formted tag" => '<http://subj> <http://pred> "Hello"@--ltr',
            "direction without language" => '<http://subj> <http://pred> "Hello"@e',
            "bad direction" => '<http://subj> <http://pred> "Hello"@en--RTL'
          }.each_pair do |name, triple|
            it name do
              expect do
                reader.new(triple, rdfstar: true, validate: true).first
              end.to raise_error(RDF::ReaderError)
            end
          end
        end

        it "warns if version is not 1.2 or 1.2-basic" do
          expect {parse('<http://subj> <http://pred>  "Hello"@en--ltr .', rdfstar: true, version: '1.1', logger: logger)}.not_to raise_error
          expect(logger.to_s).to include("WARN")
        end

        it "warns if inline version is not 1.2 or 1.2-basic" do
          expect {parse(%{VERSION "1.1"\n<http://subj> <http://pred>  "Hello"@en--ltr .}, rdfstar: true, logger: logger)}.not_to raise_error
          expect(logger.to_s).to include("WARN")
        end
      end

      context 'should parse a value that was written without passing through the writer encoding' do
        [
          %(<http://subj> <http://pred> "Procreation Metaphors in S\xC3\xA9an \xC3\x93 R\xC3\xADord\xC3\xA1in's Poetry" .),
          %q(<http://example.org/resource33> <http://example.org/property> "From \\"Voyage dans l’intérieur de l’Amérique du Nord, executé pendant les années 1832, 1833 et 1834, par le prince Maximilien de Wied-Neuwied\\" (Paris & Coblenz, 1839-1843)" .),
        ].map {|s| s.force_encoding("ASCII-8BIT")}.each do |nt|
          it nt do
            statement = reader.new(nt).first
            ttl = RDF::Turtle::Reader.new(nt).first
            expect(statement).to eq(ttl)
          end
        end
      end

      it "literal with escape" do
        nt = %(<http://subj> <http://pred> "\\U00015678another" .)
          statement = reader.new(nt).first
          ttl = RDF::Turtle::Reader.new(nt).first
          expect(statement).to eq(ttl)
      end

      {
        "three uris"  => "<http://example.org/resource1> <http://example.org/property> <http://example.org/resource2> .",
        "spaces and tabs throughout" => " 	 <http://example.org/resource3> 	 <http://example.org/property>	 <http://example.org/resource2> 	.	 ",
        "line ending with CR NL" => "<http://example.org/resource4> <http://example.org/property> <http://example.org/resource2> .\r\n",
        "literal escapes (1)" => '<http://example.org/resource7> <http://example.org/property> "simple literal" .',
        "literal escapes (2)" => '<http://example.org/resource8> <http://example.org/property> "backslash:\\\\" .',
        "literal escapes (3)" => '<http://example.org/resource9> <http://example.org/property> "squote:\'" .',
        "literal escapes (4)" => '<http://example.org/resource9> <http://example.org/property> "dquote:\"" .',
        "literal escapes (5)" => '<http://example.org/resource10> <http://example.org/property> "newline:\n" .',
        "literal escapes (6)" => '<http://example.org/resource11> <http://example.org/property> "return:\r" .',
        "literal escapes (7)" => '<http://example.org/resource12> <http://example.org/property> "tab:\t" .',
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

        "Literals with languages (1)" => '<http://example.org/resource30> <http://example.org/property> "chat"@fr .',
        "Literals with languages (2)" => '<http://example.org/resource31> <http://example.org/property> "chat"@en .',
        # FIXME: once rdfstar option is no longer used
        #"Literals with language and direction" => '<http://example.org/resource31> <http://example.org/property> "chat"@en--ltr .',
        "Typed Literals" => '<http://example.org/resource32> <http://example.org/property> "abc"^^<http://example.org/datatype1> .',
        "Plain lieral with embedded quote" => %q(<http://example.org/resource33> <http://example.org/property> "From \\"Voyage dans l’intérieur de l’Amérique du Nord, executé pendant les années 1832, 1833 et 1834, par le prince Maximilien de Wied-Neuwied\\" (Paris & Coblenz, 1839-1843)" .),
      }.each_pair do |name, nt|
        specify "test #{name}" do
          Array(nt).each do |s|
            r = reader.new(s)
            statement = r.first
            ttl = RDF::Turtle::Reader.new(s).first
            expect(statement).to eq(ttl)
          end
        end
      end
    end

    describe "i18n URIs" do
      {
        %(<http://a/b#Dürst> <http://www.w3.org/1999/02/22-rdf-syntax-ns#type> "URI straight in UTF8".) => %(<http://a/b#D\\u00FCrst> <http://www.w3.org/1999/02/22-rdf-syntax-ns#type> "URI straight in UTF8" .),
        %(<http://a/b#a> <http://a/b#related> <http://a/b#\u3072\u3089\u304C\u306A>.) => %(<http://a/b#a> <http://a/b#related> <http://a/b#\\u3072\\u3089\\u304C\\u306A> .),
      }.each_pair do |src, res|
        specify src do
          stmt1 = reader.new(src, validate: false).first
          stmt2 = reader.new(res, validate: true).first
          expect(stmt1).to eq stmt2
          ttl1 = RDF::Turtle::Reader.new(src).first
          ttl2 = RDF::Turtle::Reader.new(res).first
          expect(stmt1).to eq ttl1
          expect(stmt2).to eq ttl2
        end
      end
    end

    context "ASCII-8BIT input" do
      {
        "uris"                    => %q(<http://example/> <http://example/> <http://example/> .),
        "bnode subject"           => %q(_:s <http://example/> <http://example/> .),
        "bnode object"            => %q(<http://example/> <http://example/> _:o .),
        "simple literal"          => %q(<http://example/> <http://example/> "o" .),
        "language tagged literal" => %q(<http://example/> <http://example/> "o"@en .),
        "datatyped literal"       => %q(<http://example/> <http://example/> "o"^^<http://example/> .),
      }.each do |name, src|
        specify name do
          g = parse(src.encode("ASCII-8BIT"))
          expect {g.dump(:ntriples)}.not_to raise_error
          ttl = RDF::Turtle::Reader.new(src.encode("ASCII-8BIT")).first
          expect(g.first).to eq(ttl)
        end
      end
    end

    context "version" do
      {
        'VERSION "1.2"': %(
          VERSION "1.2"
          <http://example/s> <http://example/p> <http://example/o>
        ),
        'VERSION "1.2-basic"': %(
          VERSION "1.2-basic"
          <http://example/s> <http://example/p> <http://example/o>
        ),
        'VERSION "1.1"': %(
          VERSION "1.1"
          <http://example/s> <http://example/p> <http://example/o>
        ),
      }.each do |name, input|
        it name do
          expect do
            parse(input, logger: logger)
            expect(logger.to_s).not_to include("WARN")
          end.not_to write.to(:error)
        end
      end

      it 'version "1.2" is an error' do
        expect do
          parse('version "1.2"', logger: logger)
        end.to raise_error(RDF::ReaderError)
      end

      it 'VERSION "1.0" is a warning' do
        expect do
          parse('VERSION "1.0"', logger: logger)
        end.not_to write.to(:error)
        expect(logger.to_s).to include('WARN')
      end
    end

    context "triple terms" do
      ill_statements = {
        "subject-iii": '<<(<http://example/s1> <http://example/p1> <http://example/o1>)>> <http://example/p> <http://example/o> .',
        "subject-iib": '<<(<http://example/s1> <http://example/p1> _:o1)>> <http://example/p> <http://example/o> .',
        "subject-iil": '<<(<http://example/s1> <http://example/p1> "o1")>> <http://example/p> <http://example/o> .',
        "subject-bii": '<<(_:s1 <http://example/p1> <http://example/o1>)>> <http://example/p> <http://example/o> .',
        "subject-bib": '<<(_:s1 <http://example/p1> _:o1)>> <http://example/p> <http://example/o> .',
        "subject-bil": '<<(_:s1 <http://example/p1> "o")>> <http://example/p> <http://example/o> .',
        "subject-ws":  '<<( <http://example/s1> <http://example/p1> <http://example/o1> )>> <http://example/p> <http://example/o> .',
        "recursive-subject": '<<(<<(<http://example/s2> <http://example/p2> <http://example/o2>)>> <http://example/p1> <http://example/o1>)>> <http://example/p> <http://example/o> .',
      }

      statements = {
        "object-iii":  '<http://example/s> <http://example/p> <<(<http://example/s1> <http://example/p1> <http://example/o1>)>> .',
        "object-iib":  '<http://example/s> <http://example/p> <<(<http://example/s1> <http://example/p1> _:o1)>> .',
        "object-iil":  '<http://example/s> <http://example/p> <<(<http://example/s1> <http://example/p1> "o1")>> .',
        "object-bii":  '<http://example/s> <http://example/p> <<(_:s1 <http://example/p1> <http://example/o1>)>> .',
        "object-bib":  '<http://example/s> <http://example/p> <<(_:s1 <http://example/p1> _:o1)>> .',
        "object-bil":  '<http://example/s> <http://example/p> <<(_:s1 <http://example/p1> "o1")>> .',
        "object-ws":   '<http://example/s> <http://example/p> <<( <http://example/s1> <http://example/p1> <http://example/o1> )>> .',

        "recursive-object": '<http://example/s> <http://example/p> <<(<http:/example/s1> <http://example/p1> <<(<http://example/s2> <http://example/p2> <http://example/o2>)>>)>> .',
      }

      context "without rdfstar option" do
        it "Raises an error" do
          expect do
            expect {parse(statements.values.first)}.to raise_error(RDF::ReaderError)
          end.to write(:something).to(:error)
        end
      end

      context "with rdfstar option" do
        ill_statements.each do |name, st|
          context name do
            it "Raises an error" do
              expect do
                expect {parse(st)}.to raise_error(RDF::ReaderError)
              end.to write(:something).to(:error)
            end
          end
        end

        statements.each do |name, st|
          context name do
            let(:graph) {parse(st, rdfstar: true, logger: logger)}

            it "statements which are object of another statement are triple terms" do
              referencing = graph.statements.first
              expect(referencing).to be_a_statement
              expect(referencing.object).to be_a_statement
              expect(referencing.object).to be_tripleTerm
              expect(logger.to_s).not_to include("WARN")
            end

            it "warns if version is not 1.2" do
              expect {parse(st, rdfstar: true, version: '1.1', logger: logger)}.not_to raise_error
              expect(logger.to_s).to include("WARN")
            end

            it "warns if inline version is not 1.2" do
              expect {parse(%{VERSION "1.1"\n#{st}}, rdfstar: true, logger: logger)}.not_to raise_error
              expect(logger.to_s).to include("WARN")

              expect {parse(%{VERSION "1.2-basic"\n#{st}}, rdfstar: true, logger: logger)}.not_to raise_error
              expect(logger.to_s).to include("WARN")
            end
          end
        end
      end
    end

    context "invalid input" do
      {
        "nt-syntax-bad-struct-01" => [
          %q(<http://example/s> <http://example/p> <http://example/o>, <http://example/o2> .),
          %r(Expected end of statement \(found: ", .* \."\))
        ],
        "nt-syntax-bad-struct-02" => [
          %q(<http://example/s> <http://example/p> <http://example/o>; <http://example/p2>, <http://example/o2> .),
          %r(Expected end of statement \(found: "; .* \."\))
        ],
        "nt-syntax-bad-lang-01" => [
          %q(<http://example/s> <http://example/p> "string"@1 .),
          %r(Expected end of statement \(found: "@1 \."\))
        ],
        "xx bad lang 2" => [
          %q(<http://example/s> <http://example/p> "string"@cantbethislong .),
          %r(Invalid Literal)
        ],
        "xx bad dir 1" => [
          %q(<http://example/s> <http://example/p> "string"@en--UTD .),
          %r(Invalid Literal)
        ],
        "xx bad dir 2" => [
          %q(<http://example/s> <http://example/p> "string"@--ltr .),
          %r(Expected end of statement)
        ],
        "xx bad dir 3" => [
          %q(<http://example/s> <http://example/p> "string"@en--LTR .),
          %r(Invalid Literal)
        ],
        "nt-syntax-bad-string-05" => [
          %q(<http://example/s> <http://example/p> """abc""" .),
          %r(Expected end of statement \(found: .* \."\))
        ],
        "nt-syntax-bad-num-01" => [
          %q(<http://example/s> <http://example/p> 1 .),
          %r(Expected object \(found: "1 \."\))
        ],
        "nt-syntax-bad-num-02" => [
          %q(<http://example/s> <http://example/p> 1.0 .),
          %r(Expected object \(found: "1\.0 \."\))
        ],
        "nt-syntax-bad-num-03" => [
          %q(<http://example/s> <http://example/p> 1.0e0 .),
          %r(Expected object \(found: "1\.0e0 \."\))
        ],
        "nt-syntax-bad-uri-02" => [
          %(# Bad IRI : space.\n<http://example/ space> <http://example/p> <http://example/o> .),
          %r(Expected subject)
        ],
        "nt-syntax-bad-uri-07" => [
          %(# No relative IRIs in N-Triples\n<http://example/s> <p> <http://example/o> .),
          %r(Invalid URI)
        ],
        "bnode predicate" => [
          %q(<http://example/s> _:p <http://example/o> .),
          %r(Expected predicate)
        ]
      }.each do |name, (nt, error)|
        it name do
          expect {reader.new(nt.freeze, validate: true, logger: logger).to_a}.to raise_error(RDF::ReaderError)
          expect(logger.to_s).to match error
        end
      end
    end
  end
end

describe RDF::NTriples::Writer do
  let(:logger) {RDF::Spec.logger}
  let(:writer) { RDF::NTriples::Writer }
  let!(:stmt) {
    s = RDF::URI("https://rubygems.org/gems/rdf")
    p = RDF::URI("http://purl.org/dc/terms/creator")
    o = RDF::URI("http://ar.to/#self")
    RDF::Statement(s, p, o)
  }
  let!(:stmt_string) {
    "<https://rubygems.org/gems/rdf> <http://purl.org/dc/terms/creator> <http://ar.to/#self> ."
  }
  let!(:graph) {RDF::Graph.new << stmt}
  subject { RDF::NTriples::Writer.new }

  describe ".for" do
    [
      :ntriples,
      'etc/doap.nt',
      {file_name:      'etc/doap.nt'},
      {file_extension: 'nt'},
      {content_type:   'application/n-triples'},
    ].each do |arg|
      it "discovers with #{arg.inspect}" do
        expect(RDF::Writer.for(arg)).to eq RDF::NTriples::Writer
      end
    end
  end

  # @see lib/rdf/spec/writer.rb in rdf-spec
  it_behaves_like 'an RDF::Writer' do
    let(:writer) { RDF::NTriples::Writer.new }
  end

  it "defaults validation to be true" do
    expect(subject).to be_validate
  end

  it "should return :ntriples for to_sym" do
    expect(RDF::NTriples::Writer.to_sym).to eq :ntriples
  end

  context "Writing a Graph" do
    let(:graph) {
      g = RDF::Graph.new
      g << [RDF::URI('http://example/s'), RDF::URI('http://example/p'), RDF::URI('http://example/o1')]
      g << [RDF::URI('http://example/s'), RDF::URI('http://example/p'), RDF::URI('http://example/o2'), RDF::URI('c')]
      g
    }
    it "#insert" do
      expect do
        writer.new($stdout).insert(graph)
      end.to write_each("<http://example/s> <http://example/p> <http://example/o1> .\n",
                        "<http://example/s> <http://example/p> <http://example/o2> .\n")
    end

    it "writes version with :version option" do
      expect do
        writer.new($stdout, version: "1.2") do |w|
          w.insert(graph)
        end
      end.to write(%(VERSION "1.2"))
    end

    it "does not write version with unless specified" do
      expect do
        writer.new($stdout, version: nil) do |w|
          w.insert(graph)
        end
      end.not_to write(%(VERSION "1.2"))
    end

    it "writes version with :rdfstar option" do
      expect do
        writer.new($stdout, rdfstar: true) do |w|
          w.insert(graph)
        end
      end.to write(%(VERSION "1.2"))
    end
  end

  context "Writing Statements" do
    let(:statements) {[
      RDF::Statement(RDF::URI('s'), RDF::URI('p'), RDF::URI('o1')),
      RDF::Statement(RDF::URI('s'), RDF::URI('p'), RDF::URI('o2'))
    ]}
    it "#insert" do
      expect do
        writer.new($stdout, validate: false).insert(*statements)
      end.to write_each("<s> <p> <o1> .\n", "<s> <p> <o2> .\n")
    end
    it "should correctly format statements" do
      expect(writer.new.format_statement(stmt)).to eq stmt_string
    end

    context "should correctly format blank nodes" do
      specify {expect(writer.new.format_node(RDF::Node.new('foobar'))).to eq '_:foobar'}
      specify {expect(writer.new.format_node(RDF::Node.new(''))).not_to eq '_:'}
    end

    it "should correctly format URI references" do
      expect(writer.new.format_uri(RDF::URI('https://rubygems.org/gems/rdf'))).to eq '<https://rubygems.org/gems/rdf>'
    end

    it "should correctly format plain literals" do
      expect(writer.new.format_literal(RDF::Literal.new('Hello, world!'))).to eq '"Hello, world!"'
    end

    it "should correctly format string literals" do
      expect(writer.new.format_literal(RDF::Literal.new('Hello, world!', datatype: RDF::XSD.string))).to eq '"Hello, world!"'
    end

    it "should correctly format language-tagged literals" do
      expect(writer.new.format_literal(RDF::Literal.new('Hello, world!', language: :en))).to eq '"Hello, world!"@en'
    end

    it "should correctly format directional language-tagged literals" do
      expect(writer.new.format_literal(RDF::Literal.new('Hello, world!', language: :en, direction: :ltr))).to eq '"Hello, world!"@en--ltr'
    end

    it "should correctly format datatyped literals" do
      expect(writer.new.format_literal(RDF::Literal.new(3.1415))).to eq '"3.1415"^^<http://www.w3.org/2001/XMLSchema#double>'
    end

    it "should correctly format language-tagged literals with rdf:langString" do
      l = RDF::Literal.new('Hello, world!', language: :en, datatype: RDF.langString)
      expect(writer.new.format_literal(l)).to eq '"Hello, world!"@en'
    end

    it "should output statements to a string buffer" do
      output = writer.buffer { |writer| writer << stmt }
      expect(output).to eq "#{stmt_string}\n"
    end

    it "should dump statements to a string buffer" do
      output = StringIO.new
      writer.dump(graph, output)
      expect(output.string).to eq "#{stmt_string}\n"
    end

    it "should dump arrays of statements to a string buffer" do
      output = StringIO.new
      writer.dump(graph.to_a, output)
      expect(output.string).to eq "#{stmt_string}\n"
    end

    it "should dump statements to a file", skip: ('not windows' if Gem.win_platform?) do
      require 'tmpdir' # for Dir.tmpdir
      writer.dump(graph, filename = File.join(Dir.tmpdir, "test.nt"))
      expect(File.read(filename)).to eq "#{stmt_string}\n"
      File.unlink(filename)
    end
  end

  context "Nodes" do
    let(:statement) {RDF::Statement(RDF::Node("a"), RDF.type, RDF::Node("b"))}
    it "uses node lables by default" do
      expect(writer.buffer {|w| w << statement}).to match %r(_:a <http://www.w3.org/1999/02/22-rdf-syntax-ns#type> _:b \.)
    end

    it "uses unique labels if :unique_bnodes is true" do
      expect(writer.buffer(unique_bnodes:true) {|w| w << statement}).to match %r(_:g\w+ <http://www.w3.org/1999/02/22-rdf-syntax-ns#type> _:g\w+ \.)
    end
  end

  describe "IRIs" do
    {
      %(<http://example/joe> <http://xmlns.com/foaf/0.1/knows> <http://example/jane> .) =>
        %(<http://example/joe> <http://xmlns.com/foaf/0.1/knows> <http://example/jane> .),
      %(<http://example/#D%C3%BCrst>  <http://www.w3.org/1999/02/22-rdf-syntax-ns#type>  "URI percent ^encoded as C3, BC".) =>
        %(<http://example/#D%C3%BCrst> <http://www.w3.org/1999/02/22-rdf-syntax-ns#type> "URI percent ^encoded as C3, BC" .),
      %q(<http://example/node> <http://example/prop> <scheme:!$%25&'()*+,-./0123456789:/@ABCDEFGHIJKLMNOPQRSTUVWXYZ_abcdefghijklmnopqrstuvwxyz~?#> .) =>
        %q(<http://example/node> <http://example/prop> <scheme:!$%25&'()*+,-./0123456789:/@ABCDEFGHIJKLMNOPQRSTUVWXYZ_abcdefghijklmnopqrstuvwxyz~?#> .),
    }.each_pair do |input, output|
      it "for '#{input}'" do
        expect(parse(input, validate: true).dump(:ntriples)).to eq parse(output).dump(:ntriples)
      end
    end

    {
      %(<http://example/#Dürst> <http://example/knows> <http://example/jane>.) => '<http://example/#D\u00FCrst> <http://example/knows> <http://example/jane> .',
      %(<http://example/Dürst> <http://example/knows> <http://example/jane>.) => '<http://example/D\u00FCrst> <http://example/knows> <http://example/jane> .',
      %(<http://example/bob> <http://example/resumé> "Bob's non-normalized resumé".) => '<http://example/bob> <http://example/resumé> "Bob\'s non-normalized resumé" .',
      %(<http://example/alice> <http://example/resumé> "Alice's normalized resumé".) => '<http://example/alice> <http://example/resumé> "Alice\'s normalized resumé" .',
      }.each_pair do |input, output|
        it "for '#{input}'" do
          expect(parse(input).dump(:ntriples)).to eq parse(output).dump(:ntriples)
        end
      end

    {
      %(<http://example/#Dürst> <http://www.w3.org/1999/02/22-rdf-syntax-ns#type>  "URI straight in UTF8".) => %(<http://example/#D\\u00FCrst> <http://www.w3.org/1999/02/22-rdf-syntax-ns#type> "URI straight in UTF8" .),
      %(<http://example/a> <http://example/related> <http://example/ひらがな> .) => %(<http://example/a> <http://example/related> <http://example/\\u3072\\u3089\\u304C\\u306A> .),
    }.each_pair do |input, output|
      it "for '#{input}'" do
        expect(parse(input).dump(:ntriples)).to eq parse(output).dump(:ntriples)
      end
    end

    [
      %(\x00),
      %(\x01),
      %(\x0f),
      %(\x10),
      %(\x1f),
      %(\x20),
      %(<),
      %(>),
      %("),
      %({),
      %(}),
      %(|),
      %(\\),
      %(^),
      %(``),
      %(http://example.com/\u0020),
      %(http://example.com/\u003C),
      %(http://example.com/\u003E),
    ].each do |uri|
      it "rejects #{('<' + uri + '>').inspect}" do
        logger = RDF::Spec.logger
        expect {parse(%(<s> <p> <#{uri}>), validate: true, logger: logger)}.to raise_error RDF::ReaderError
        expect(logger.to_s).not_to be_empty
      end
    end
  end

  context ":encoding" do
    %w(US-ASCII UTF-8).each do |encoding_name|
      context encoding_name do
        let(:encoding) { ::Encoding.find(encoding_name)}
        it "dumps to String" do
          s = writer.dump(graph, nil, encoding: encoding)
          expect(s).to be_a(String)
          expect(s.encoding).to eq encoding
        end

        it "dumps to file" do
          output = StringIO.new
          writer.dump(graph, output, encoding: encoding)
          expect(output.external_encoding).to eq encoding
        end
      end
    end

    context "when encoding text to ASCII" do
      let(:encoding) { "".respond_to?(:encoding) ? ::Encoding::ASCII : nil}

      # @see http://www.w3.org/TR/rdf-testcases/#ntrip_strings
      it "should correctly escape ASCII characters (#x0-#x7F)" do
        (0x00..0x07).each { |u| expect(writer.escape(u.chr, encoding)).to eq "\\u#{u.to_s(16).upcase.rjust(4, '0')}" }
        expect(writer.escape(0x08.chr, encoding)).to eq "\\b"
        expect(writer.escape(0x09.chr, encoding)).to eq "\\t"
        expect(writer.escape(0x0A.chr, encoding)).to eq "\\n"
        expect(writer.escape(0x0B.chr, encoding)).to eq "\\u000B"
        expect(writer.escape(0x0C.chr, encoding)).to eq "\\f"
        expect(writer.escape(0x0D.chr, encoding)).to eq "\\r"
        (0x0E..0x1F).each { |u| expect(writer.escape(u.chr, encoding)).to eq "\\u#{u.to_s(16).upcase.rjust(4, '0')}" }
        (0x20..0x21).each { |u| expect(writer.escape(u.chr, encoding)).to eq u.chr }
        expect(writer.escape(0x22.chr, encoding)).to eq "\\\""
        (0x23..0x26).each { |u| expect(writer.escape(u.chr, encoding)).to eq u.chr }
        expect(writer.escape(0x27.chr, encoding)).to eq "'"
        (0x28..0x5B).each { |u| expect(writer.escape(u.chr, encoding)).to eq u.chr }
        expect(writer.escape(0x5C.chr, encoding)).to eq "\\\\"
        (0x5D..0x7E).each { |u| expect(writer.escape(u.chr, encoding)).to eq u.chr }
        expect(writer.escape(0x7F.chr, encoding)).to eq "\\u007F"
      end

      # @see http://www.w3.org/TR/rdf-testcases/#ntrip_strings
      # @see http://en.wikipedia.org/wiki/Mapping_of_Unicode_characters#Planes
      it "should correctly escape Unicode characters (#x80-#x10FFFF)" do
        (0x80..0xFFFF).to_a.sample(100).each do |u|
          begin
            next unless (c = u.chr(::Encoding::UTF_8)).valid_encoding?
            expect(writer.escape(c, encoding)).to eq "\\u#{u.to_s(16).upcase.rjust(4, '0')}"
          rescue RangeError
          end
        end
        (0x10000..0x2FFFF).to_a.sample(100).each do |u| # NB: there's nothing much beyond U+2FFFF
          begin
            next unless (c = u.chr(::Encoding::UTF_8)).valid_encoding?
            expect(writer.escape(c, encoding)).to eq "\\U#{u.to_s(16).upcase.rjust(8, '0')}"
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
          string = string.encode(Encoding::UTF_8)
          expect(writer.escape(string)).to eq escaped
        end
      end

      # @see https://github.com/ruby-rdf/rdf/issues/#issue/7
      it "should correctly handle RDF.rb issue #7" do
        input  = %Q(<http://openlibrary.org/b/OL3M> <http://RDVocab.info/Elements/titleProper> "Jh\xC5\xABl\xC4\x81." .)
        output = %Q(<http://openlibrary.org/b/OL3M> <http://RDVocab.info/Elements/titleProper> "Jh\\u016Bl\\u0101." .)
        writer = RDF::NTriples::Writer.new(StringIO.new, encoding: :ascii)
        expect(writer.format_statement(RDF::NTriples.unserialize(input))).to eq output
      end
    end

    context "when encoding text to UTF-8" do
      let(:encoding) { "".respond_to?(:encoding) ? ::Encoding::UTF_8 : nil}

      # @see http://www.w3.org/TR/rdf-testcases/#ntrip_strings
      it "should correctly escape ASCII characters (#x0-#x7F)" do
        (0x00..0x07).each { |u| expect(writer.escape(u.chr, encoding)).to eq "\\u#{u.to_s(16).upcase.rjust(4, '0')}" }
        expect(writer.escape(0x08.chr, encoding)).to eq "\\b"
        expect(writer.escape(0x09.chr, encoding)).to eq "\\t"
        expect(writer.escape(0x0A.chr, encoding)).to eq "\\n"
        expect(writer.escape(0x0B.chr, encoding)).to eq "\\u000B"
        expect(writer.escape(0x0C.chr, encoding)).to eq "\\f"
        expect(writer.escape(0x0D.chr, encoding)).to eq "\\r"
        (0x0E..0x1F).each { |u| expect(writer.escape(u.chr, encoding)).to eq "\\u#{u.to_s(16).upcase.rjust(4, '0')}" }
        (0x20..0x21).each { |u| expect(writer.escape(u.chr, encoding)).to eq u.chr }
        expect(writer.escape(0x22.chr, encoding)).to eq "\\\""
        (0x23..0x26).each { |u| expect(writer.escape(u.chr, encoding)).to eq u.chr }
        expect(writer.escape(0x27.chr, encoding)).to eq "'"
        (0x28..0x5B).each { |u| expect(writer.escape(u.chr, encoding)).to eq u.chr }
        expect(writer.escape(0x5C.chr, encoding)).to eq "\\\\"
        (0x5D..0x7E).each { |u| expect(writer.escape(u.chr, encoding)).to eq u.chr }
        expect(writer.escape(0x7F.chr, encoding)).to eq "\\u007F"
      end

      # @see http://www.w3.org/TR/rdf-testcases/#ntrip_strings
      # @see http://en.wikipedia.org/wiki/Mapping_of_Unicode_characters#Planes
      it "should not escape Unicode characters (#x80-#x10FFFF)" do
        (0x80..0xFFFF).to_a.sample(100).each do |u|
          begin
            next unless (c = u.chr(::Encoding::UTF_8)).valid_encoding?
            expect(writer.escape(c, encoding)).to eq c
          rescue RangeError
          end
        end
        (0x10000..0x2FFFF).to_a.sample(100).each do |u| # NB: there's nothing much beyond U+2FFFF
          begin
            next unless (c = u.chr(::Encoding::UTF_8)).valid_encoding?
            expect(writer.escape(c, encoding)).to eq c
          rescue RangeError
          end
        end
      end

      it "should not escape Unicode strings" do
        strings = [
          "_\u221E_", # U+221E, infinity symbol
          "_\u6C34_", # U+6C34, 'water' in Chinese
        ]
        strings.each do |string|
          string = string.encode(Encoding::UTF_8)
          expect(writer.escape(string, encoding)).to eq string
        end
      end
    end
  end

  context "validataion" do
    shared_examples "validation" do |statement, valid|
      context "given #{statement}" do
        subject {RDF::NTriples::Writer.buffer(validate: true, logger: logger) {|w| w << statement}}

        if valid
          specify {
            expect {subject}.not_to raise_error
            #expect(logger.to_s).to be_empty
          }
        else
          specify {
            expect {subject}.to raise_error(RDF::WriterError)
            #expect(logger.to_s).not_to be_empty
          }
        end
      end
    end

    {
      RDF::Statement(RDF::URI("https://rubygems.org/gems/rdf"), RDF::URI("http://purl.org/dc/terms/creator"), RDF::URI("http://ar.to/#self")) => true,
      RDF::Statement(RDF::Node("node"), RDF::URI("http://purl.org/dc/terms/creator"), RDF::URI("http://ar.to/#self")) => true,
      RDF::Statement(RDF::URI("https://rubygems.org/gems/rdf"), RDF::URI("http://purl.org/dc/terms/creator"), RDF::Node("node")) => true,
      RDF::Statement(RDF::URI("https://rubygems.org/gems/rdf"), RDF::URI("http://purl.org/dc/terms/creator"), RDF::Literal("literal")) => true,
      RDF::Statement(RDF::URI('file:///path/to/file with spaces.txt'), RDF::URI("http://purl.org/dc/terms/creator"), RDF::URI("http://ar.to/#self")) => false,
      RDF::Statement(nil, RDF::URI("http://purl.org/dc/terms/creator"), RDF::URI("http://ar.to/#self")) => false,
      RDF::Statement(RDF::URI("https://rubygems.org/gems/rdf"), nil, RDF::URI("http://ar.to/#self")) => false,
      RDF::Statement(RDF::URI("https://rubygems.org/gems/rdf"), RDF::URI("http://purl.org/dc/terms/creator"), nil) => false,
      RDF::Statement(RDF::Literal("literal"), RDF::URI("http://purl.org/dc/terms/creator"), RDF::URI("http://ar.to/#self")) => false,
      RDF::Statement(RDF::URI("https://rubygems.org/gems/rdf"), RDF::Node("node"), RDF::URI("http://ar.to/#self")) => false,
      RDF::Statement(RDF::URI("https://rubygems.org/gems/rdf"), RDF::Literal("literal"), RDF::URI("http://ar.to/#self")) => false,
      RDF::Statement(RDF::URI('scheme://auth/\\u0000'), RDF::URI("http://purl.org/dc/terms/creator"), RDF::URI("http://ar.to/#self")) => false,
      RDF::Statement(RDF::URI('scheme://auth/^'), RDF::URI("http://purl.org/dc/terms/creator"), RDF::URI("http://ar.to/#self")) => false,
      RDF::Statement(RDF::URI('scheme://auth/`'), RDF::URI("http://purl.org/dc/terms/creator"), RDF::URI("http://ar.to/#self")) => false,
      RDF::Statement(RDF::URI('scheme://auth/\\'), RDF::URI("http://purl.org/dc/terms/creator"), RDF::URI("http://ar.to/#self")) => false,
    }.each do |st, valid|
      include_examples "validation", st, valid
    end
  end

  # Fixme, these should go in rdf/spec/writer.rb
  context "c14n" do
    shared_examples "c14n" do |statement, result|
      context "given #{statement}" do
        it "produces #{result}" do
          g = parse(statement, canonicalize: true)
          expect(g.count).to eq 1
          c14n = RDF::NTriples::Writer.buffer(validate: false, canonicalize: true, logger: logger) {|w| w << g}
          expect(c14n).to eq "#{result}\n"
        end
      end
  end

    {
      %(<https://rubygems.org/gems/rdf> <http://purl.org/dc/terms/creator> <http://ar.to/#self> .) =>
        %(<https://rubygems.org/gems/rdf> <http://purl.org/dc/terms/creator> <http://ar.to/#self> .),
      %(<https://rubygems.org/gems/rdf> <http://purl.org/dc/terms/creator> "literal" .) =>
        %(<https://rubygems.org/gems/rdf> <http://purl.org/dc/terms/creator> "literal" .),
      %(<http://a.example/s> <http://a.example/p> "\\U00000000\\U00000001\\U00000002\\U00000003\\U00000004\\U00000005\\U00000006\\U00000007\\U0000000B\\U0000000E\\U0000000F\\U00000010\\U00000011\\U00000012\\U00000013\\U00000014\\U00000015\\U00000016\\U00000017\\U00000018\\U00000019\\U0000001A\\U0000001B\\U0000001C\\U0000001D\\U0000001E\\U0000001F\\U0000007F\\U0000FFFE\\U0000FFFF" .) =>
        %(<http://a.example/s> <http://a.example/p> "\\u0000\\u0001\\u0002\\u0003\\u0004\\u0005\\u0006\\u0007\\u000B\\u000E\\u000F\\u0010\\u0011\\u0012\\u0013\\u0014\\u0015\\u0016\\u0017\\u0018\\u0019\\u001A\\u001B\\u001C\\u001D\\u001E\\u001F\\u007F\\uFFFE\\uFFFF" .),
    }.each do |st, result|
      include_examples "c14n", st, result
    end
  end

  context "logging behavior when dumping invalid statements multiple times in a row" do
    before do
      allow($stderr).to receive(:write)
    end

    it "raises each time an invalid statement is dumped (not only the first time)" do
      g = RDF::Graph.new
      g.from_ntriples('<https://rubygems.org/gems/rdf/resource/0cb45b70-4c37-4270-9955-350c636496fc> <https://rubygems.org/gems/rdf/ontology/xxx/1.1#testDate> "2018-06-01T16:30:00Z"^^<http://www.w3.org/2001/XMLSchema#date> .')

      errors = (1..5).map do |_|
        begin
          g.dump(:ntriples)
          'noraise'
        rescue RDF::WriterError
          'raise'
        end
      end
      expect(errors).to eq(['raise'] * 5)
    end
  end
end

describe RDF::NTriples do
  let(:logger) {RDF::Spec.logger}
  let(:testfile) {fixture_path('test.nt')}

  let(:reader) {RDF::NTriples::Reader}
  let(:writer) {RDF::NTriples::Writer}

  context "Examples" do
    let(:graph) {RDF::Graph.new {|g| g << RDF::Statement(RDF::URI("http:/a"), RDF::URI("http:/b"), "c")}}

    it "Obtaining an NTriples format class" do
      [
        :ntriples,
        "etc/doap.nt",
        {file_name: "etc/doap.nt"},
        {file_extension: "nt"},
        {content_type: "application/n-triples"}
      ].each do |arg|
        expect(RDF::Format.for(arg)).to eql RDF::NTriples::Format
      end
    end

    it "Obtaining an NTriples reader class" do
      [
        :ntriples,
        "etc/doap.nt",
        {file_name: "etc/doap.nt"},
        {file_extension: "nt"},
        {content_type: "application/n-triples"}
      ].each do |arg|
        expect(RDF::Reader.for(arg)).to eql RDF::NTriples::Reader
      end
    end

    it "Parsing RDF statements from an NTriples file" do
      expect do
        RDF::NTriples::Reader.open("etc/doap.nt") do |reader|
          reader.each_statement do |statement|
            puts statement.inspect
          end
        end
      end.to write(:something).to(:output)
    end

    it "Parsing RDF statements from an NTriples string" do
      expect do
        data = StringIO.new(File.read("etc/doap.nt"))
        RDF::NTriples::Reader.new(data) do |reader|
          reader.each_statement do |statement|
            puts statement.inspect
          end
        end
      end.to write(:something).to(:output)
    end

    it "Obtaining an NTriples writer class" do
      [
        :ntriples,
        "etc/doap.nt",
        {file_name: "etc/doap.nt"},
        {file_extension: "nt"},
        {content_type: "application/n-triples"}
      ].each do |arg|
        expect(RDF::Writer.for(arg)).to eql RDF::NTriples::Writer
      end
    end

    it "Serializing RDF statements into an NTriples file" do
      mock = StringIO.new
      allow(File).to receive(:open).and_yield(mock)
      RDF::NTriples::Writer.open("etc/test.nt") do |writer|
        graph.each_statement do |statement|
          writer << statement
        end
      end
      expect(mock.length).not_to eql 0
    end

    it "Serializing RDF statements into an NTriples string" do
      output = RDF::NTriples::Writer.buffer do |writer|
        graph.each_statement do |statement|
          writer << statement
        end
      end
      expect(output).not_to be_empty
    end

    it "Serializing RDF statements into an NTriples string with escaped UTF-8" do
      output = RDF::NTriples::Writer.buffer(encoding: Encoding::ASCII) do |writer|
        graph.each_statement do |statement|
          writer << statement
        end
      end
      expect(output.encoding).to eql Encoding::ASCII
    end
  end
end


def parse(input, **options)
  options = {
    validate: false,
    canonicalize: false,
    deprecated: false,
  }.merge(options)
  graph = options[:graph] || RDF::Graph.new
  if options[:deprecated]
    expect do
      RDF::NTriples::Reader.new(input, **options).each do |statement|
        graph << statement
      end
    end.to write('[DEPRECATION]').to(:error)
  else
    RDF::NTriples::Reader.new(input, **options).each do |statement|
      graph << statement
    end
  end
  graph
end
