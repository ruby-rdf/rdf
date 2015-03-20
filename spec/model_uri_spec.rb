# coding: utf-8
require File.join(File.dirname(__FILE__), 'spec_helper')

describe RDF::URI do
  it "should be instantiable" do
    expect { described_class.new('http://rubygems.org/gems/rdf') }.not_to raise_error
  end

  describe ".intern" do
    before(:each) {RDF::URI.instance_variable_set(:@cache, nil)}
    it "caches URI instance" do
      RDF::URI.intern("a")
      expect(RDF::URI.instance_variable_get(:@cache)["a"]).to eq RDF::URI("a")
    end

    it "freezes instance" do
      expect(RDF::URI.intern("a")).to be_frozen
    end
  end

  describe ".parse" do
    it "creates a URI" do
      expect(RDF::URI.parse("a")).to be_a(RDF::URI)
    end
  end

  describe "#initialize" do
    it "should recognize URNs" do
      urns = %w(urn:isbn:0451450523 urn:isan:0000-0000-9E59-0000-O-0000-0000-2 urn:issn:0167-6423 urn:ietf:rfc:2648 urn:mpeg:mpeg7:schema:2001 urn:oid:2.16.840 urn:uuid:6e8bc430-9c3a-11d9-9669-0800200c9a66 urn:uci:I001+SBSi-B10000083052)
      urns.each do |urn|
        uri = described_class.new(urn)
        expect(uri).to be_a_uri
        expect(uri).to respond_to(:urn?)
        expect(uri).to be_a_urn
        expect(uri).not_to be_a_url
      end
    end

    it "should recognize URLs" do
      urls = %w(mailto:jhacker@example.org http://example.org/ ftp://example.org/)
      urls.each do |url|
        uri = described_class.new(url)
        expect(uri).to be_a_uri
        expect(uri).to respond_to(:url?)
        expect(uri).to be_a_url
        expect(uri).not_to be_a_urn
       end
    end

    it "should canonicalize input with :canonicalize" do
      allow_any_instance_of(RDF::URI).to receive(:canonicalize!).and_raise(ArgumentError)
      expect { RDF::URI("foo", :canonicalize => true) }.to raise_error(ArgumentError)
    end

    it "should validate input with :validate" do
      allow_any_instance_of(RDF::URI).to receive(:valid?).and_return(false)
      expect { RDF::URI("foo", :validate => true) }.to raise_error(ArgumentError)
    end

    context "with hash" do
      context "simple" do
        subject {
          RDF::URI.new({
            :scheme => "http",
            :user => "user",
            :password => "password",
            :host => "example.com",
            :port => 8080,
            :path => "/path",
            :query => "query=value",
            :fragment => "fragment"
          })
        }

        {
          :scheme => "http",
          :user => "user",
          :password => "password",
          :userinfo => "user:password",
          :host => "example.com",
          :port => 8080,
          :authority => "user:password@example.com:8080",
          :path => "/path",
          :query => "query=value",
          :fragment => "fragment"
        }.each do |method, value|
          its(method) {should == value}
          its("normalized_#{method}".to_sym) {should == value}
        end

        its(:value) {should == "http://user:password@example.com:8080/path?query=value#fragment"}
      end

      {
        "//user@example.com" => {:authority => "user@example.com"},
        "http://example.com/path" => {:scheme => "http", :host => "example.com", :path => "path"},
        "http:path" => {:scheme => "http", :path => "path"},
        "http://resource1" => {:scheme => "http", :host => "resource1", :path => ""}
      }.each do |value, object|
        it "creates #{value}" do
          expect(RDF::URI(object).to_s).to eq value
        end
      end
    end
  end

  describe "#freeze" do
    subject {RDF::URI("HTTP://example.com.:%38%30/%70a%74%68?a=%31#1%323").freeze}
    {
      :scheme => "HTTP",
      :user => nil,
      :password => nil,
      :userinfo => nil,
      :host => "example.com.",
      :port => 80,
      :authority => "example.com.:%38%30",
      :path => "/%70a%74%68",
      :query => "a=%31",
      :fragment => "1%323"
    }.each do |method, value|
      its(method) {should == value}
    end

    {
      :scheme => "http",
      :user => nil,
      :password => nil,
      :userinfo => nil,
      :host => "example.com",
      :port => nil,
      :authority => "example.com",
      :path => "/path",
      :query => "a=1",
      :fragment => "123"
    }.each do |method, value|
      its("normalized_#{method}".to_sym) {should == value}
    end

    its(:value) {should == "HTTP://example.com.:%38%30/%70a%74%68?a=%31#1%323"}
    it "encoding should be UTF-8" do
      expect(subject.value.encoding).to eq Encoding::UTF_8
    end
  end

  describe "#parse" do
    {
      "http://user:password@example.com:8080/path?query=value#fragment" => {
        :scheme => "http",
        :user => "user",
        :password => "password",
        :userinfo => "user:password",
        :host => "example.com",
        :port => 8080,
        :authority => "user:password@example.com:8080",
        :path => "/path",
        :query => "query=value",
        :fragment => "fragment"
      },
      #"ldap://[2001:db8::7]/c=GB?objectClass?one" => {
      #  :scheme => "ldap",
      #  :host => "[2001:db8::7]",
      #  :path => "/c=GB",
      #  :query => "objectClass?one",
      #},
      "mailto:John.Doe@example.com" => {
        :scheme => "mailto",
        :host => nil,
        :authority => nil,
        :path => "John.Doe@example.com"
      },
      "news:comp.infosystems.www.servers.unix" => {
        :scheme => "news",
        :host => nil,
        :authority => nil,
        :path => "comp.infosystems.www.servers.unix"
      },
      "tel:+1-816-555-1212" => {
        :scheme => "tel",
        :path => "+1-816-555-1212"
      },
      "urn:oasis:names:specification:docbook:dtd:xml:4.1.2" => {
        :scheme => "urn",
        :path => "oasis:names:specification:docbook:dtd:xml:4.1.2",
      }
    }.each do |uri, object|
      context uri do
        subject {RDF::URI.new.parse(uri)}
        object.each do |key, value|
          it "#{key} should == #{value.inspect}" do
            expect(subject[key]).to eq value
          end
        end
      end
    end
  end

  describe "#hash" do
    it "should have a consistent hash code" do
      hash1 = described_class.new('http://rubygems.org/gems/rdf').hash
      hash2 = described_class.new('http://rubygems.org/gems/rdf').hash
      expect(hash1).to eq hash2
    end
  end

  describe "#dup" do
    let!(:uri1) {described_class.new('http://rubygems.org/gems/rdf')}
    let!(:uri2) {uri1.dup}
    
    describe "original" do
      subject {uri1}
      its(:path) {should == uri2.path}
      it {should_not be_equal(uri2)}
      it {should be_eql(uri2)}
      it {should == uri2}
    end

    describe "with altered path" do
      subject {uri1.path = '/rdf/'; uri1}
      its(:path) {should_not == uri2.path}
      it {should_not be_equal(uri2)}
      it {should_not be_eql(uri2)}
      it {should_not == uri2}
    end
  end

  describe "#anonymous?" do
    it "should not be #anonymous?" do
      expect(described_class.new('http://example.org')).not_to be_anonymous
    end
  end

  context "validation" do
    subject {RDF::URI("http://example/for/validation")}

    describe "#valid?" do
      let(:refs) {
        %W(a d z A D Z 0 5 99 - . _ ~ \u0053 \u00D6 foo %20) +
        %W(\U00000053 Dürst)
      }
      {
        ""  => "%s",
        "and query" => "%s?%s",
        "and fragment" => "%s#%s",
        "and query and fragment" => "%s?%s#%s",
      }.each do |mod, fmt|
        it "validates IRI with authority and ipath-abempty #{mod}" do
          refs.each do |c|
            expect(RDF::URI("scheme://auth/#{fmt}" % ["", c, c])).to be_valid
            expect(RDF::URI("scheme://auth/#{fmt}" % [c, c, c])).to be_valid
            expect(RDF::URI("scheme://auth/#{fmt}" % ["#{c}/#{c}", c, c])).to be_valid
          end
        end
        it "validates IRI with path-absolute #{mod}" do
          refs.each do |c|
            expect(RDF::URI("scheme:/#{fmt}" % ["", c, c])).to be_valid
            expect(RDF::URI("scheme:/#{fmt}" % [c, c, c])).to be_valid
            expect(RDF::URI("scheme:/#{fmt}" % ["#{c}/#{c}", c, c])).to be_valid
          end
        end
        it "validates IRI with ipath-rootless #{mod}" do
          refs.each do |c|
            expect(RDF::URI("scheme:#{fmt}" % [c, c, c])).to be_valid
            expect(RDF::URI("scheme:#{fmt}" % ["#{c}/#{c}", c, c])).to be_valid
          end
        end
        it "validates IRI with ipath-empty #{mod}" do
          refs.each do |c|
            expect(RDF::URI("scheme:#{fmt}" % ["", c, c])).to be_valid
          end
        end

        it "invalidates irelative-ref with authority #{mod}" do
          refs.each do |c|
            expect(RDF::URI("//auth/#{fmt}" % [c, c, c])).not_to be_valid
          end
        end
        it "invalidates irelative-ref with authority and port #{mod}" do
          refs.each do |c|
            expect(RDF::URI("//auth:123/#{fmt}" % [c, c, c])).not_to be_valid
          end
        end
        it "invalidates irelative-ref with ipath-absolute #{mod}" do
          refs.each do |c|
            expect(RDF::URI("/#{fmt}" % [c, c, c])).not_to be_valid
            expect(RDF::URI("/#{fmt}" % ["#{c}/", c, c])).not_to be_valid
            expect(RDF::URI("/#{fmt}" % ["#{c}/#{c}", c, c])).not_to be_valid
          end
        end
        it "invalidates irelative-ref with ipath-noscheme #{mod}" do
          refs.each do |c|
            expect(RDF::URI("#{fmt}" % [c, c, c])).not_to be_valid
            expect(RDF::URI("#{fmt}" % ["#{c}/", c, c])).not_to be_valid
            expect(RDF::URI("#{fmt}" % ["#{c}/#{c}", c, c])).not_to be_valid
          end
        end
        it "invalidates irelative-ref with ipath-empty #{mod}" do
          refs.each do |c|
            expect(RDF::URI("#{fmt}" % ["", c, c])).not_to be_valid
          end
        end
      end
      
      [" ", "<", ">", "'" '"'].each do |c|
        it "does not validate <http://example/#{c}>" do
          expect(RDF::URI("http://example/#{c}")).not_to be_valid
        end
      end
    end

    describe "#invalid?" do
      it "is invalid if not valid" do
        expect(subject).to receive(:valid?).and_return(false)
        expect(subject).to be_invalid
      end
    end

    describe "#validate" do
      it "raises ArgumentError if not valid" do
        expect(subject).to receive(:valid?).and_return(false)
        expect { subject.validate }.to raise_error(ArgumentError)
      end
    end

    describe "#validate!" do
      it "raises ArgumentError if not valid" do
        expect(subject).to receive(:valid?).and_return(false)
        expect { subject.validate! }.to raise_error(ArgumentError)
      end
    end
  end

  context "c14n" do
    {
      #"syntax-based normalization" => [
      #  "eXAMPLE://a/./b/../b/%63/%7bfoo%7d/ros%C3%A9",
      #  "example://a/b/c/%7Bfoo%7D/ros&#xE9;"
      #],
      #"syntax-based normalization (addressable)" => [
      #  "eXAMPLE://a/./b/../b/%63/%7bfoo%7d/ros%C3%A9",
      #  "example://a/b/c/%7Bfoo%7D/ros%C3%A9"
      #],
      #"case normalization(1)" => [
      #  "http://example.com/%e1%cf",
      #  "http://example.com/%E1%CF"
      #],
      "case normalization(2)" => [
        "http://eXaMpLe.com/",
        "http://example.com/"
      ],
      "percent-encoding normalization(1)" => [
        "http://example.com/%7euser",
        "http://example.com/~user"
      ],
      "percent-encoding normalization(2)" => [
        "http://example.com/%7Euser",
        "http://example.com/~user"
      ],
      "path-segment normalization(1)" => [
        "http://example.com/./foo",
        "http://example.com/foo/"
      ],
      "path-segment normalization(1)" => [
        "http://example.com/foo/bar/..",
        "http://example.com/foo/"
      ],
      "parent of root" => [
        "http://example.com/..",
        "http://example.com/"
      ],
      "parent of parent of root" => [
        "http://example.com/../..",
        "http://example.com/"
      ],
      "parent of odd path" => [
        "http://example.com/path(/..",
        "http://example.com/"
      ],
      "parent of odd path (2)" => [
        "http://example.com/(path)/..",
        "http://example.com/"
      ],
      "parent of odd path (3)" => [
        "http://example.com/path(/../",
        "http://example.com/"
      ],
      "path with dot segments" => [
        "/a/b/c/./../../g",
        "/a/g"
      ],
      "mid/content=5/../6" => [
        "mid/content=5/../6",
        "mid/6"
      ],
      "multiple slashes" => [
        "http://www.example.com///../",
        "http://www.example.com/"
      ],
      "preserve -.~" => [
        "http://www.example.com/foo-bar.baz~",
        "http://www.example.com/foo-bar.baz~",
      ],
      "embedded spaces" => [
        "http://www.example.com/path with spaces",
        "http://www.example.com/path%20with%20spaces"
      ],
      "file with embedded spaces" => [
        "file:///path/to/file with spaces.txt",
        "file:/path/to/file%20with%20spaces.txt"
      ],
    }.each do |name, (input, output)|
      it "#canonicalize #{name}" do
        u1 = RDF::URI(input)
        u2 = RDF::URI(output)
        expect(u1.canonicalize.to_s).to eq u2.to_s
        expect(u1).to eq u1
      end
    end
    it "#canonicalize! alters resource", :ruby => "1.9" do
      u1 = RDF::URI("eXAMPLE:example.com/foo")
      u2 = RDF::URI("example:example.com/foo")
      expect(u1.canonicalize!.to_s).to eq u2.to_s
      expect(u1).to eq u2
    end
  end

  describe "#/" do
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
        expect((RDF::URI.new(input[0]) / input[1]).to_s).to eq result
        expect((RDF::URI.new(input[0]) / RDF::URI.new(input[1])).to_s).to eq result unless input[1][0,1] == ':'
      end
    end

    it "should raise an ArgumentError when receiving an absolute URI as a fragment" do
      expect { RDF::URI.new('http://example.org') / RDF::URI.new('http://example.com') }.to raise_error ArgumentError
    end
  end

  describe "#+" do
    {
      %w(http://foo/ a) => "http://foo/a",
      %w(http://foo/ /a) => "http://foo//a",
      %w(http://foo/ #a) => "http://foo/#a",

      %w(urn:isbn :0451450523) => "urn:isbn:0451450523",
      %w(urn:isbn 0451450523) => "urn:isbn0451450523",

      %w(http://example.org/test test) => "http://example.org/testtest",
    }.each_pair do |input, result|
      it "should create <#{result}> from <#{input[0]}> and '#{input[1]}'" do
        expect((RDF::URI.new(input[0]) + input[1]).to_s).to eq result
        expect((RDF::URI.new(input[0]) + RDF::URI.new(input[1])).to_s).to eq result unless input[1][0,1] == ':'
      end
    end
  end

  describe "#join" do
    subject {RDF::URI.new("http://example.org")}
    it "appends another URI" do
      expect(subject.join(RDF::URI.new("foo#bar")).to_s).to eq "http://example.org/foo#bar"
    end

    {
      ['', 'a'] => "<a>",
      ['', 'http://foo/bar#'] => "<http://foo/bar#>",
      ['', 'http://resource1'] => "<http://resource1>",
      
      %w(http://example.org foo) => "<http://example.org/foo>",
      %w(http://example.org foo#bar) => "<http://example.org/foo#bar>",
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

    }.each_pair do |(lhs, rhs), result|
      it "creates #{result} from <#{lhs}> and '#{rhs}'" do
        expect(RDF::URI.new(lhs).join(rhs.to_s).to_base).to eq result
      end
    end
  end

  describe "#hier?" do
    {
      "http://example/"               => true,
      "mailto:gregg@greggkellogg.net" => false,
      "urn:isbn:12345"                => false
    }.each do |uri, is_hier|
      it uri do
        expect(described_class.new(uri).hier?).to eq is_hier
      end
    end
  end

  describe "#root?" do
    {
      "http://example/"               => true,
      "http://example/foo"            => false,
      "mailto:gregg@greggkellogg.net" => true,
      "urn:isbn:12345"                => true
    }.each do |uri, is_hier|
      it uri do
        expect(described_class.new(uri).root?).to eq is_hier
      end
    end
  end

  describe "#root" do
    {
      "http://example/"                       => "http://example/",
      "http://example/foo"                    => "http://example/",
      'http://rubygems.org/gems/rdf'          => 'http://rubygems.org/',
      "mailto:gregg@greggkellogg.net"         => "mailto:gregg@greggkellogg.net",
      "urn:isbn:12345"                        => "urn:isbn:12345"
    }.each do |uri, root|
      it uri do
        expect(described_class.new(uri).root).to be_a_uri
        expect(described_class.new(uri).root).to eq root
      end
    end
  end

  describe "#parent" do
    {
      "http://example/"                       => nil,
      "http://example/foo"                    => "http://example/",
      "http://example/foo/bar"                => "http://example/foo/",
      'http://rubygems.org/gems/rdf'          => 'http://rubygems.org/gems/',
      "mailto:gregg@greggkellogg.net"         => nil,
      "urn:isbn:12345"                        => nil
    }.each do |uri, parent|
      it uri do
        if parent
          expect(described_class.new(uri).parent).to be_a_uri
          expect(described_class.new(uri).parent).to eq parent
        else
          expect(described_class.new(uri).parent).to be_nil
        end
      end
    end
  end

  describe "#query" do
    {
      "?one=1&two=2&three=3" => "one=1&two=2&three=3",
      "?one=two&one=three" => "one=two&one=three",
      "mailto:?to=addr1@an.example,addr2@an.example" => "to=addr1@an.example,addr2@an.example",
      "http://example/" => nil,
      "http://example/?" => "",
      "HTTP://example.com.:%38%30/%70a%74%68?a=%31#1%323" => "a=%31"
    }.each do |uri, result|
      it uri do
        if result
          expect(described_class.new(uri).query).to eq result
        else
          expect(described_class.new(uri).query).to be_nil
        end
      end
    end
  end

  describe "#query_values" do
    {
      "?one=1&two=2&three=3" => {"one" => "1", "two" => "2", "three" => "3"},
      "?one=two&one=three" => {"one" => %w(two three)},
      "mailto:?to=addr1@an.example,addr2@an.example" => {"to" => "addr1@an.example,addr2@an.example"},
      "http://example/" => nil,
      "http://example/?" => {},
      "HTTP://example.com.:%38%30/%70a%74%68?a=%31#1%323" => {"a" => "1"},
      "?one[two][three]=four" => {"one[two][three]" => "four"},
      "?one.two.three=four" => {"one.two.three" => "four"},
      "?one[two][three]=four&one[two][five]=six" => {"one[two][three]" => "four", "one[two][five]" => "six"},
      "?one=two&one=three&one=four" => {'one' => ['two', 'three', 'four']},
    }.each do |uri, result|
      it uri do
        if result
          expect(described_class.new(uri).query_values).to eq result
        else
          expect(described_class.new(uri).query_values).to be_nil
        end
      end
    end

    context "Array" do
      {
        "?one=two&one=three" => [['one', 'two'], ['one', 'three']],
        "http://example/?" => [],
        "?one[two][three]=four" => [["one[two][three]", "four"]],
        "?one.two.three=four" => [["one.two.three", "four"]],
        "?one[two][three]=four&one[two][five]=six" => [["one[two][three]", "four"], ["one[two][five]", "six"]],
        "?one=two&one=three&one=four" => [['one', 'two'], ['one', 'three'], ['one', 'four']],
      }.each do |uri, result|
        it uri do
          expect(described_class.new(uri).query_values(Array)).to eq result
        end
      end
    end
  end

  describe "#query_values=" do
    {
      "" => {},
      "a=a" => {:a => "a"},
      "a" => {:a => nil},
      "a=a&b=c&b=d&b=e" => {:a => "a", :b => ["c", "d", "e"]},
      nil => nil,
    }.each do |result, values|
      it values do
        u = described_class.new("")
        u.query_values = values
        if result
          expect(u.query).to eq result
        else
          expect(u.query).to be_nil
        end
      end
    end
  end

  describe "#absolute?" do
    {
      "" => false,
      "http://example.org/foo" => true,
      "//example.org/foo" => false,
      "foo" => false,
    }.each do |uri, value|
      it "<#{uri}>: #{value}" do
        if value
          expect(described_class.new(uri)).to be_absolute
          expect(described_class.new(uri)).not_to be_relative
        else
          expect(described_class.new(uri)).not_to be_absolute
          expect(described_class.new(uri)).to be_relative
        end
      end
    end
  end

  describe "#relativize" do
    {
      "prefix with #" => ["http://example.com/#", "http://example.com/#foo", "foo"],
      "prefix with /" => ["http://example.com/", "http://example.com/#foo", "#foo"],
      "prefix without / or #" => ["http://example.com/f", "http://example.com/foo", "http://example.com/foo"],
    }.each do |name, (base_uri,orig,result)|
      it "<#{base_uri}> + <#{orig}>: <#{result}>" do
        expect(described_class.new(orig).relativize(base_uri)).to eq result
      end
    end
  end

  describe "#request_uri" do
    {
      "" => "/",
      "ftp://ftp.is.co.za/rfc/rfc1808.txt" => nil,
      "http://www.ietf.org/rfc/rfc2396.txt" => "/rfc/rfc2396.txt",
      "ldap://[2001:db8::7]/c=GB?objectClass?one" => nil,
      "mailto:John.Doe@example.com" => nil,
      "http://example.com" => "/",
      "http://www.w3.org/pub/WWW/TheProject.html" => "/pub/WWW/TheProject.html",
    }.each do |uri, result|
      it uri do
        if result
          expect(described_class.new(uri).request_uri).to eq result
        else
          expect(described_class.new(uri).request_uri).to be_nil
        end
      end
    end
  end

  context "Examples" do
    it "needs specs for documentation examples"
  end
end
