# coding: utf-8
require File.join(File.dirname(__FILE__), 'spec_helper')

describe RDF::URI do
  before :each do
    @new = Proc.new { |*args| RDF::URI.new(*args) }
  end

  it "should be instantiable" do
    lambda { @new.call('http://rdf.rubyforge.org/') }.should_not raise_error
  end

  it "should recognize URNs" do
    urns = %w(urn:isbn:0451450523 urn:isan:0000-0000-9E59-0000-O-0000-0000-2 urn:issn:0167-6423 urn:ietf:rfc:2648 urn:mpeg:mpeg7:schema:2001 urn:oid:2.16.840 urn:uuid:6e8bc430-9c3a-11d9-9669-0800200c9a66 urn:uci:I001+SBSi-B10000083052)
    urns.each do |urn|
      uri = @new.call(urn)
      uri.should be_a_uri
      uri.should respond_to(:urn?)
      uri.should be_a_urn
      uri.should_not be_a_url
    end
  end

  it "should recognize URLs" do
    urls = %w(mailto:jhacker@example.org http://example.org/ ftp://example.org/)
    urls.each do |url|
      uri = @new.call(url)
      uri.should be_a_uri
      uri.should respond_to(:url?)
      uri.should be_a_url
      uri.should_not be_a_urn
    end
  end

  it "should return the root URI" do
    uri = @new.call('http://rdf.rubyforge.org/RDF/URI.html')
    uri.should respond_to(:root)
    uri.root.should be_a_uri
    uri.root.should == @new.call('http://rdf.rubyforge.org/')
  end

  it "should find the parent URI" do
    uri = @new.call('http://rdf.rubyforge.org/RDF/URI.html')
    uri.should respond_to(:parent)
    uri.parent.should be_a_uri
    uri.parent.should == @new.call('http://rdf.rubyforge.org/RDF/')
    uri.parent.parent.should == @new.call('http://rdf.rubyforge.org/')
    uri.parent.parent.parent.should be_nil
  end

  it "should have a consistent hash code" do
    hash1 = @new.call('http://rdf.rubyforge.org/').hash
    hash2 = @new.call('http://rdf.rubyforge.org/').hash
    hash1.should == hash2
  end

  it "should be duplicable" do
    url  = Addressable::URI.parse('http://rdf.rubyforge.org/')
    uri2 = (uri1 = @new.call(url)).dup

    uri1.should_not be_equal(uri2)
    uri1.should be_eql(uri2)
    uri1.should == uri2

    url.path = '/rdf/'
    uri1.should_not be_equal(uri2)
    uri1.should_not be_eql(uri2)
    uri1.should_not == uri2
  end

  it "should not be #anonymous?" do
    @new.call('http://example.org').should_not be_anonymous
  end

  context "validation" do
    subject {RDF::URI("http://example/for/validation")}

    describe "#valid?" do
      let(:refs) {
        %W(
          a d z A D Z 0 5 99 - . _ ~ \u0053 \u00D6 \U00000053
          foo Dürst %20
        )
      }
      {
        ""  => "%s",
        "and query" => "%s?%s",
        "and fragment" => "%s#%s",
        "and query and fragment" => "%s?%s#%s",
      }.each do |mod, fmt|
        it "validates IRI with authority and abempty #{mod}" do
          refs.each do |c|
            RDF::URI("scheme:auth//#{fmt}" % ["", c, c]).should be_valid
            RDF::URI("scheme:auth//#{fmt}" % [c, c, c]).should be_valid
            RDF::URI("scheme:auth//#{fmt}" % ["#{c}/#{c}", c, c]).should be_valid
          end
        end
        it "validates IRI with ipath-absolute #{mod}" do
          refs.each do |c|
            RDF::URI("scheme:/#{fmt}" % ["", c, c]).should be_valid
            RDF::URI("scheme:/#{fmt}" % [c, c, c]).should be_valid
            RDF::URI("scheme:/#{fmt}" % ["#{c}/#{c}", c, c]).should be_valid
          end
        end
        it "validates IRI with ipath-rootless #{mod}" do
          refs.each do |c|
            RDF::URI("scheme:#{fmt}" % [c, c, c]).should be_valid
            RDF::URI("scheme:#{fmt}" % ["#{c}/#{c}", c, c]).should be_valid
          end
        end
        it "validates IRI with ipath-empty #{mod}", :pending => "Addressable bug" do
          refs.each do |c|
            RDF::URI("scheme:#{fmt}" % ["", c, c]).should be_valid
          end
        end

        it "validates irelative-ref with authority #{mod}" do
          refs.each do |c|
            RDF::URI("//auth/#{fmt}" % [c, c, c]).should be_valid
          end
        end
        it "validates irelative-ref with ipath-absolute #{mod}" do
          refs.each do |c|
            RDF::URI("/#{fmt}" % [c, c, c]).should be_valid
            RDF::URI("/#{fmt}" % ["#{c}/", c, c]).should be_valid
            RDF::URI("/#{fmt}" % ["#{c}/#{c}", c, c]).should be_valid
          end
        end
        it "validates irelative-ref with ipath-noscheme #{mod}" do
          refs.each do |c|
            RDF::URI("#{fmt}" % [c, c, c]).should be_valid
            RDF::URI("#{fmt}" % ["#{c}/", c, c]).should be_valid
            RDF::URI("#{fmt}" % ["#{c}/#{c}", c, c]).should be_valid
          end
        end
        it "validates irelative-ref with ipath-empty #{mod}" do
          refs.each do |c|
            RDF::URI("#{fmt}" % ["", c, c]).should be_valid
          end
        end
      end
    end

    describe "#invalid?" do
      it "is invalid if not valid" do
        subject.should_receive(:valid?).and_return(false)
        subject.should be_invalid
      end
    end

    describe "#validate" do
      it "raises ArgumentError if not valid" do
        subject.should_receive(:valid?).and_return(false)
        lambda { subject.validate }.should raise_error(ArgumentError)
      end
    end

    describe "#validate!" do
      it "raises ArgumentError if not valid" do
        subject.should_receive(:valid?).and_return(false)
        lambda { subject.validate! }.should raise_error(ArgumentError)
      end
    end
  end

  context "normalization" do
    {
      "syntax-based normalization" => [
        "eXAMPLE://a/./b/../b/%63/%7bfoo%7d/ros%C3%A9",
        "example://a/b/c/%7Bfoo%7D/ros&#xE9;",
        true
      ],
      "syntax-based normalization (addressable)" => [
        "eXAMPLE://a/./b/../b/%63/%7bfoo%7d/ros%C3%A9",
        "example://a/b/c/%7Bfoo%7D/ros%C3%A9",
        true
      ],
      "case normalization(1)" => [
        "http://example.com/%e1%cf",
        "http://example.com/%E1%CF",
        true
      ],
      "case normalization(2)" => [
        "http://eXaMpLe.com/",
        "http://example.com/",
        true
      ],
      "percent-encoding normalization(1)" => [
        "http://example.com/%7euser",
        "http://example.com/~user",
        true
      ],
      "percent-encoding normalization(2)" => [
        "http://example.com/%7Euser",
        "http://example.com/~user",
        true
      ],
      "path-segment normalization(1)" => [
        "http://example.com/./foo",
        "http://example.com/foo/",
        true
      ],
      "path-segment normalization(1)" => [
        "http://example.com/foo/bar/..",
        "http://example.com/foo/",
        true
      ],
    }.each do |name, (input, output, pending)|
      let(:u1) {RDF::URI(input)}
      let(:u2) {RDF::URI(output)}
      it "#canonicalize #{name}", :pending => (pending ? "Addressable" : false) do
        u1.canonicalize.to_s.should == u2.to_s
        u1.should == u1
      end
    end
    it "#canonicalize! alters resource" do
      u1 = RDF::URI("eXAMPLE:example.com/foo")
      u2 = RDF::URI("example:example.com/foo")
      u1.canonicalize!.to_s.should == u2.to_s
      u1.should == u2
    end
  end


  context "using the smart separator (/)" do
    {
      # #!! means that I'm not sure I like the semantics, but they are cases for
      # arguably invalid input, probably without 'correct' answers.

      %w(http://foo a) => "http://foo/a",
      %w(http://foo /a) => "http://foo/a",
      %w(http://foo #a) => "http://foo#a",

      %w(http://foo/ a) => "http://foo/a",
      %w(http://foo/ /a) => "http://foo/a",
      %w(http://foo/ #a) => "http://foo#a", #!!

      %w(http://foo# a) => "http://foo#a",
      %w(http://foo# /a) => "http://foo/a", #!!
      %w(http://foo# #a) => "http://foo#a",

      %w(http://foo/bar a) => "http://foo/bar/a",
      %w(http://foo/bar /a) => "http://foo/bar/a",
      %w(http://foo/bar #a) => "http://foo/bar#a",

      %w(http://foo/bar/ a) => "http://foo/bar/a",
      %w(http://foo/bar/ /a) => "http://foo/bar/a",
      %w(http://foo/bar/ #a) => "http://foo/bar#a", #!!

      %w(http://foo/bar# a) => "http://foo/bar#a",
      %w(http://foo/bar# /a) => "http://foo/bar/a", #!!
      %w(http://foo/bar# #a) => "http://foo/bar#a",

      %w(urn:isbn: 0451450523) => "urn:isbn:0451450523",
      %w(urn:isbn: :0451450523) => "urn:isbn:0451450523",

      %w(urn:isbn 0451450523) => "urn:isbn:0451450523",
      %w(urn:isbn :0451450523) => "urn:isbn:0451450523",
    }.each_pair do |input, result|
      it "should create <#{result}> from <#{input[0]}> and '#{input[1]}'" do
        (RDF::URI.new(input[0]) / input[1]).to_s.should == result
        (RDF::URI.new(input[0]) / RDF::URI.new(input[1])).to_s.should == result unless input[1][0,1] == ':'
      end
    end

    it "should raise an ArgumentError when receiving an absolute URI as a fragment" do
      lambda { RDF::URI.new('http://example.org') / RDF::URI.new('http://example.com') }.should raise_error ArgumentError
    end
  end

  context "using concatenation (#+)" do
    {
      %w(http://foo/ a) => "http://foo/a",
      %w(http://foo/ /a) => "http://foo//a",
      %w(http://foo/ #a) => "http://foo/#a",

      %w(urn:isbn :0451450523) => "urn:isbn:0451450523",
      %w(urn:isbn 0451450523) => "urn:isbn0451450523",

      %w(http://example.org/test test) => "http://example.org/testtest",
    }.each_pair do |input, result|
      it "should create <#{result}> from <#{input[0]}> and '#{input[1]}'" do
        (RDF::URI.new(input[0]) + input[1]).to_s.should == result
        (RDF::URI.new(input[0]) + RDF::URI.new(input[1])).to_s.should == result unless input[1][0,1] == ':'
      end
    end
  end

  context "using normalized merging (#join)" do

    before :all do
      @writer = RDF::Writer.for(:ntriples)
    end

    before :each do
      @subject = RDF::URI.new("http://example.org")
    end

    it "appends fragment to uri" do
      @subject.join("foo").to_s.should == "http://example.org/foo"
    end

    it "appends another fragment" do
      @subject.join("foo#bar").to_s.should == "http://example.org/foo#bar"
    end

    it "appends another URI" do
      @subject.join(RDF::URI.new("foo#bar")).to_s.should == "http://example.org/foo#bar"
    end

    {
      %w(http://foo ) =>  "<http://foo>",
      %w(http://foo a) => "<http://foo/a>",
      %w(http://foo /a) => "<http://foo/a>",
      %w(http://foo #a) => "<http://foo#a>",

      %w(http://foo/ ) =>  "<http://foo/>",
      %w(http://foo/ a) => "<http://foo/a>",
      %w(http://foo/ /a) => "<http://foo/a>",
      %w(http://foo/ #a) => "<http://foo/#a>",

      %w(http://foo# ) =>  "<http://foo#>",
      %w(http://foo# a) => "<http://foo/a>",
      %w(http://foo# /a) => "<http://foo/a>",
      %w(http://foo# #a) => "<http://foo#a>",

      %w(http://foo/bar ) =>  "<http://foo/bar>",
      %w(http://foo/bar a) => "<http://foo/a>",
      %w(http://foo/bar /a) => "<http://foo/a>",
      %w(http://foo/bar #a) => "<http://foo/bar#a>",

      %w(http://foo/bar/ ) =>  "<http://foo/bar/>",
      %w(http://foo/bar/ a) => "<http://foo/bar/a>",
      %w(http://foo/bar/ /a) => "<http://foo/a>",
      %w(http://foo/bar/ #a) => "<http://foo/bar/#a>",

      %w(http://foo/bar# ) =>  "<http://foo/bar#>",
      %w(http://foo/bar# a) => "<http://foo/a>",
      %w(http://foo/bar# /a) => "<http://foo/a>",
      %w(http://foo/bar# #a) => "<http://foo/bar#a>",

    }.each_pair do |input, result|
      it "creates #{result} from <#{input[0]}> and '#{input[1]}'" do
        @writer.serialize(RDF::URI.new(input[0]).join(input[1].to_s)).should == result
      end
    end
  end
end
