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
        RDF::Format.for(arg).should == @format_class
      end
    end

    {
      :ntriples => "<a> <b> <c> .",
      :literal => '<a> <b> "literal" .',
      :multi_line => %(<a>\n  <b>\n  "literal"\n .),
    }.each do |sym, str|
      it "detects #{sym}" do
        @format_class.for {str}.should == @format_class
      end
    end
  end

  describe "#to_sym" do
    specify {@format_class.to_sym.should == :ntriples}
  end

  describe "#name" do
    specify {@format_class.name.should == "N-Triples"}
  end
  
  describe ".detect" do
    {
      :ntriples => "<a> <b> <c> .",
      :literal => '<a> <b> "literal" .',
      :multi_line => %(<a>\n  <b>\n  "literal"\n .),
    }.each do |sym, str|
      it "detects #{sym}" do
        @format_class.detect(str).should be_true
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
        @format_class.detect(str).should be_false
      end
    end
  end
end

describe RDF::NTriples::Reader do
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
        RDF::Reader.for(arg).should == RDF::NTriples::Reader
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
          f.should_not == RDF::NTriples::Reader
        end
      end
    end
  end

  it "should return :ntriples for to_sym" do
    @reader.class.to_sym.should == :ntriples
    @reader.to_sym.should == :ntriples
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
        RDF::Writer.for(arg).should == RDF::NTriples::Writer
      end
    end
  end

  # @see lib/rdf/spec/writer.rb in rdf-spec
  include RDF_Writer

  it "should return :ntriples for to_sym" do
    RDF::NTriples::Writer.to_sym.should == :ntriples
  end
end

describe RDF::NTriples do
  before :all do
    @testfile = fixture_path('test.nt')
  end

  before :each do
    @reader = RDF::NTriples::Reader
    @writer = RDF::NTriples::Writer
  end

  context "when created" do
    it "should accept files" do
      lambda { @reader.new(File.open(@testfile)) }.should_not raise_error
    end

    it "should accept IO streams" do
      lambda { @reader.new(StringIO.new('')) }.should_not raise_error
    end

    it "should accept strings" do
      lambda { @reader.new('') }.should_not raise_error
    end
  end

  context "when decoding text" do
    # @see http://www.w3.org/TR/rdf-testcases/#ntrip_strings
    it "should correctly unescape ASCII characters (#x0-#x7F)" do
      (0x00..0x7F).each { |u| @reader.unescape(@writer.escape(u.chr)).should == u.chr }
    end

    # @see http://www.w3.org/TR/rdf-testcases/#ntrip_strings
    it "should correctly unescape Unicode characters (#x80-#x10FFFF)", :ruby => 1.9 do
      (0x7F..0xFFFF).to_a.sample(100).each do |u|
        begin
          next unless (c = u.chr(::Encoding::UTF_8)).valid_encoding?
          @reader.unescape(@writer.escape(c)).should == c
        rescue RangeError
        end
      end
      (0x10000..0x2FFFF).to_a.sample(100).each do |u| # NB: there's nothing much beyond U+2FFFF
        begin
          next unless (c = u.chr(::Encoding::UTF_8)).valid_encoding?
          @reader.unescape(@writer.escape(c)).should == c
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
          unescaped = unescaped.dup.force_encoding(Encoding::UTF_8) if unescaped.respond_to?(:force_encoding)
          @reader.unescape(string.dup).should == unescaped
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
          unescaped = unescaped.dup.force_encoding(Encoding::UTF_8) if unescaped.respond_to?(:force_encoding)
          @reader.unescape(string.dup).should == unescaped
        end
      end
    end
  end

  context "when encoding text to ASCII" do
    # @see http://www.w3.org/TR/rdf-testcases/#ntrip_strings
    it "should correctly escape ASCII characters (#x0-#x7F)" do
      (0x00..0x08).each { |u| @writer.escape(u.chr).should == "\\u#{u.to_s(16).upcase.rjust(4, '0')}" }
      @writer.escape(0x09.chr).should == "\\t"
      @writer.escape(0x0A.chr).should == "\\n"
      (0x0B..0x0C).each { |u| @writer.escape(u.chr).should == "\\u#{u.to_s(16).upcase.rjust(4, '0')}" }
      @writer.escape(0x0D.chr).should == "\\r"
      (0x0E..0x1F).each { |u| @writer.escape(u.chr).should == "\\u#{u.to_s(16).upcase.rjust(4, '0')}" }
      (0x20..0x21).each { |u| @writer.escape(u.chr).should == u.chr }
      @writer.escape(0x22.chr).should == "\\\""
      (0x23..0x5B).each { |u| @writer.escape(u.chr).should == u.chr }
      @writer.escape(0x5C.chr).should == "\\\\"
      (0x5D..0x7E).each { |u| @writer.escape(u.chr).should == u.chr }
      @writer.escape(0x7F.chr).should == "\\u007F"
    end

    # @see http://www.w3.org/TR/rdf-testcases/#ntrip_strings
    # @see http://en.wikipedia.org/wiki/Mapping_of_Unicode_characters#Planes
    it "should correctly escape Unicode characters (#x80-#x10FFFF)", :ruby => 1.9 do
      (0x80..0xFFFF).to_a.sample(100).each do |u|
        begin
          next unless (c = u.chr(::Encoding::UTF_8)).valid_encoding?
          @writer.escape(c).should == "\\u#{u.to_s(16).upcase.rjust(4, '0')}"
        rescue RangeError
        end
      end
      (0x10000..0x2FFFF).to_a.sample(100).each do |u| # NB: there's nothing much beyond U+2FFFF
        begin
          next unless (c = u.chr(::Encoding::UTF_8)).valid_encoding?
          @writer.escape(c).should == "\\U#{u.to_s(16).upcase.rjust(8, '0')}"
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
        string = string.dup.force_encoding(Encoding::UTF_8) if string.respond_to?(:force_encoding)
        @writer.escape(string).should == escaped
      end
    end

    # @see http://github.com/bendiken/rdf/issues/#issue/7
    it "should correctly handle RDF.rb issue #7" do
      input  = %Q(<http://openlibrary.org/b/OL3M> <http://RDVocab.info/Elements/titleProper> "Jh\xC5\xABl\xC4\x81." .)
      output = %Q(<http://openlibrary.org/b/OL3M> <http://RDVocab.info/Elements/titleProper> "Jh\\u016Bl\\u0101." .)
      writer = RDF::NTriples::Writer.new(StringIO.new, :encoding => :ascii)
      writer.format_statement(RDF::NTriples.unserialize(input)).should == output
    end
  end

  context "when encoding text to UTF-8" do
    # @see http://www.w3.org/TR/rdf-testcases/#ntrip_strings
    it "should correctly escape ASCII characters (#x0-#x7F)" do
      (0x00..0x08).each { |u| @writer.escape(u.chr).should == "\\u#{u.to_s(16).upcase.rjust(4, '0')}" }
      @writer.escape(0x09.chr).should == "\\t"
      @writer.escape(0x0A.chr).should == "\\n"
      (0x0B..0x0C).each { |u| @writer.escape(u.chr).should == "\\u#{u.to_s(16).upcase.rjust(4, '0')}" }
      @writer.escape(0x0D.chr).should == "\\r"
      (0x0E..0x1F).each { |u| @writer.escape(u.chr).should == "\\u#{u.to_s(16).upcase.rjust(4, '0')}" }
      (0x20..0x21).each { |u| @writer.escape(u.chr).should == u.chr }
      @writer.escape(0x22.chr).should == "\\\""
      (0x23..0x5B).each { |u| @writer.escape(u.chr).should == u.chr }
      @writer.escape(0x5C.chr).should == "\\\\"
      (0x5D..0x7E).each { |u| @writer.escape(u.chr).should == u.chr }
      @writer.escape(0x7F.chr).should == "\\u007F"
    end

    # @see http://www.w3.org/TR/rdf-testcases/#ntrip_strings
    # @see http://en.wikipedia.org/wiki/Mapping_of_Unicode_characters#Planes
    it "should not escape Unicode characters (#x80-#x10FFFF)", :ruby => 1.9 do
      (0x80..0xFFFF).to_a.sample(100).each do |u|
        begin
          next unless (c = u.chr(::Encoding::UTF_8)).valid_encoding?
          @writer.escape(c, Encoding::UTF_8).should == c
        rescue RangeError
        end
      end
      (0x10000..0x2FFFF).to_a.sample(100).each do |u| # NB: there's nothing much beyond U+2FFFF
        begin
          next unless (c = u.chr(::Encoding::UTF_8)).valid_encoding?
          @writer.escape(c, Encoding::UTF_8).should == c
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
        string = string.dup.force_encoding(Encoding::UTF_8) if string.respond_to?(:force_encoding)
        @writer.escape(string, Encoding::UTF_8).should == string
      end
    end
  end

  context "when reading" do
    it "should parse empty lines" do
      ["\n", "\r\n", "\r"].each do |input|
        lambda { @reader.new(input).to_a.should be_empty }.should_not raise_error
      end
    end

    it "should parse comment lines" do
      ["#\n", "# \n"].each do |input|
        lambda { @reader.new(input).to_a.should be_empty }.should_not raise_error
      end
    end

    it "should parse comment lines preceded by whitespace" do
      ["\t#\n", " #\n"].each do |input|
        lambda { @reader.new(input).to_a.should be_empty }.should_not raise_error
      end
    end

    it "should parse W3C's test data" do
      pending "lines separated by just \"\\r\" without a \"\\n\" are parsed incorrectly" do
        @reader.new(File.open(@testfile)).to_a.size.should == 30
      end
    end

    it "should parse terms" do
      bnode = @reader.unserialize('_:foobar')
      bnode.should_not be_nil
      bnode.should be_a_node
      bnode.id.should == 'foobar'

      uri = @reader.unserialize('<http://ar.to/#self>')
      uri.should_not be_nil
      uri.should be_a_uri
      uri.to_s.should == 'http://ar.to/#self'

      hello = @reader.unserialize('"Hello"')
      hello.should_not be_nil
      hello.should be_a_literal
      hello.value.should == 'Hello'

      stmt = @reader.unserialize("<http://rubygems.org/gems/rdf> <http://purl.org/dc/terms/creator> <http://ar.to/#self> .")
      stmt.should_not be_nil
      stmt.should be_a_statement
    end

    describe "with nodes" do
      it "should read two named nodes as the same node" do
        stmt = @reader.unserialize("_:a <http://www.w3.org/2002/07/owl#sameAs> _:a .")
        stmt.subject.should == stmt.object
        stmt.subject.should be_eql(stmt.object)
      end
      
      it "should read two named nodes in different instances as different nodes" do
        stmt1 = @reader.unserialize("_:a <http://www.w3.org/2002/07/owl#sameAs> _:a .")
        stmt2 = @reader.unserialize("_:a <http://www.w3.org/2002/07/owl#sameAs> _:a .")
        stmt1.subject.should == stmt2.subject
        stmt1.subject.should_not be_eql(stmt2.subject)
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
        "é"              => '<http://subj> <http://pred> "\u00E9" .',
        "€"              => '<http://subj> <http://pred> "\u20AC" .',
      }.each_pair do |contents, triple|
        specify "test #{contents}" do
          stmt = @reader.unserialize(triple)
          stmt.object.value.should == contents
        end
      end

      it "should parse long literal with escape" do
        nt = %(<http://subj> <http://pred> "\\U00015678another" .)
        if defined?(::Encoding)
          statement = @reader.unserialize(nt)
          statement.object.value.should == "\u{15678}another"
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
          statement = @reader.unserialize([nt].flatten.first)
          @writer.serialize(statement).chomp.should == [nt].flatten.last.gsub(/\s+/, " ").strip
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
            stmt1.should == stmt2
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
  end

  context "when writing" do
    before :all do
      s = RDF::URI("http://rubygems.org/gems/rdf")
      p = RDF::DC.creator
      o = RDF::URI("http://ar.to/#self")
      @stmt = RDF::Statement.new(s, p, o)
      @stmt_string = "<http://rubygems.org/gems/rdf> <http://purl.org/dc/terms/creator> <http://ar.to/#self> ."
      @graph = RDF::Graph.new
      @graph << @stmt
    end

    it "should correctly format statements" do
      @writer.new.format_statement(@stmt).should == @stmt_string
    end

    context "should correctly format blank nodes" do
      specify {@writer.new.format_node(RDF::Node.new('foobar')).should == '_:foobar'}
      specify {@writer.new.format_node(RDF::Node.new('')).should_not == '_:'}
    end

    it "should correctly format URI references" do
      @writer.new.format_uri(RDF::URI('http://rdf.rubyforge.org/')).should == '<http://rdf.rubyforge.org/>'
    end

    it "should correctly format plain literals" do
      @writer.new.format_literal(RDF::Literal.new('Hello, world!')).should == '"Hello, world!"'
    end

    it "should correctly format language-tagged literals" do
      @writer.new.format_literal(RDF::Literal.new('Hello, world!', :language => :en)).should == '"Hello, world!"@en'
    end

    it "should correctly format datatyped literals" do
      @writer.new.format_literal(RDF::Literal.new(3.1415)).should == '"3.1415"^^<http://www.w3.org/2001/XMLSchema#double>'
    end

    it "should output statements to a string buffer" do
      output = @writer.buffer { |writer| writer << @stmt }
      output.should == "#{@stmt_string}\n"
    end

    it "should dump statements to a string buffer" do
      output = StringIO.new
      @writer.dump(@graph, output)
      output.string.should == "#{@stmt_string}\n"
    end

    it "should dump arrays of statements to a string buffer" do
      output = StringIO.new
      @writer.dump(@graph.to_a, output)
      output.string.should == "#{@stmt_string}\n"
    end

    it "should dump statements to a file" do
      require 'tmpdir' # for Dir.tmpdir
      @writer.dump(@graph, filename = File.join(Dir.tmpdir, "test.nt"))
      File.read(filename).should == "#{@stmt_string}\n"
      File.unlink(filename)
    end
  end
end
