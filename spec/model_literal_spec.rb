# coding: utf-8
require File.join(File.dirname(__FILE__), 'spec_helper')
require 'rdf/spec/literal'
require 'rdf/xsd'

describe RDF::Literal do
  XSD = RDF::XSD

  def self.literal(selector)
    case selector
    when :empty       then [''.freeze]
    when :plain       then ['Hello'.freeze]
    when :empty_lang  then [''.freeze, {language: :en}]
    when :plain_lang  then ['Hello'.freeze, {language: :en}]
    # langString language: must not contain spaces
    when :wrong_lang  then ['WrongLang'.freeze, {language: "en f"}]
    # langString language: must be non-empty valid language
    when :unset_lang  then ['NoLanguage'.freeze, {datatype: RDF::langString}]
    when :string      then ['String'.freeze, {datatype: RDF::XSD.string}]
    when :false       then [false]
    when :true        then [true]
    when :int         then [123]
    when :long        then [9223372036854775807]
    when :double      then [3.1415]
    when :date        then [Date.new(2010)]
    when :datetime    then [DateTime.new(2011)]
    when :time        then ['01:02:03Z', {datatype: RDF::XSD.time}]
    else
      raise("unexpected literal: :#{selector}")
    end
  end

  def self.literals(*selector)
    selector.inject([]) do |ary, sel|
      ary += case sel
      when :all_simple        then [:empty, :plain, :string].map {|s| literal(s)}
      when :all_plain_lang    then [:empty_lang, :plain_lang].map {|s| literal(s)}
      when :all_native        then [:false, :true, :int, :long, :double, :time, :date, :datetime].map {|s| literal(s)}
      when :all_invalid_lang  then [:wrong_lang, :unset_lang].map {|s| literal(s)}
      when :all_plain         then literals(:all_simple, :all_plain_lang)
      else                         literals(:all_plain, :all_native)
      end
    end
  end

  describe "new" do
    it "instantiates empty string" do
      expect { RDF::Literal.new('') }.not_to raise_error
    end

    it "instantiates empty string with language" do
      expect { RDF::Literal.new('', language: :en) }.not_to raise_error
    end

    it "instantiates from native datatype" do
      expect { RDF::Literal.new(123) }.not_to raise_error
    end

    it "encodes as utf-8" do
      ascii = "foo".encode(Encoding::ASCII)
      expect(RDF::Literal.new(ascii).to_s.encoding).to eq Encoding::UTF_8
    end

    describe "c18n" do
      it "normalizes language to lower-case" do
        expect(RDF::Literal.new('Upper', language: :EN, canonicalize: true).language).to eq :en
      end

      it "supports sub-taged language specification" do
        expect(RDF::Literal.new('Hi', language: :"en-us", canonicalize: true).language).to eq :"en-us"
      end

      # Native representations
      [Date.today, Time.now, DateTime.now].each do |v|
        it "creates a valid literal from #{v.inspect}" do
          expect(RDF::Literal(v, canonicalize: true)).to be_valid
        end
      end
    end
  end

  describe "#plain?" do
    literals(:all_plain).each do |args|
      it "returns true for #{args.inspect}" do
        options = args.last.is_a?(Hash) ? args.pop : {}
        expect(RDF::Literal.new(*args, **options)).to be_plain
      end
    end

    (literals(:all) - literals(:all_plain)).each do |args|
      it "returns false for #{args.inspect}" do
        options = args.last.is_a?(Hash) ? args.pop : {}
        expect(RDF::Literal.new(*args, **options)).not_to be_plain
      end
    end
  end

  describe "#simple?" do
    literals(:all_simple).each do |args|
      it "returns true for #{args.inspect}" do
        options = args.last.is_a?(Hash) ? args.pop : {}
        expect(RDF::Literal.new(*args, **options)).to be_simple
      end
    end

    (literals(:all) - literals(:all_simple)).each do |args|
      it "returns false for #{args.inspect}" do
        options = args.last.is_a?(Hash) ? args.pop : {}
        expect(RDF::Literal.new(*args, **options)).not_to be_simple
      end
    end
  end

  describe "#language" do
    literals(:all_plain_lang).each do |args|
      it "returns language for #{args.inspect}" do
        options = args.last.is_a?(Hash) ? args.pop : {}
        expect(RDF::Literal.new(*args, **options).language).to eq :en
      end
    end

    (literals(:all) - literals(:all_plain_lang)).each do |args|
      it "returns nil for #{args.inspect}" do
        options = args.last.is_a?(Hash) ? args.pop : {}
        expect(RDF::Literal.new(*args, **options).language).to be_nil
      end
    end
  end

  describe "#datatype" do
    literals(:all_simple).each do |args|
      it "returns xsd:string for #{args.inspect}" do
        options = args.last.is_a?(Hash) ? args.pop : {}
        literal = RDF::Literal.new(*args, **options)
        expect(literal.datatype).to eq RDF::XSD.string
      end
    end

    {
      123 => "integer",
      true => "boolean",
      false => "boolean",
      9223372036854775807 => "integer",
      3.1415 => "double",
      Date.new(2010) => "date",
      DateTime.new(2011) => "dateTime",
      Time.parse("01:02:03Z") => "dateTime"
    }.each_pair do |value, type|
      it "returns xsd.#{type} for #{value.inspect} #{value.class}" do
        expect(RDF::Literal.new(value).datatype).to eq XSD[type]
      end
    end
  end

  describe "#typed?" do
    literals(:all_simple, :all_plain_lang).each do |args|
      it "returns false for #{args.inspect}" do
        options = args.last.is_a?(Hash) ? args.pop : {}
        expect(RDF::Literal.new(*args, **options)).not_to be_typed
      end
    end

    (literals(:all) - literals(:all_simple, :all_plain_lang)).each do |args|
      it "returns true for #{args.inspect}" do
        options = args.last.is_a?(Hash) ? args.pop : {}
        expect(RDF::Literal.new(*args, **options)).to be_typed
      end
    end
  end

  it "#start_with?" do
    expect(RDF::Literal('foo')).to be_start_with('foo')
    expect(RDF::Literal('bar')).not_to be_start_with('foo')
  end

  describe "#==" do
    literals(:all_plain).each do |args|
      it "returns true for #{args.inspect}" do
        options = args.last.is_a?(Hash) ? args.pop : {}
        expect(RDF::Literal.new(*args, **options)).to eq RDF::Literal.new(*args, **options)
      end
    end

    literals(:all_simple).each do |args|
      it "returns true for value of #{args.inspect}" do
        options = args.last.is_a?(Hash) ? args.pop : {}
        expect(RDF::Literal.new(*args, **options)).to eq RDF::Literal.new(*args, **options).value
      end
    end

    literals(:all_plain_lang).each do |args|
      it "returns false for value of #{args.inspect}" do
        options = args.last.is_a?(Hash) ? args.pop : {}
        expect(RDF::Literal.new(*args, **options)).not_to eq RDF::Literal.new(*args, **options).value
      end
    end

    literals(:all_native).each do |args|
      it "returns true for #{args.inspect}" do
        options = args.last.is_a?(Hash) ? args.pop : {}
        expect(RDF::Literal.new(*args, **options)).to eq RDF::Literal.new(*args, **options)
      end

      it "returns true for value of #{args.inspect}" do
        #literal = RDF::Literal.new(*args)
        #expect(literal).to eq literal.value # FIXME: fails on xsd:date, xsd:time, and xsd:dateTime
      end
    end
    it "returns true for language taged literals differring in case" do
      l1 = RDF::Literal.new("foo", language: :en)
      l2 = RDF::Literal.new("foo", language: :EN)
      expect(l1).to eq l2
    end
  end

  describe "#to_s" do
    literals(:all_plain).each do |args|
      it "returns value for #{args.inspect}" do
        options = args.last.is_a?(Hash) ? args.pop : {}
        literal = RDF::Literal.new(*args, **options)
        expect(literal.to_s).to eql(literal.value)
      end
    end

    {
      literal(:int)      => "123",
      literal(:true)     => "true",
      literal(:false)    => "false",
      literal(:long)     => "9223372036854775807",
      literal(:double)   => "3.1415",
      literal(:date)     => "2010-01-01",
      literal(:datetime) => "2011-01-01T00:00:00Z",
      literal(:time)     => "01:02:03Z"
    }.each_pair do |args, rep|
      it "returns #{rep} for #{args.inspect}" do
        options = args.last.is_a?(Hash) ? args.pop : {}
        literal = RDF::Literal.new(*args, **options)
        expect(literal.to_s).to eql(rep)
      end
    end
  end

  # to_str is implemented for stringy xsd types, but not others
  describe "#to_str" do
    literals(:all_plain).each do |args|
      it "is implemented for #{args.inspect}" do
        options = args.last.is_a?(Hash) ? args.pop : {}
        expect(RDF::Literal.new(*args, **options)).to respond_to :to_str
      end

      it "matches #to_s for #{args.inspect}" do
        options = args.last.is_a?(Hash) ? args.pop : {}
        literal = RDF::Literal.new(*args, **options)
        expect(literal.to_str).to eq literal.to_s
      end
    end

    (literals(:all) - literals(:all_plain)).each do |args|
      options = args.last.is_a?(Hash) ? args.pop : {}
      it "is not implemented for #{args.inspect}" do
        expect(RDF::Literal.new(*args, **options)).not_to respond_to :to_str
      end

      it "raises NoMethodError for #{args.inspect}" do
        expect { RDF::Literal.new(*args, **options).to_str }.to raise_error NoMethodError
      end
    end
  end

  describe "#object" do
    literals(:all_plain).each do |args|
      it "returns value for #{args.inspect}" do
        options = args.last.is_a?(Hash) ? args.pop : {}
        literal = RDF::Literal.new(*args, **options)
        expect(literal.object).to eql(literal.value)
      end
    end

    {
      literal(:int)      => 123,
      literal(:true)     => true,
      literal(:false)    => false,
      literal(:long)     => 9223372036854775807,
      literal(:double)   => 3.1415,
      literal(:date)     => ::Date.new(2010),
      literal(:datetime) => ::DateTime.new(2011),
      # This is problematic when date changes between local testing location and UTC
      #literal(:time)     => ::DateTime.parse('01:02:03Z')
    }.each_pair do |args, value|
      it "returns object for #{args.inspect}" do
        options = args.last.is_a?(Hash) ? args.pop : {}
        literal = RDF::Literal.new(*args, **options)
        expect(literal.object).to eql(value)
      end
    end
  end

  describe "#anonymous?" do
    it "returns false" do
      expect(RDF::Literal.new("")).not_to be_anonymous
    end
  end

  describe "#compatible?" do
    {
      %("abc") => {
        %("b") => true,
        %("b^^<http://www.w3.org/2001/XMLSchema#string>") => true,
        %("b"@ja) => false,
        %("b"@en) => false,
        %(<a>) => false,
        %(_:a) => false,
      },
      %("abc^^<http://www.w3.org/2001/XMLSchema#string>") => {
        %("b") => true,
        %("b^^<http://www.w3.org/2001/XMLSchema#string>") => true,
        %("b"@en) => false
      },
      %("abc"@en) => {
        %("b") => true,
        %("b^^<http://www.w3.org/2001/XMLSchema#string>") => true,
        %("b"@en) => true,
        %("b"@ja) => false
      },
      %("abc"@fr) => {
        %("b"@ja) => false
      },
    }.each do |l1, props|
      props.each do |l2, res|
        it "#{l1} should #{'not ' unless res}be compatible with #{l2}" do
          if res
            expect(RDF::NTriples::Reader.parse_object l1).to be_compatible(RDF::NTriples::Reader.parse_object l2)
          else
            expect(RDF::NTriples::Reader.parse_object l1).not_to be_compatible(RDF::NTriples::Reader.parse_object l2)
          end
        end
      end
    end
  end

  describe "#squish" do
    let(:result) {"a b c"}
    subject {RDF::Literal("  a\n b  c\n  ")}

    it "squeezes properly" do
      expect(subject.squish).to eq result
    end

    it "returns a new object" do
      expect(subject.squish).not_to equal subject
    end
  end

  describe "#squish!" do
    let(:result) {"a b c"}
    subject {RDF::Literal("  a\n b  c\n  ")}

    it "squeezes properly" do
      expect(subject.squish!).to eq result
    end

    it "returns itself" do
      expect(subject.squish!).to equal subject
    end
  end

  describe "language-tagged string" do
    literals(:all_plain_lang).each do |args|
      it "validates #{args.inspect}" do
        options = args.last.is_a?(Hash) ? args.pop : {}
        expect(RDF::Literal.new(*args, **options)).to be_valid
      end
    end

    literals(:all_invalid_lang).each do |args|
      it "invalidates #{args.inspect}" do
        options = args.last.is_a?(Hash) ? args.pop : {}
        expect(RDF::Literal.new(*args, **options)).not_to be_valid
      end
    end

    # test to make sure extra validation is not needed 
    context "when language? && !@language" do
      langString = RDF::Literal.new("hello", datatype: RDF::langString)
      it "should be invalid" do
        expect(langString.language?).to be true
        expect(!langString.instance_variable_get("@language")).to be true
        expect(langString).not_to be_valid
      end
    end
  end

  describe "datatyped literal" do
    (literals(:all) - literals(:all_simple, :all_plain_lang) +
     [["foo", datatype: RDF::URI("http://example/bar")]]).each do |args|
      it "validates #{args.inspect}" do
        options = args.last.is_a?(Hash) ? args.pop : {}
        expect(RDF::Literal.new(*args, **options)).to be_valid
      end
    end

    it "invalidates ['foo', datatype: 'bar']" do
      expect(RDF::Literal.new("foo", datatype: "bar")).not_to be_valid
    end
  end

  describe RDF::Literal::Boolean do
    it_behaves_like 'RDF::Literal with datatype and grammar', "true", RDF::XSD.boolean
    it_behaves_like 'RDF::Literal equality', "true", true
    it_behaves_like 'RDF::Literal lexical values', "true"
    it_behaves_like 'RDF::Literal canonicalization', RDF::XSD.boolean, [
      %w(true true),
      %w(false false),
      %w(tRuE true),
      %w(FaLsE false),
      %w(1 true),
      %w(0 false)
    ]
    it_behaves_like 'RDF::Literal validation', RDF::XSD.boolean,
      %w(true false 1 0),
      %w(foo 10) + ['true false', 'true foo', 'tRuE' 'FaLsE']

    context "object values" do
      {
        1 => ["true", "true"],
        0 => ["false", "false"],
        true => ["true", "true"],
        false => ["false", "false"]
      }.each do |obj, (str, canon)|
        it "to_str #{obj} to #{str.inspect}" do
          expect(RDF::Literal::Boolean.new(obj).to_s).to eql str
        end

        it "canonicalizes #{obj} to #{canon.inspect}" do
          expect(RDF::Literal::Boolean.new(obj, canonicalize: true).to_s).to eql canon
        end
      end
    end
  end

  describe RDF::Literal::Integer do
    it_behaves_like 'RDF::Literal with datatype and grammar', "1", RDF::XSD.integer
    it_behaves_like 'RDF::Literal equality', "1", 1
    it_behaves_like 'RDF::Literal lexical values', "1"
    it_behaves_like 'RDF::Literal canonicalization', RDF::XSD.integer, [
      %w(01 1),
      %w(0123 123),
      %w(1  1),
      %w(-1 -1),
      %w(+1 1)
    ]
    it_behaves_like 'RDF::Literal validation', RDF::XSD.integer,
      %w(1 10 100 01 +1 -1),
      %w(foo 10.1 12xyz) + ["1 2", "foo 1", "1 foo"]

    context "object values" do
      {
        1 => ["1", "1"],
        0 => ["0", "0"]
      }.each do |obj, (str, canon)|
        it "to_str #{obj} to #{str.inspect}" do
          expect(RDF::Literal::Integer.new(obj).to_s).to eql str
        end

        it "canonicalizes #{obj} to #{canon.inspect}" do
          expect(RDF::Literal::Integer.new(obj, canonicalize: true).to_s).to eql canon
        end
      end
    end
  end

  describe RDF::Literal::Decimal do
    it_behaves_like 'RDF::Literal with datatype and grammar', "1.1", RDF::XSD.decimal
    it_behaves_like 'RDF::Literal equality', "1.1", 1.1
    it_behaves_like 'RDF::Literal lexical values', "1.1"
    it_behaves_like 'RDF::Literal canonicalization', RDF::XSD.decimal, [
      %w(1                              1.0),
      %w(01                             1.0),
      %w(0123                           123.0),
      %w(-1                             -1.0),
      %w(1.                             1.0),
      %w(1.0                            1.0),
      %w(1.00                           1.0),
      %w(+001.00                        1.0),
      %w(123.456                        123.456),
      %w(0123.456                       123.456),
      %w(1.000000000                    1.0),
      %w(2.345                          2.345),
      %w(2.3                            2.3),
      %w(2.234000005                    2.234000005),
      %w(2.2340000000000005             2.2340000000000005),
      %w(2.23400000000000005            2.234),
      %w(2.23400000000000000000005      2.234),
      %w(1.2345678901234567890123457890 1.2345678901234567),
    ]
    it_behaves_like 'RDF::Literal validation', RDF::XSD.decimal,
      %w(
        1
        -1
        1.
        1.0
        1.00
        +001.00
        123.456
        1.000000000
        2.345
        2.3
        2.234000005
        2.2340000000000005
        2.23400000000000005
        2.23400000000000000000005
        1.2345678901234567890123457890
      ),
      %w(foo 10.1e1 12.xyz) + ['1.0 foo', 'foo 1.0']

    context "object values" do
      {
        BigDecimal('1.0') => ["1.0", "1.0"],
        BigDecimal('0') => ["0.0", "0.0"],
        BigDecimal('10.10') => ["10.1", "10.1"],
        1.1                 => ["1.1", "1.1"],
      }.each do |obj, (str, canon)|
        it "to_str #{obj} to #{str.inspect}" do
          expect(RDF::Literal::Decimal.new(obj).to_s).to eql str
        end

        it "canonicalizes #{obj} to #{canon.inspect}" do
          expect(RDF::Literal::Decimal.new(obj, canonicalize: true).to_s).to eql canon
        end
      end
    end
  end

  describe RDF::Literal::Double do
    it_behaves_like 'RDF::Literal with datatype and grammar', "1.0E0", RDF::XSD.double
    it_behaves_like 'RDF::Literal equality', "1.0E0", 1.0E0
    it_behaves_like 'RDF::Literal lexical values', "1.0E0"
    it_behaves_like 'RDF::Literal canonicalization', RDF::XSD.double, [
      %w(1         1.0E0),
      %w(01        1.0E0),
      %w(0123      1.23E2),
      %w(-1        -1.0E0),
      %w(+01.000   1.0E0),
      #%w(1.        1.0E0),
      %w(1.0       1.0E0),
      %w(123.456   1.23456E2),
      %w(1.0e+1    1.0E1),
      %w(1.0e-10   1.0E-10),
      %w(123.456e4 1.23456E6),
      %w(1.E-8     1.0E-8),
      %w(+INF      INF),
      %w(INF       INF),
      %w(-INF      -INF),
      %w(+INF      INF),
      #%w(NaN       NaN),
      #%w(NAN        NaN),
      %w(InF        INF),
      %w(3E1       3.0E1)
    ]
    it_behaves_like 'RDF::Literal validation', RDF::XSD.double,
      %w(
        1
        -1
        +01.000
        1.0
        123.456
        1.0e+1
        1.0e-10
        123.456e4
        INF
        -INF
        NaN
        3E1
      ),
      %w(foo 12.xyz 1.0ez) + ['1.1e1 foo', 'foo 1.1e1']

    context "object values" do
      {
        1.0       => ["1.0", "1.0E0"],
        0.0       => ["0.0", "0.0E0"],
        10.10     => ["10.1", "1.01E1"],
        123.456e4 => ["1234560.0", "1.23456E6"],
      }.each do |obj, (str, canon)|
        it "to_str #{obj} to #{str.inspect}" do
          expect(RDF::Literal::Double.new(obj).to_s).to eql str
        end

        it "canonicalizes #{obj} to #{canon.inspect}" do
          expect(RDF::Literal::Double.new(obj, canonicalize: true).to_s).to eql canon
        end
      end
    end

    let(:nan) {RDF::Literal::Double.new("NaN")}
    let(:inf) {RDF::Literal::Double.new("INF")}

    it "recognizes INF" do
      expect(inf).to be_infinite
      expect(RDF::Literal.new('INF', datatype: RDF::Literal::Double::DATATYPE)).to eq inf
      expect {inf.canonicalize}.not_to raise_error
    end

    it "recognizes -INF" do
      expect(-inf).to be_infinite
      expect(RDF::Literal.new('-INF', datatype: RDF::Literal::Double::DATATYPE)).to eq(-inf)
      expect {-inf.canonicalize}.not_to raise_error
    end

    it "recognizes NaN" do
      expect(nan).to be_nan
      expect(RDF::Literal.new('NaN', datatype: RDF::Literal::Double::DATATYPE)).to be_nan
      expect {nan.canonicalize}.not_to raise_error
    end

    [-1, 0, 1].map {|n| RDF::Literal::Double.new(n)}.each do |n|
      {
        :"+" => [RDF::Literal::Double.new("INF"), RDF::Literal::Double.new("INF"), RDF::Literal::Double.new("-INF"), RDF::Literal::Double.new("-INF")],
        :"-" => [RDF::Literal::Double.new("INF"), RDF::Literal::Double.new("-INF"), RDF::Literal::Double.new("-INF"), RDF::Literal::Double.new("INF")],
      }.each do |op, (lp, rp, lm, rm)|
        it "returns #{lp} for INF #{op} #{n}" do
          expect(inf.send(op, n)).to eq lp
        end

        it "returns #{rp} for #{n} #{op} INF" do
          expect(n.send(op, inf)).to eq rp
        end

        it "returns #{lm} for -INF #{op} #{n}" do
          expect((-inf).send(op, n)).to eq lm
        end

        it "returns #{rm} for #{n} #{op} -INF" do
          expect(n.send(op, -inf)).to eq rm
        end
      end

      it "#{n} + NaN" do
        expect(n + -nan).to be_nan
        expect(-nan + n).to be_nan
      end
    end

    # Multiplication
    {
      -1 => RDF::Literal::Double.new("-INF"),
      0  => :nan,
      1  => RDF::Literal::Double.new("INF"),
    }.each do |n, p|
      it "returns #{p} for #{n} * INF" do
        if p == :nan
          expect(RDF::Literal::Double.new(n) * inf).to be_nan
        else
          expect(RDF::Literal::Double.new(n) * inf).to eq p
        end
      end

      it "returns #{p} for INF * #{n}" do
        if p == :nan
          expect(inf * RDF::Literal::Double.new(n)).to be_nan
        else
          expect(inf * RDF::Literal::Double.new(n)).to eq p
        end
      end
    end

    # Comparison
    {
      "inf < inf" => [:<, "INF", "INF", false],
      "inf > inf" => [:<, "INF", "INF", false],
      "-inf < -inf" => [:<, "-INF", "-INF", false],
      "0 < inf" => [:<, "0", "INF", true],
      "0 < -inf" => [:<, "0", "-INF", false],
      "0 > inf" => [:>, "0", "INF", false],
      "0 > -inf" => [:>, "0", "-INF", true],
    }.each do |n, (op, l, r, result)|
      it "returns #{result} for #{l} #{op} #{r}" do
        expect(RDF::Literal::Double.new(l).send(op, RDF::Literal::Double.new(r))).to eql result
      end
    end

    it "adds infinities" do
      expect(inf + inf).to eq inf
      expect(inf + -inf).to be_nan
      expect(-inf + -inf).to eq(-inf)
      expect(-inf + inf).to be_nan
    end

    it "adds NaN" do
      expect(inf + nan).to be_nan
      expect(nan + nan).to be_nan
    end
  end

  describe RDF::Literal::DateTime do
    it_behaves_like 'RDF::Literal with datatype and grammar', "2010-01-01T00:00:00Z", RDF::XSD.dateTime
    it_behaves_like 'RDF::Literal equality', "2010-01-01T00:00:00Z", DateTime.parse("2010-01-01T00:00:00Z")
    it_behaves_like 'RDF::Literal lexical values', "2010-01-01T00:00:00Z"
    it_behaves_like 'RDF::Literal canonicalization', RDF::XSD.dateTime, [
      ["2010-01-01T00:00:00Z",      "2010-01-01T00:00:00Z", "12:00:00 AM UTC on Friday, 01 January 2010"],
      ["2010-01-01T00:00:00.0000Z", "2010-01-01T00:00:00Z", "12:00:00 AM UTC on Friday, 01 January 2010"],
      ["2010-01-01T00:00:00",       "2010-01-01T00:00:00", "12:00:00 AM on Friday, 01 January 2010"],
      ["2010-01-01T00:00:00+00:00", "2010-01-01T00:00:00Z", "12:00:00 AM UTC on Friday, 01 January 2010"],
      ["2010-01-01T01:00:00+01:00", "2010-01-01T00:00:00Z", "01:00:00 AM +01:00 on Friday, 01 January 2010"],
      ["2009-12-31T23:00:00-01:00", "2010-01-01T00:00:00Z", "11:00:00 PM -01:00 on Thursday, 31 December 2009"],
      ["-2010-01-01T00:00:00Z",     "-2010-01-01T00:00:00Z","12:00:00 AM UTC on Friday, 01 January -2010"],
      ["2014-09-01T12:13:14.567",   "2014-09-01T12:13:14.567",  "12:13:14 PM on Monday, 01 September 2014"],
      ["2014-09-01T12:13:14.567Z",   "2014-09-01T12:13:14.567Z", "12:13:14 PM UTC on Monday, 01 September 2014"],
      ["2014-09-01T12:13:14.567-08:00","2014-09-01T20:13:14.567Z","12:13:14 PM -08:00 on Monday, 01 September 2014"],
    ]
    it_behaves_like 'RDF::Literal validation', RDF::XSD.dateTime,
      %w(
        2010-01-01T00:00:00Z
        2010-01-01T00:00:00.0000Z
        2010-01-01T00:00:00
        2010-01-01T00:00:00+00:00
        2010-01-01T01:00:00+01:00
        2009-12-31T23:00:00-01:00
        -2010-01-01T00:00:00Z
        20010-01-01T00:00:00Z
        -20010-01-01T00:00:00Z
        0052-01-01T00:00:00Z
        -0052-01-01T00:00:00Z
      ),
      %w(
        foo
        +2010-01-01T00:00:00Z
        2010-01-01T00:00:00FOO
        02010-01-01T00:00:00
        2010-01-01
        2010-1-1T00:00:00
        0000-01-01T00:00:00
        2010-07
        2010
        52-01-01T00:00:00Z
        052-01-01T00:00:00Z
        -52-01-01T00:00:00Z
        -052-01-01T00:00:00Z
      ) + ['2010-01-01T00:00:00Z foo', 'foo 2010-01-01T00:00:00Z']

    context "object values" do
      {
        DateTime.parse("2010-01-01T00:00:00Z")      => ["2010-01-01T00:00:00Z", "2010-01-01T00:00:00Z"],
        DateTime.parse("2010-02-01T00:00:00")       => ["2010-02-01T00:00:00Z", "2010-02-01T00:00:00Z"],
        DateTime.parse("2010-03-01T04:00:00+01:00") => ["2010-03-01T04:00:00+01:00", "2010-03-01T03:00:00Z"],
        DateTime.parse("2009-12-31T04:00:00-01:00") => ["2009-12-31T04:00:00-01:00", "2009-12-31T05:00:00Z"],
        DateTime.parse("-2010-01-01T00:00:00Z")     => ["-2010-01-01T00:00:00Z","-2010-01-01T00:00:00Z"],
      }.each do |obj, (str, canon)|
        it "to_str #{obj} to #{str.inspect}" do
          expect(RDF::Literal::DateTime.new(obj).to_s).to eql str
        end

        it "canonicalizes #{obj} to #{canon.inspect}" do
          expect(RDF::Literal::DateTime.new(obj, canonicalize: true).to_s).to eql canon
        end
      end
    end

    describe "#tz" do
      {
        "2010-06-21T11:28:01Z"      => "Z",
        "2010-12-21T15:38:02-08:00" => "-08:00",
        "2008-06-20T23:59:00Z"      => "Z",
        "2011-02-01T01:02:03"       => "",
      }.each do |l, r|
        it "#{l} => #{r}" do
          expect(RDF::Literal::DateTime.new(l).tz).to eq RDF::Literal(r)
        end
      end
    end

    describe "#timezone" do
      {
        "2010-06-21T11:28:01Z"      => RDF::Literal("PT0S", datatype: RDF::XSD.dayTimeDuration),
        "2010-12-21T15:38:02-08:00" => RDF::Literal("-PT8H", datatype: RDF::XSD.dayTimeDuration),
        "2008-06-20T23:59:00Z"      => RDF::Literal("PT0S", datatype: RDF::XSD.dayTimeDuration),
        "2011-02-01T01:02:03"       => nil,
      }.each do |l, r|
        it "#{l} => #{r.inspect}" do
          expect(RDF::Literal::DateTime.new(l).timezone).to eq r
        end
      end
    end
  end


  describe RDF::Literal::Date do
    it_behaves_like 'RDF::Literal with datatype and grammar', "2010-01-01T00:00:00Z", RDF::XSD.date
    it_behaves_like 'RDF::Literal equality', "2010-01-01T00:00:00Z", DateTime.parse("2010-01-01T00:00:00Z")
    it_behaves_like 'RDF::Literal lexical values', "2010-01-01T00:00:00Z"
    it_behaves_like 'RDF::Literal canonicalization', RDF::XSD.date, [
      ["2010-01-01Z",     "2010-01-01Z",      "Friday, 01 January 2010 UTC"],
      ["2010-01-01",      "2010-01-01",       "Friday, 01 January 2010"],
      ["2010-01-01+00:00","2010-01-01Z",      "Friday, 01 January 2010 UTC"],
      ["2010-01-01+01:00","2010-01-01+01:00", "Friday, 01 January 2010 +01:00"],
      ["2009-12-31-01:00","2009-12-31-01:00", "Thursday, 31 December 2009 -01:00"],
      ["-2010-01-01Z",    "-2010-01-01Z",     "Friday, 01 January -2010 UTC"],
      ["2014-09-01-08:00","2014-09-01-08:00", "Monday, 01 September 2014 -08:00"],
    ]
    it_behaves_like 'RDF::Literal validation', RDF::XSD.date,
      %w(
        2010-01-01Z
        2010-01-01
        2010-01-01+00:00
        2010-01-01+01:00
        2009-12-31-01:00
        -2010-01-01Z
      ),
      %w(
        foo
        +2010-01-01Z
        2010-01-01TFOO
        02010-01-01
        2010-1-1
        0000-01-01
        2011-07
        2011
      ) + ['2010-01-01Z foo', 'foo 2010-01-01Z']

    context "object values" do
      {
        Date.parse("2010-02-01")      => ["2010-02-01", "2010-02-01"],
        Date.parse("-2010-01-01")     => ["-2010-01-01","-2010-01-01"],
      }.each do |obj, (str, canon)|
        it "to_str #{obj} to #{str.inspect}" do
          expect(RDF::Literal::Date.new(obj).to_s).to eql str
        end

        it "canonicalizes #{obj} to #{canon.inspect}" do
          expect(RDF::Literal::Date.new(obj, canonicalize: true).to_s).to eql canon
        end
      end
    end

    describe "#tz" do
      {
        "2010-06-21Z"      => "Z",
        "2010-12-21-08:00" => "-08:00",
        "2008-06-20Z"      => "Z",
        "2011-02-01"       => "",
      }.each do |l, r|
        it "#{l} => #{r}" do
          expect(RDF::Literal::Date.new(l).tz).to eq RDF::Literal(r)
        end
      end
    end
  end

  describe RDF::Literal::Time do
    it_behaves_like 'RDF::Literal with datatype and grammar', "00:00:00Z", RDF::XSD.time
    it_behaves_like 'RDF::Literal equality', "00:00:00Z", DateTime.parse("00:00:00Z")
    it_behaves_like 'RDF::Literal lexical values', "00:00:00Z"
    it_behaves_like 'RDF::Literal canonicalization', RDF::XSD.time, [
      ["00:00:00Z",      "00:00:00Z", "12:00:00 AM UTC"],
      ["00:00:00.0000Z", "00:00:00Z", "12:00:00 AM UTC"],
      ["00:00:00",       "00:00:00",  "12:00:00 AM"],
      ["00:00:00+00:00", "00:00:00Z", "12:00:00 AM UTC"],
      ["01:00:00+01:00", "00:00:00Z", "01:00:00 AM +01:00"],
      ["23:00:00-01:00", "00:00:00Z", "11:00:00 PM -01:00"],
      ["12:13:14.567",   "12:13:14.567",  "12:13:14 PM"],
      ["12:13:14.567Z",   "12:13:14.567Z", "12:13:14 PM UTC"],
    ]
    it_behaves_like 'RDF::Literal validation', RDF::XSD.time,
      %w(
        00:00:00Z
        00:00:00.0000Z
        00:00:00    
        00:00:00+00:00
        01:00:00+01:00
        23:00:00-01:00
      ),
      %w(
        foo
        +2010-01-01Z
        2010-01-01TFOO
        02010-01-01
        2010-1-1
        0000-01-01
        2011-07
        2011
      ) + ['00:00:00Z foo', 'foo 00:00:00Z']

    context "object values" do
      {
        DateTime.parse("00:00:00Z")      => ["00:00:00Z", "00:00:00Z"],
        DateTime.parse("01:00:00.0000Z") => ["01:00:00Z","01:00:00Z"],
        DateTime.parse("02:00:00")       => ["02:00:00Z", "02:00:00Z"],
        DateTime.parse("03:00:00+00:00") => ["03:00:00Z", "03:00:00Z"],
        DateTime.parse("05:00:00+01:00") => ["05:00:00+01:00", "04:00:00Z"],
        DateTime.parse("07:00:00-01:00") => ["07:00:00-01:00", "08:00:00Z"],
      }.each do |obj, (str, canon)|
        it "to_str #{obj} to #{str.inspect}" do
          expect(RDF::Literal::Time.new(obj).to_s).to eql str
        end

        it "canonicalizes #{obj} to #{canon.inspect}" do
          expect(RDF::Literal::Time.new(obj, canonicalize: true).to_s).to eql canon
        end
      end
    end

    subject {double("time", to_s: "05:50:00")}

    it "parses as string if #to_datetime raises an error" do
      expect(subject).to receive(:to_datetime).at_least(:once).and_raise(StandardError)
      expect {RDF::Literal::Time.new(subject)}.not_to raise_error
      expect(RDF::Literal::Time.new(subject).object).to eq ::DateTime.parse(subject.to_s)
    end

    describe "#tz" do
      {
        "11:28:01Z"      => "Z",
        "15:38:02-08:00" => "-08:00",
        "23:59:00Z"      => "Z",
        "01:02:03"       => "",
      }.each do |l, r|
        it "#{l} => #{r}" do
          expect(RDF::Literal::Time.new(l).tz).to eq RDF::Literal(r)
        end
      end
    end
  end

  describe RDF::Literal::Numeric do
    describe "#abs" do
      {
        1                  => 1,
        -1                 => 1,
        0                  => 0,
        BigDecimal("1.1")  => BigDecimal("1.1"),
        BigDecimal("-1.1") => BigDecimal("1.1"),
        +0.0               => +0.0,
        -0.0               => +0.0,
        1.2e3              => 1.2e3,
        -1.2e3             => 1.2e3,
        Float::INFINITY    => Float::INFINITY,
        -Float::INFINITY   => Float::INFINITY,
      }.each do |value, result|
        it "#{value} => #{result}" do
          expect(RDF::Literal(value).abs).to eq RDF::Literal(result)
        end
      end

      it "Numeric does not implement #abs" do
        expect {RDF::Literal::Numeric.new(-1).abs}.to raise_error(NotImplementedError)
      end
    end

    describe "#round" do
      {
        1                  => 1,
        -1                 => -1,
        0                  => 0,
        BigDecimal("1.1")  => BigDecimal("1"),
        BigDecimal("-1.1") => BigDecimal("-1"),
        BigDecimal("1.5")  => BigDecimal("2"),
        BigDecimal("-1.5") => BigDecimal("-2"),
        +0.0               => 0,
        -0.0               => 0,
        1.5                => 2,
        -1.5               => -2,
        1.2e0              => 1.0e0,
        -1.2e0             => -1.0e0
      }.each do |value, result|
        it "#{value} => #{result}" do
          expect(RDF::Literal(value).round).to eq RDF::Literal(result)
        end
      end

      it "Numeric does not implement #round" do
        expect {RDF::Literal::Numeric.new(-1).round}.to raise_error(NotImplementedError)
      end
    end

    describe "#ceil" do
      {
        1                  => 1,
        -1                 => -1,
        0                  => 0,
        BigDecimal("1.1")  => BigDecimal("2"),
        BigDecimal("-1.1") => BigDecimal("-1"),
        BigDecimal("1.5")  => BigDecimal("2"),
        BigDecimal("-1.5") => BigDecimal("-1"),
        +0.0               => 0,
        -0.0               => 0,
        1.5                => 2,
        -1.5               => -1,
        1.2e0              => 2.0e0,
        -1.2e0             => -1.0e0
      }.each do |value, result|
        it "#{value} => #{result}" do
          expect(RDF::Literal(value).ceil).to eq RDF::Literal(result)
        end
      end

      it "Numeric returns self" do
        expect(RDF::Literal::Numeric.new(-1).ceil).to eql RDF::Literal::Numeric.new(-1)
      end
    end

    describe "#floor" do
      {
        1                  => 1,
        -1                 => -1,
        0                  => 0,
        BigDecimal("1.1")  => BigDecimal("1"),
        BigDecimal("-1.1") => BigDecimal("-2"),
        BigDecimal("1.5")  => BigDecimal("1"),
        BigDecimal("-1.5") => BigDecimal("-2"),
        +0.0               => 0,
        -0.0               => 0,
        1.5                => 1,
        -1.5               => -2,
        1.2e0              => 1.0e0,
        -1.2e0             => -2.0e0
      }.each do |value, result|
        it "#{value} => #{result}" do
          expect(RDF::Literal(value).floor).to eq RDF::Literal(result)
        end
      end

      it "Numeric returns self" do
        expect(RDF::Literal::Numeric.new(-1).floor).to eql RDF::Literal::Numeric.new(-1)
      end
    end

    describe "#+" do
      {
        "Double + Double"     => [RDF::Literal::Double.new(1), RDF::Literal::Double.new(1), RDF::Literal::Double.new(2)],
        "Double + Float"      => [RDF::Literal::Double.new(1), 1.0, RDF::Literal::Double.new(2)],
        "Double + Decimal"    => [RDF::Literal::Double.new(1), RDF::Literal::Decimal.new(1), RDF::Literal::Double.new(2)],
        "Double + Integer"    => [RDF::Literal::Double.new(1), RDF::Literal::Integer.new(1), RDF::Literal::Double.new(2)],
        "Double + ::Integer"  => [RDF::Literal::Double.new(1), 1, RDF::Literal::Double.new(2)],
        "Decimal + Double"    => [RDF::Literal::Decimal.new(1), RDF::Literal::Double.new(1), RDF::Literal::Double.new(2)],
        "Decimal + Float"     => [RDF::Literal::Decimal.new(1), 1.0, RDF::Literal::Double.new(2)],
        "Decimal + Decimal"   => [RDF::Literal::Decimal.new(1), RDF::Literal::Decimal.new(1), RDF::Literal::Decimal.new(2)],
        "Decimal + Integer"   => [RDF::Literal::Decimal.new(1), RDF::Literal::Integer.new(1), RDF::Literal::Decimal.new(2)],
        "Decimal + ::Integer" => [RDF::Literal::Decimal.new(1), 1, RDF::Literal::Decimal.new(2)],
        "Integer + Double"    => [RDF::Literal::Integer.new(1), RDF::Literal::Double.new(1), RDF::Literal::Double.new(2)],
        "Integer + Float"     => [RDF::Literal::Integer.new(1), 1.0, RDF::Literal::Double.new(2)],
        "Integer + Decimal"   => [RDF::Literal::Integer.new(1), RDF::Literal::Decimal.new(1), RDF::Literal::Decimal.new(2)],
        "Integer + Integer"   => [RDF::Literal::Integer.new(1), RDF::Literal::Integer.new(1), RDF::Literal::Integer.new(2)],
        "Integer + ::Integer" => [RDF::Literal::Integer.new(1), 1, RDF::Literal::Integer.new(2)],
      }.each do |test, (l,r,v)|
        it test do
          expect(l + r).to eql v
        end
      end

      it "returns self for unary +" do
        expect(+RDF::Literal::Numeric.new(1)).to eql RDF::Literal::Numeric.new(1)
      end
    end

    describe "#-" do
      {
        "Double - Double"     => [RDF::Literal::Double.new(10), RDF::Literal::Double.new(1), RDF::Literal::Double.new(9)],
        "Double - Float"      => [RDF::Literal::Double.new(10), 1.0, RDF::Literal::Double.new(9)],
        "Double - Decimal"    => [RDF::Literal::Double.new(10), RDF::Literal::Decimal.new(1), RDF::Literal::Double.new(9)],
        "Double - Integer"    => [RDF::Literal::Double.new(10), RDF::Literal::Integer.new(1), RDF::Literal::Double.new(9)],
        "Double - ::Integer"  => [RDF::Literal::Double.new(10), 1, RDF::Literal::Double.new(9)],
        "Decimal - Double"    => [RDF::Literal::Decimal.new(10), RDF::Literal::Double.new(1), RDF::Literal::Double.new(9)],
        "Decimal - Float"     => [RDF::Literal::Decimal.new(10), 1.0, RDF::Literal::Double.new(9)],
        "Decimal - Decimal"   => [RDF::Literal::Decimal.new(10), RDF::Literal::Decimal.new(1), RDF::Literal::Decimal.new(9)],
        "Decimal - Integer"   => [RDF::Literal::Decimal.new(10), RDF::Literal::Integer.new(1), RDF::Literal::Decimal.new(9)],
        "Decimal - ::Integer" => [RDF::Literal::Decimal.new(10), 1, RDF::Literal::Decimal.new(9)],
        "Integer - Double"    => [RDF::Literal::Integer.new(10), RDF::Literal::Double.new(1), RDF::Literal::Double.new(9)],
        "Integer - Float"     => [RDF::Literal::Integer.new(10), 1.0, RDF::Literal::Double.new(9)],
        "Integer - Decimal"   => [RDF::Literal::Integer.new(10), RDF::Literal::Decimal.new(1), RDF::Literal::Decimal.new(9)],
        "Integer - Integer"   => [RDF::Literal::Integer.new(10), RDF::Literal::Integer.new(1), RDF::Literal::Integer.new(9)],
        "Integer - ::Integer" => [RDF::Literal::Integer.new(10), 1, RDF::Literal::Integer.new(9)],
      }.each do |test, (l,r,v)|
        it test do
          expect(l - r).to eql v
        end
      end
    end

    describe "#*" do
      {
        "Double * Double"     => [RDF::Literal::Double.new(10), RDF::Literal::Double.new(1), RDF::Literal::Double.new(10)],
        "Double * Float"      => [RDF::Literal::Double.new(10), 1.0, RDF::Literal::Double.new(10)],
        "Double * Decimal"    => [RDF::Literal::Double.new(10), RDF::Literal::Decimal.new(1), RDF::Literal::Double.new(10)],
        "Double * Integer"    => [RDF::Literal::Double.new(10), RDF::Literal::Integer.new(1), RDF::Literal::Double.new(10)],
        "Double * ::Integer"  => [RDF::Literal::Double.new(10), 1, RDF::Literal::Double.new(10)],
        "Decimal * Double"    => [RDF::Literal::Decimal.new(10), RDF::Literal::Double.new(1), RDF::Literal::Double.new(10)],
        "Decimal * Float"     => [RDF::Literal::Decimal.new(10), 1.0, RDF::Literal::Double.new(10)],
        "Decimal * Decimal"   => [RDF::Literal::Decimal.new(10), RDF::Literal::Decimal.new(1), RDF::Literal::Decimal.new(10)],
        "Decimal * Integer"   => [RDF::Literal::Decimal.new(10), RDF::Literal::Integer.new(1), RDF::Literal::Decimal.new(10)],
        "Decimal * ::Integer" => [RDF::Literal::Decimal.new(10), 1, RDF::Literal::Decimal.new(10)],
        "Integer * Double"    => [RDF::Literal::Integer.new(10), RDF::Literal::Double.new(1), RDF::Literal::Double.new(10)],
        "Integer * Float"     => [RDF::Literal::Integer.new(10), 1.0, RDF::Literal::Double.new(10)],
        "Integer * Decimal"   => [RDF::Literal::Integer.new(10), RDF::Literal::Decimal.new(1), RDF::Literal::Decimal.new(10)],
        "Integer * Integer"   => [RDF::Literal::Integer.new(10), RDF::Literal::Integer.new(1), RDF::Literal::Integer.new(10)],
        "Integer * ::Integer" => [RDF::Literal::Integer.new(10), 1, RDF::Literal::Integer.new(10)],
      }.each do |test, (l,r,v)|
        it test do
          expect(l * r).to eql v
        end
      end

      describe "#/" do
        {
          "Double * Double"     => [RDF::Literal::Double.new(10), RDF::Literal::Double.new(1), RDF::Literal::Double.new(10)],
          "Double * Float"      => [RDF::Literal::Double.new(10), 1.0, RDF::Literal::Double.new(10)],
          "Double * Decimal"    => [RDF::Literal::Double.new(10), RDF::Literal::Decimal.new(1), RDF::Literal::Double.new(10)],
          "Double * Integer"    => [RDF::Literal::Double.new(10), RDF::Literal::Integer.new(1), RDF::Literal::Double.new(10)],
          "Double * ::Integer"  => [RDF::Literal::Double.new(10), 1, RDF::Literal::Double.new(10)],
          "Decimal * Double"    => [RDF::Literal::Decimal.new(10), RDF::Literal::Double.new(1), RDF::Literal::Double.new(10)],
          "Decimal * Float"     => [RDF::Literal::Decimal.new(10), 1.0, RDF::Literal::Double.new(10)],
          "Decimal * Decimal"   => [RDF::Literal::Decimal.new(10), RDF::Literal::Decimal.new(1), RDF::Literal::Decimal.new(10)],
          "Decimal * Integer"   => [RDF::Literal::Decimal.new(10), RDF::Literal::Integer.new(1), RDF::Literal::Decimal.new(10)],
          "Decimal * ::Integer" => [RDF::Literal::Decimal.new(10), 1, RDF::Literal::Decimal.new(10)],
          "Integer * Double"    => [RDF::Literal::Integer.new(10), RDF::Literal::Double.new(1), RDF::Literal::Double.new(10)],
          "Integer * Float"     => [RDF::Literal::Integer.new(10), 1.0, RDF::Literal::Double.new(10)],
          "Integer * Decimal"   => [RDF::Literal::Integer.new(10), RDF::Literal::Decimal.new(1), RDF::Literal::Decimal.new(10)],
          "Integer * Integer"   => [RDF::Literal::Integer.new(10), RDF::Literal::Integer.new(1), RDF::Literal::Decimal.new(10)],
          "Integer * ::Integer" => [RDF::Literal::Integer.new(10), 1, RDF::Literal::Decimal.new(10)],
        }.each do |test, (l,r,v)|
          it test do
            expect(l / r).to eql v
          end
        end
      end
    end
  end

  describe RDF::Literal::Integer do
    describe "#pred" do
      {
        1                  => 0,
        -1                 => -2,
        0                  => -1,
      }.each do |value, result|
        it "#{value} => #{result}" do
          expect(RDF::Literal(value).pred).to eq RDF::Literal(result)
        end
      end
    end

    describe "#succ" do
      {
        1                  => 2,
        -1                 => 0,
        0                  => 1,
      }.each do |value, result|
        it "#{value} => #{result}" do
          expect(RDF::Literal(value).succ).to eq RDF::Literal(result)
        end
      end
    end

    describe "#even?" do
      {
        -2                 => true,
        -1                 => false,
        0                  => true,
        1                  => false,
        2                  => true,
      }.each do |value, result|
        it "#{value} => #{result}" do
          expect(RDF::Literal(value).even?).to eq result
        end
      end
    end

    describe "#odd?" do
      {
        -2                 => false,
        -1                 => true,
        0                  => false,
        1                  => true,
        2                  => false,
      }.each do |value, result|
        it "#{value} => #{result}" do
          expect(RDF::Literal(value).odd?).to eq result
        end
      end
    end

    describe "#zero?" do
      {
        -2                 => false,
        -1                 => false,
        0                  => true,
        1                  => false,
        2                  => false,
      }.each do |value, result|
        it "#{value} => #{result}" do
          expect(RDF::Literal(value).zero?).to eq result
        end
      end
    end

    describe "#nonzero?" do
      {
        -2                 => -2,
        -1                 => -1,
        0                  => false,
        1                  => 1,
        2                  => 2,
      }.each do |value, result|
        it "#{value} => #{result}" do
          if result
            expect(RDF::Literal(value).nonzero?).to eql RDF::Literal(result)
          else
            expect(RDF::Literal(value).nonzero?).to be_falsy
          end
        end
      end
    end

    describe "#to_bn" do
      require 'openssl' unless defined?(OpenSSL::BN)
      {
        0                  => OpenSSL::BN.new("0"),
        1                  => OpenSSL::BN.new("1"),
        2                  => OpenSSL::BN.new("2"),
      }.each do |value, result|
        it "#{value} => #{result}" do
          expect(RDF::Literal(value).to_bn).to eql result
        end
      end
    end
  end

  describe "SPARQL tests" do
    context "#==" do
      {
        "boolean false=false" => [RDF::Literal::Boolean.new("false"), RDF::Literal::Boolean.new("false")],
        "boolean true=true" => [RDF::Literal::Boolean.new("true"), RDF::Literal::Boolean.new("true")],
        "date-1 1" => [RDF::Literal::Date.new("2006-08-23"), RDF::Literal::Date.new("2006-08-23")],
        "datetime 1" => [RDF::Literal::DateTime.new("2002-04-02T12:00:00-01:00"), RDF::Literal::DateTime.new("2002-04-02T17:00:00+04:00")],
        "datetime 2" => [RDF::Literal::DateTime.new("2002-04-02T12:00:00-05:00"), RDF::Literal::DateTime.new("2002-04-02T23:00:00+06:00")],
        "datetime 3" => [RDF::Literal::DateTime.new("2002-04-02T12:00:00-05:00"), RDF::Literal::DateTime.new("2002-04-02T12:00:00-05:00")],
        "datetime 4" => [RDF::Literal::DateTime.new("2002-04-02T23:00:00-04:00"), RDF::Literal::DateTime.new("2002-04-03T02:00:00-01:00")],
        "datetime 5" => [RDF::Literal::DateTime.new("1999-12-31T24:00:00-05:00"), RDF::Literal::DateTime.new("2000-01-01T00:00:00-05:00")],
        "eq-1 1='01'^xsd:integer" => [RDF::Literal(1), RDF::Literal::Integer.new("01")],
        "eq-1 1='1.0e0'^xsd:double" => [RDF::Literal(1), RDF::Literal::Double.new("1.0e0")],
        "eq-1 1=1" => [RDF::Literal(1), RDF::Literal(1)],
        "eq-1 1=1.0" => [RDF::Literal(1), RDF::Literal(1.0)],
        "eq-2-1 1.0=1.0" => [RDF::Literal(1.0), RDF::Literal(1.0)],
        "eq-2-1 1.0e0=1.0" => [RDF::Literal::Double.new("1.0e0"), RDF::Literal::Double.new("1.0")],
        "eq-2-1 1='1'^xsd:decimal" => [RDF::Literal(1), RDF::Literal::Decimal.new("1")],
        "eq-2-1 1^^xsd:decimal=1^^xsd:decimal" => [RDF::Literal::Decimal.new(1), RDF::Literal::Decimal.new(1)],
        "eq-3 '1'='1'" => [RDF::Literal("1"), RDF::Literal("1")],
        "eq-4 'zzz'='zzz'" => [RDF::Literal("zzz"), RDF::Literal("zzz")],
        "numeric -INF=-INF" => [-RDF::Literal::Double.new("INF"), -RDF::Literal::Double.new("INF")],
        "numeric INF=INF" => [RDF::Literal::Double.new("INF"), RDF::Literal::Double.new("INF")],
        "open-eq-02 'xyz'^^<unknown>='xyz'^^<unknown>" => [RDF::Literal("xyz", datatype: RDF::URI("unknown")), RDF::Literal("xyz", datatype: RDF::URI("unknown"))],
        "open-eq-03 '01'^xsd:integer=1" => [RDF::Literal::Integer.new("01"), RDF::Literal(1)],
        "open-eq-03 '1'^xsd:integer=1" => [RDF::Literal::Integer.new("1"), RDF::Literal(1)],
        "open-eq-07 'xyz'='xyz'" => [RDF::Literal("xyz"), RDF::Literal("xyz")],
        "open-eq-07 'xyz'='xyz'^^xsd:string" => [RDF::Literal("xyz"), RDF::Literal("xyz", datatype: XSD.string)],
        "open-eq-07 'xyz'@EN='xyz'@EN" => [RDF::Literal("xyz", language: :EN), RDF::Literal("xyz", language: :EN)],
        "open-eq-07 'xyz'@EN='xyz'@en" => [RDF::Literal("xyz", language: :EN), RDF::Literal("xyz", language: :en)],
        "open-eq-07 'xyz'@en='xyz'@EN" => [RDF::Literal("xyz", language: :en), RDF::Literal("xyz", language: :EN)],
        "open-eq-07 'xyz'@en='xyz'@en" => [RDF::Literal("xyz", language: :en), RDF::Literal("xyz", language: :en)],
        "open-eq-07 'xyz'xsd:string='xyz'" => [RDF::Literal("xyz", datatype: XSD.string), RDF::Literal("xyz")],
        "open-eq-07 'xyz'^^<unknown>='xyz'^^<unknown>" => [RDF::Literal("xyz", datatype: RDF::URI("unknown")), RDF::Literal("xyz", datatype: RDF::URI("unknown"))],
        "open-eq-07 'xyz'^^xsd:integer='xyz'^^xsd:integer" => [RDF::Literal::Integer.new("xyz"), RDF::Literal::Integer.new("xyz")],
        "open-eq-07 'xyz'^^xsd:string='xyz'xsd:string" => [RDF::Literal("xyz", datatype: XSD.string), RDF::Literal("xyz", datatype: XSD.string)],
        "token 'xyz'^^xsd:token=xyz'^^xsd:token" => [RDF::Literal(:xyz), RDF::Literal(:xyz)],
      }.each do |label, (left, right)|
        it "returns true for #{label}" do
          left.extend(RDF::TypeCheck)
          right.extend(RDF::TypeCheck)
          expect(left).to eq right
        end
      end
    end

    context "#!=" do
      {
        "boolean false=true" => [RDF::Literal::Boolean.new("false"), RDF::Literal::Boolean.new("true")],
        "boolean true=false" => [RDF::Literal::Boolean.new("true"), RDF::Literal::Boolean.new("false")],
        "date-2 1" => [RDF::Literal::Date.new("2001-01-01Z"), RDF::Literal::Date.new("2006-08-23")],
        "date-2 2" => [RDF::Literal::Date.new("2001-01-01"), RDF::Literal::Date.new("2006-08-23")],
        "date-2 3" => [RDF::Literal::DateTime.new("2006-08-23T09:00:00+01:00"), RDF::Literal::Date.new("2006-08-23")],
        "datetime 1" => [RDF::Literal::DateTime.new("2002-04-02T12:00:00-05:00"), RDF::Literal::DateTime.new("2002-04-02T17:00:00-05:00")],
        "datetime 2" => [RDF::Literal::DateTime.new("2005-04-04T24:00:00-05:00"), RDF::Literal::DateTime.new("2005-04-04T00:00:00-05:00")],
        "language 'xyz'@en='xyz'@dr" => [RDF::Literal("xyz", language: :en), RDF::Literal("xyz", language: :"dr")],
        "language 'xyz'@en='xyz'@en-us" => [RDF::Literal("xyz", language: :en), RDF::Literal("xyz", language: :"en-us")],
        "numeric +INF=-INF" => [RDF::Literal::Double.new("INF"), -RDF::Literal::Double.new("INF")],
        "numeric -INF=INF" => [-RDF::Literal::Double.new("INF"), RDF::Literal::Double.new("INF")],
        "numeric 1.0=2.0" => [RDF::Literal(1.0), RDF::Literal(2.0)],
        "numeric 1=2" => [RDF::Literal(1), RDF::Literal(2)],
        "numeric NaN=NaN" => [-RDF::Literal::Double.new("NaN"), RDF::Literal::Double.new("NaN")],
        "open-eq-04 '02'^xsd:integer=1" => [RDF::Literal::Integer.new("02"), RDF::Literal(1)],
        "open-eq-04 '2'^xsd:integer=1" => [RDF::Literal::Integer.new("2"), RDF::Literal(1)],
        "open-eq-08 '<xyz>=xyz'@en" => [RDF::URI("xyz"), RDF::Literal("xyz", language: :en)],
        "open-eq-08 'xyz'='xyz'@EN" => [RDF::Literal("xyz"), RDF::Literal("xyz", language: :EN)],
        "open-eq-08 'xyz'='xyz'@en" => [RDF::Literal("xyz"), RDF::Literal("xyz", language: :en)],
        "open-eq-08 'xyz'=<xyz>" => [RDF::Literal("xyz"), RDF::URI("xyz")],
        "open-eq-08 'xyz'=_:xyz" => [RDF::Literal("xyz"), RDF::Node.new("xyz")],
        "open-eq-08 'xyz'@EN='xyz'" => [RDF::Literal("xyz", language: :EN), RDF::Literal("xyz")],
        "open-eq-08 'xyz'@en='xyz'" => [RDF::Literal("xyz", language: :en), RDF::Literal("xyz")],
        "open-eq-08 'xyz'@en='xyz'^^<unknown>" => [RDF::Literal("xyz", language: :en), RDF::Literal("xyz", datatype: RDF::URI("unknown"))],
        "open-eq-08 'xyz'@en='xyz'^^xsd:integer" => [RDF::Literal("xyz", language: :en), RDF::Literal("xyz", datatype: XSD.integer)],
        "open-eq-08 'xyz'@en='xyz'^^xsd:string" => [RDF::Literal("xyz", language: :en), RDF::Literal("xyz", datatype: XSD.string)],
        "open-eq-08 'xyz'@en=<xyz>" => [RDF::Literal("xyz", language: :en), RDF::URI("xyz")],
        "open-eq-08 'xyz'@en==_:xyz" => [RDF::Literal("xyz"), RDF::Node.new("xyz")],
        "open-eq-08 'xyz'^^<unknown>='xyz'@en" => [RDF::Literal("xyz", datatype: RDF::URI("unknown")), RDF::Literal("xyz", language: :en)],
        "open-eq-08 'xyz'^^xsd:integer='xyz'@en" => [RDF::Literal("xyz", datatype: XSD.integer), RDF::Literal("xyz", language: :en)],
        "open-eq-08 'xyz'^^xsd:integer=<xyz>" => [RDF::Literal("xyz", datatype: XSD.integer), RDF::URI("xyz")],
        "open-eq-08 'xyz'^^xsd:string='xyz'@en" => [RDF::Literal("xyz", datatype: XSD.string), RDF::Literal("xyz", language: :en)],
        "open-eq-08 <xyz>='xyz'" => [RDF::URI("xyz"), RDF::Literal("xyz")],
        "open-eq-08 <xyz>='xyz'@en" => [RDF::URI("xyz"), RDF::Literal("xyz", language: :en)],
        "open-eq-08 <xyz>='xyz'^^xsd:integer" => [RDF::URI("xyz"), RDF::Literal("xyz", datatype: XSD.integer)],
        "open-eq-08 _:xyz='abc'" => [RDF::Node.new("xyz"), RDF::Literal("abc")],
        "open-eq-08 _:xyz='xyz'" => [RDF::Node.new("xyz"), RDF::Literal("xyz")],
        "open-eq-08 _:xyz='xyz'@en=" => [RDF::Node.new("xyz"), RDF::Literal("xyz")],
        "open-eq-10 'xyz'='abc'" => [RDF::Literal("xyz"), RDF::Literal("abc")],
        "open-eq-10 'xyz'='abc'@EN" => [RDF::Literal("xyz"), RDF::Literal("abc", language: :EN)],
        "open-eq-10 'xyz'='abc'@en" => [RDF::Literal("xyz"), RDF::Literal("abc", language: :en)],
        "open-eq-10 'xyz'='abc'^^xsd:string" => [RDF::Literal("xyz"), RDF::Literal("abc", datatype: XSD.string)],
        "open-eq-10 'xyz'=<abc>" => [RDF::Literal("xyz"), RDF::URI("abc")],
        "open-eq-10 'xyz'=_:abc" => [RDF::Literal("xyz"), RDF::Node.new("abc")],
        "open-eq-10 'xyz'@en='abc'@en" => [RDF::Literal("xyz", language: :en), RDF::Literal("abc", language: :en)],
        "open-eq-10 'xyz'@en='abc'^^xsd:integer" => [RDF::Literal("xyz", language: :en), RDF::Literal("abc", datatype: XSD.integer)],
      }.each do |label, (left, right)|
        it "returns false for #{label}" do
          left.extend(RDF::TypeCheck)
          right.extend(RDF::TypeCheck)
          expect(left).not_to eq right
        end
      end
    end

    context ArgumentError do
      {
        "language with xsd:string" => {value: "foo", language: "en", datatype: RDF::XSD.string},
        "language with xsd:date" => {value: "foo", language: "en", datatype: RDF::XSD.date},
      }.each do |name, opts|
        it "raises error for #{name}" do
          expect {RDF::Literal.new(opts.delete(:value), **opts)}.to raise_error(ArgumentError)
        end
      end

      {
        "no language with xsd:string" => {value: "foo", datatype: RDF::XSD.string},
        "no language with xsd:date" => {value: "foo", datatype: RDF::XSD.date},
        "language with rdf:langString" => {value: "foo", language: "en", datatype: RDF::langString},
      }.each do |name, opts|
        it "should not raise error for #{name}" do
          expect {RDF::Literal.new(opts.delete(:value), **opts)}.not_to raise_error
        end
      end
    end

    context TypeError do
      {
        "boolean 'true'=true" => [RDF::Literal("true"), RDF::Literal::Boolean.new("true")],
        "boolean true='true'" => [RDF::Literal::Boolean.new("true"), RDF::Literal("true")],
        "eq-2-2(bug) 'zzz'^^<unknown>='1'" => [RDF::Literal("zzz", datatype: RDF::URI("unknown")), RDF::Literal("1")],
        "eq-2-2(bug) '1'='zzz'^^<unknown>" => [RDF::Literal("1"), RDF::Literal("zzz", datatype: RDF::URI("unknown"))],
        "eq-2-2(bug) 'zzz'^^<unknown>='zzz'" => [RDF::Literal("zzz", datatype: RDF::URI("unknown")), RDF::Literal("zzz")],
        "eq-2-2(bug) 'zzz'='zzz'^^<unknown>" => [RDF::Literal("zzz"), RDF::Literal("zzz", datatype: RDF::URI("unknown"))],
        "numeric '1'=1" => [RDF::Literal("1"), RDF::Literal(1)],
        "numeric 1='1'" => [RDF::Literal(1), RDF::Literal("1")],
        "numeric 1=<xyz>" => [RDF::Literal(1), RDF::URI("xyz")],  # From expr-equal/expr-2-2
        "numeric 1=_:xyz" => [RDF::Literal(1), RDF::Node.new("xyz")],  # From expr-equal/expr-2-2
        "numeric <xyz>=1" => [RDF::URI("xyz"), RDF::Literal(1)],  # From expr-equal/expr-2-2
        "numeric _:xyz=1" => [RDF::Node.new("xyz"), RDF::Literal(1)],  # From expr-equal/expr-2-2
        "open-eq-04 'a'^^<unknown>=1" => [RDF::Literal.new("a", datatype: RDF::URI("unknown")), RDF::Literal(1)],
        "open-eq-06 'b'^^<unknown>='a'^^<unknown>" => [RDF::Literal.new("b", datatype: RDF::URI("unknown")), RDF::Literal.new("a", datatype: RDF::URI("unknown"))],
        "open-eq-06 1='a'^^<unknown>" => [RDF::Literal(1), RDF::Literal.new("a", datatype: RDF::URI("unknown"))],
        "open-eq-08 'xyz'='xyz'^^<unknown>" => [RDF::Literal("xyz"), RDF::Literal("xyz", datatype: RDF::URI("unknown"))],
        "open-eq-08 'xyz'='xyz'^^xsd:integer" => [RDF::Literal("xyz"), RDF::Literal("xyz", datatype: XSD.integer)],
        "open-eq-08 'xyz'^^<unknown>='xyz'" => [RDF::Literal("xyz", datatype: RDF::URI("unknown")), RDF::Literal("xyz")],
        "open-eq-08 'xyz'^^xsd:integer='xyz'" => [RDF::Literal("xyz", datatype: XSD.integer), RDF::Literal("xyz")],
        "open-eq-10 'xyz'='abc'^^xsd:integer" => [RDF::Literal("xyz"), RDF::Literal("abc", datatype: XSD.integer)],
        "open-eq-10 'xyz'^^<unknown>='abc'^^<unknown>" => [RDF::Literal("xyz", datatype: RDF::URI("unknown")), RDF::Literal("abc", datatype: RDF::URI("unknown"))],
        "open-eq-10 'xyz'^^xsd:integer='abc'" => [RDF::Literal("xyz", datatype: XSD.integer), RDF::Literal("abc")],
        "open-eq-10 'xyz'^^xsd:integer='abc'^^xsd:integer" => [RDF::Literal::Integer.new("xyz"), RDF::Literal::Integer.new("abc")],
        "token 'xyz'^^xsd:token=abc'^^xsd:token" => [RDF::Literal(:xyz), RDF::Literal(:abc)],
      }.each do |label, (left, right)|
        it "raises TypeError for #{label}" do
          left.extend(RDF::TypeCheck)
          right.extend(RDF::TypeCheck)
          expect {left == right}.to raise_error(TypeError)
        end
      end
    end

    # Term equivalence
    # @see http://www.w3.org/TR/rdf-sparql-query/#func-sameTerm
    context "#eql?" do
      {
        "boolean false=false" => [RDF::Literal::Boolean.new("false"), RDF::Literal::Boolean.new("false")],
        "boolean true=true" => [RDF::Literal::Boolean.new("true"), RDF::Literal::Boolean.new("true")],
        "date-1 1" => [RDF::Literal::Date.new("2006-08-23"), RDF::Literal::Date.new("2006-08-23")],
        "datetime 3" => [RDF::Literal::DateTime.new("2002-04-02T12:00:00-05:00"), RDF::Literal::DateTime.new("2002-04-02T12:00:00-05:00")],
        "eq-1 1=1" => [RDF::Literal(1), RDF::Literal(1)],
        "eq-2-1 1.0=1.0" => [RDF::Literal(1.0), RDF::Literal(1.0)],
        "eq-2-1 1^^xsd:decimal=1^^xsd:decimal" => [RDF::Literal::Decimal.new(1), RDF::Literal::Decimal.new(1)],
        "eq-3 '1'='1'" => [RDF::Literal("1"), RDF::Literal("1")],
        "eq-4 'zzz'='zzz'" => [RDF::Literal("zzz"), RDF::Literal("zzz")],
        "numeric -INF=-INF" => [-RDF::Literal::Double.new("INF"), -RDF::Literal::Double.new("INF")],
        "numeric INF=INF" => [RDF::Literal::Double.new("INF"), RDF::Literal::Double.new("INF")],
        "open-eq-02 'xyz'^^<unknown>='xyz'^^<unknown>" => [RDF::Literal("xyz", datatype: RDF::URI("unknown")), RDF::Literal("xyz", datatype: RDF::URI("unknown"))],
        "open-eq-03 '1'^xsd:integer=1" => [RDF::Literal::Integer.new("1"), RDF::Literal(1)],
        "open-eq-07 'xyz'='xyz'" => [RDF::Literal("xyz"), RDF::Literal("xyz")],
        "open-eq-07 'xyz'@EN='xyz'@EN" => [RDF::Literal("xyz", language: :EN), RDF::Literal("xyz", language: :EN)],
        "open-eq-07 'xyz'@EN='xyz'@en" => [RDF::Literal("xyz", language: :EN), RDF::Literal("xyz", language: :en)],
        "open-eq-07 'xyz'@en='xyz'@EN" => [RDF::Literal("xyz", language: :en), RDF::Literal("xyz", language: :EN)],
        "open-eq-07 'xyz'@en='xyz'@en" => [RDF::Literal("xyz", language: :en), RDF::Literal("xyz", language: :en)],
        "open-eq-07 'xyz'^^<unknown>='xyz'^^<unknown>" => [RDF::Literal("xyz", datatype: RDF::URI("unknown")), RDF::Literal("xyz", datatype: RDF::URI("unknown"))],
        "open-eq-07 'xyz'^^xsd:integer='xyz'^^xsd:integer" => [RDF::Literal::Integer.new("xyz"), RDF::Literal::Integer.new("xyz")],
        "open-eq-07 'xyz'^^xsd:string='xyz'xsd:string" => [RDF::Literal("xyz", datatype: XSD.string), RDF::Literal("xyz", datatype: XSD.string)],
        "open-eq-07 'xyz'='xyz'^^xsd:string" => [RDF::Literal("xyz"), RDF::Literal("xyz", datatype: XSD.string)],
        "open-eq-07 'xyz'xsd:string='xyz'" => [RDF::Literal("xyz", datatype: XSD.string), RDF::Literal("xyz")],
        "token 'xyz'^^xsd:token=xyz'^^xsd:token" => [RDF::Literal(:xyz), RDF::Literal(:xyz)],
      }.each do |label, (left, right)|
        it "returns true for #{label}" do
          expect(left).to eql right
        end
      end
    end

    context "not #eql?" do
      {
        "datetime 1" => [RDF::Literal::DateTime.new("2002-04-02T12:00:00-01:00"), RDF::Literal::DateTime.new("2002-04-02T17:00:00+04:00")],
        "datetime 2" => [RDF::Literal::DateTime.new("2002-04-02T12:00:00-05:00"), RDF::Literal::DateTime.new("2002-04-02T23:00:00+06:00")],
        "datetime 4" => [RDF::Literal::DateTime.new("2002-04-02T23:00:00-04:00"), RDF::Literal::DateTime.new("2002-04-03T02:00:00-01:00")],
        "datetime 5" => [RDF::Literal::DateTime.new("1999-12-31T24:00:00-05:00"), RDF::Literal::DateTime.new("2000-01-01T00:00:00-05:00")],
        "eq-1 1='01'^xsd:integer" => [RDF::Literal(1), RDF::Literal::Integer.new("01")],
        "eq-1 1='1.0e0'^xsd:double" => [RDF::Literal(1), RDF::Literal::Double.new("1.0e0")],
        "eq-1 1=1.0" => [RDF::Literal(1), RDF::Literal(1.0)],
        "eq-2-1 1.0e0=1.0" => [RDF::Literal::Double.new("1.0e0"), RDF::Literal::Double.new("1.0")],
        "eq-2-1 1='1'^xsd:decimal" => [RDF::Literal(1), RDF::Literal::Decimal.new("1")],
        "open-eq-03 '01'^xsd:integer=1" => [RDF::Literal::Integer.new("01"), RDF::Literal(1)],
        "term-6 '456.'^^xsd:decimal='456.0'^^xsd:decimal" => [RDF::Literal::Decimal.new("456."), RDF::Literal::Decimal.new("456.0")],
      }.each do |label, (left, right)|
        it "returns false for #{label}" do
          expect(left).not_to eql right
        end
      end
    end
  end

  context "Examples" do
    it "Creating a plain literal" do
      value = RDF::Literal.new("Hello, world!")
      expect(value).to be_plain
    end

    it "Creating a language-tagged literal (1)" do
      value = RDF::Literal.new("Hello, world!", language: :en)
      expect(value).to have_language
      expect(value.language).to eq :en
    end

    it "Creating a language-tagged literal (2)" do
      expect {
        RDF::Literal.new("Wazup?", language: :"en-US")
        RDF::Literal.new("Hej!",   language: :sv)
        RDF::Literal.new("¡Hola!", language: :es)
      }.not_to raise_error
    end

    it "Creating an explicitly datatyped literal" do
      value = RDF::Literal.new("2009-12-31", datatype: RDF::XSD.date)
      expect(value).to have_datatype
      expect(value.datatype).to eq XSD.date
    end

    it "Creating an implicitly datatyped literal" do
      value = RDF::Literal.new(Date.today)
      expect(value).to have_datatype
      expect(value.datatype).to eq XSD.date
    end

    it "Creating an implicitly datatyped literals" do
      {
        RDF::Literal.new(false).datatype               => XSD.boolean,
        RDF::Literal.new(true).datatype                => XSD.boolean,
        RDF::Literal.new(123).datatype                 => XSD.integer,
        RDF::Literal.new(9223372036854775807).datatype => XSD.integer,
        RDF::Literal.new(3.1415).datatype              => XSD.double,
        RDF::Literal.new(Time.now).datatype            => XSD.time,
        RDF::Literal.new(Date.new(2010)).datatype      => XSD.date,
        RDF::Literal.new(DateTime.new(2010)).datatype  => XSD.dateTime,
      }.each do |input, output|
        expect(input).to eq output
      end
    end

    it(:eql?) do
      expect(RDF::Literal(1)).not_to eql(RDF::Literal(1.0))
    end

    it(:==) do
      expect(RDF::Literal(1)).to eq RDF::Literal(1.0)
    end
  end
end
