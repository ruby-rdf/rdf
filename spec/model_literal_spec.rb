# coding: utf-8
# frozen_string_literal: true
require_relative 'spec_helper'
require 'rdf/spec/literal'
require 'rdf/xsd'

describe RDF::Literal do
  XSD = RDF::XSD

  def self.literal(selector)
    case selector
    when :empty       then ['']
    when :plain       then ['Hello']
    when :empty_lang  then ['', {language: :en}]
    when :plain_lang  then ['Hello', {language: :en}]
    # langString language: must not contain spaces
    when :wrong_lang  then ['WrongLang', {language: "en f"}]
    # langString language: must be non-empty valid language
    when :unset_lang  then ['NoLanguage', {datatype: RDF.langString}]
    when :lang_dir    then ['Hello', {language: :en, direction: :ltr}]
    when :wrong_dir    then ['Hello', {language: :en, direction: "center-out"}]
    when :dir_no_lang then ['Hello', {direction: :ltr}]
    when :unset_dir   then ['NoDir', {language: :en, datatype: RDF.dirLangString}]
    when :string      then ['String', {datatype: RDF::XSD.string}]
    when :false       then [false]
    when :true        then [true]
    when :int         then [123]
    when :long        then [9223372036854775807]
    when :double      then [3.1415]
    when :decimal     then [BigDecimal("1.2")]
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
      when :all_simple        then %i(empty plain string).map {|s| literal(s)}
      when :all_plain_lang    then %i(empty_lang plain_lang lang_dir).map {|s| literal(s)}
      when :all_native        then %i(false true int long decimal double time date datetime).map {|s| literal(s)}
      when :all_invalid_lang  then %i(wrong_lang unset_lang wrong_dir).map {|s| literal(s)}
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

  describe "#english?" do
    literals(:all).each do |args|
      options = args.last.is_a?(Hash) ? args.pop : {}
      lit = RDF::Literal.new(*args, **options)
      if lit.language? && lit.language.to_s.downcase.start_with?('en')
        it "returns true for #{lit.inspect}" do
          expect(lit).to be_english
        end
      else
        it "returns false for #{lit.inspect}" do
          expect(lit).not_to be_english
        end
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
      BigDecimal("1.2") => "decimal",
      Date.new(2010) => "date",
      DateTime.new(2011) => "dateTime",
      Rational("1/3") => "double",
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
    expect(RDF::Literal('foo')).to be_start_with('foo', 'nope')
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
      literal(:date)     => ::DateTime.new(2010),
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
          expect(described_class.new(obj).to_s).to eql str
        end

        it "canonicalizes #{obj} to #{canon.inspect}" do
          expect(described_class.new(obj, canonicalize: true).to_s).to eql canon
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
          expect(described_class.new(obj).to_s).to eql str
        end

        it "canonicalizes #{obj} to #{canon.inspect}" do
          expect(described_class.new(obj, canonicalize: true).to_s).to eql canon
        end
      end
    end

    describe "#**", skip: (RUBY_ENGINE == "jruby") do
      {
        "2^3":        [2, 3, 8],
        "-2^3":       [-2, 3, -8],
        "2^-3":       [2, -3, 0.125e0],
        "-2^-3":      [-2, -3, -0.125e0],
        "2^0":        [2, 0, 1],
        "0^0":        [0, 0, 1],
        "0^4":        [0, 4, 0],
        "0^-4":       [0, -4, RDF::Literal::Double.new('INF')],
        "16^0.5e0":   [16, 0.5e0, 4.0e0],
        "16^0.25e0":  [16, 0.25e0, 2.0e0],
        "-1^INF":     [-1, RDF::Literal::Double.new('INF'), 1.0e0],
        "-1^-INF":    [-1, RDF::Literal::Double.new('-INF'), 1.0e0],
        "1^INF":      [1, RDF::Literal::Double.new('INF'), 1.0e0],
        "1^-INF":     [1, RDF::Literal::Double.new('-INF'), 1.0e0],
        "1^-NaN":     [1, RDF::Literal::Double.new('NaN'), 1.0e0],
      }.each do |name, (n, e, result)|
        it name do
          expect(RDF::Literal(n) ** RDF::Literal(e)).to eq RDF::Literal(result)
          expect((RDF::Literal(n) ** RDF::Literal(e)).datatype).to eq RDF::Literal(result).datatype
        end
      end
    end

    describe "#%" do
      {
        "10 % 3": [10, 3, 1],
        "6 % -2": [6, -2, 0],
      }.each do |name, (n, e, result)|
        it name do
          expect(RDF::Literal(n) % RDF::Literal(e)).to eq RDF::Literal(result)
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
      %w(+.7                            0.7),
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
        +.7
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
          expect(described_class.new(obj).to_s).to eql str
        end

        it "canonicalizes #{obj} to #{canon.inspect}" do
          expect(described_class.new(obj, canonicalize: true).to_s).to eql canon
        end
      end
    end

    describe "#%" do
      {
        "4.5 % 1.2": [BigDecimal("4.5"), BigDecimal("1.2"), BigDecimal("0.9")],
      }.each do |name, (n, e, result)|
        it name do
          expect(RDF::Literal(n) % RDF::Literal(e)).to eq RDF::Literal(result)
        end
      end
    end

    describe "#**" do
      {
        "2.7^10": [BigDecimal("2.7"), 10, BigDecimal("20589.1132094649")],
        "2.7^10.3": [BigDecimal("2.7"), BigDecimal("10.3"), BigDecimal("27736.1879020809118")],
      }.each do |name, (n, e, result)|
        it name do
          value = RDF::Literal(n) ** RDF::Literal(e)
          expect(value).to be_within(0.00001).of(result)
          expect(value.datatype).to eq RDF::Literal(result).datatype
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
      %w(-.2e3     -2.0E2),
      %w(1.        1.0E0),
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
      #%w(NAN       NaN),
      %w(InF       INF),
      %w(3E1       3.0E1)
    ]
    it_behaves_like 'RDF::Literal validation', RDF::XSD.double,
      %w(
        1
        -1
        +01.000
        1.0
        -.2e3
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
        123.456e4 => ["1234560.0", "1.23456E6"]
      }.each do |obj, (str, canon)|
        it "to_str #{obj} to #{str.inspect}" do
          expect(described_class.new(obj).to_s).to eql str
        end

        it "canonicalizes #{obj} to #{canon.inspect}" do
          expect(described_class.new(obj, canonicalize: true).to_s).to eql canon
        end
      end
    end

    let(:nan) {described_class.new("NaN")}
    let(:inf) {described_class.new("INF")}

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

    [-1, 0, 1].map {|n| described_class.new(n)}.each do |n|
      {
        :"+" => [described_class.new("INF"), described_class.new("INF"), described_class.new("-INF"), described_class.new("-INF")],
        :"-" => [described_class.new("INF"), described_class.new("-INF"), described_class.new("-INF"), described_class.new("INF")],
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

    describe RDF::Literal::Double::PI do
      specify {expect(RDF::Literal::Double::PI.to_f).to eq Math::PI}
    end

    # Multiplication
    {
      -1 => described_class.new("-INF"),
      0  => :nan,
      1  => described_class.new("INF"),
    }.each do |n, p|
      it "returns #{p} for #{n} * INF" do
        if p == :nan
          expect(described_class.new(n) * inf).to be_nan
        else
          expect(described_class.new(n) * inf).to eq p
        end
      end

      it "returns #{p} for INF * #{n}" do
        if p == :nan
          expect(inf * described_class.new(n)).to be_nan
        else
          expect(inf * described_class.new(n)).to eq p
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
        expect(described_class.new(l).send(op, described_class.new(r))).to eql result
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

    describe "#**" do
      {
        "-0e0^-3":      [-0e0, -3, described_class.new('-INF')],
        "-0e0^-3.0e0":  [-0e0, -3.0e0, described_class.new('-INF')],
        "-0e0^-3.1e0":  [-0e0, -3.1e0, described_class.new('INF')],
        "-0e0^3":       [-0e0, 3, -0.0e0],
        "-0e0^3.1e0":   [-0e0, 3.1e0, 0.0e0],
        "-1^-INF":      [-1, described_class.new("-INF"), 1.0e0],
        "-1^INF":       [-1, described_class.new("INF"), 1.0e0],
        "-2.5e0^2.0e0": [-2.5e0, 2.0e0, 6.25e0],
        "-2^3":         [-2, 3, -8],
        "0e0^-3":       [0e0, -3, described_class.new('INF')],
        "0e0^-3.1e0":   [0e0, -3.1e0, described_class.new('INF')],
        "0e0^-4":       [0e0, -4, described_class.new('INF')],
        "0e0^3":        [0e0, 3, 0.0e0],
        "0e0^3.1e0":    [0e0, 3.1e0, 0.0e0],
        "0e0^4":        [0e0, 4, 0.0e0],
        "0^0":          [0, 0, 1],
        "0^4":          [0, 4, 0],
        "16^0.25e0":    [16, 0.25e0, 2.0e0],
        "16^0.5e0":     [16, 0.5e0, 4.0e0],
        "1^-INF":       [1, described_class.new('-INF'), 1.0e0],
        "1^INF":        [1, described_class.new('INF'), 1.0e0],
        "1^NaN":        [1, described_class.new('NaN'), 1.0e0],
        "2^-3":         [2, -3, 0.125e0],
        "2^0":          [2, 0, 1],
        "2^3":          [2, 3, 8],
        "INF^0":        [described_class.new('INF'), 0, 1.0e0],
        "NaN^0":        [described_class.new('NaN'), 0, 1.0e0],
        "PI^0":         [described_class.const_get('PI'), 0, 1.0e0],
      }.each do |name, (n, e, result)|
        it name do
          expect(RDF::Literal(n) ** RDF::Literal(e)).to eq RDF::Literal(result)
          expect((RDF::Literal(n) ** RDF::Literal(e)).datatype).to eq RDF::Literal(result).datatype
        end
      end

      context '#infinite?' do
        {
          "0e0^-3": [0e0, -3],
          "0e0^-4": [0e0, -4],
          "-0e0^-3": [-0e0, -3],
          "0e0^-3.0e0": [0e0, -3.0e0],
          "-0e0^-3.0e0": [-0e0, -3.0e0],
          "0^-4": [0, -4],
        }.each do |name, (n, e)|
          specify(name) {expect((RDF::Literal(n) ** RDF::Literal(e)).infinite?).to be_truthy}
        end
      end

      context '#nan?' do
        {
          #"-2.5e0^2.00000001e0": [-2.5e0, 2.00000001e0]
        }.each do |name, (n, e)|
          specify(name) {expect((RDF::Literal(n) ** RDF::Literal(e)).nan?).to be_truthy}
        end
      end
    end

    describe "#%" do
      {
        "0e0 % 3": [1.23e2, 0.6e1, 3.0e0],
      }.each do |name, (n, e, result)|
        it name do
          expect(RDF::Literal(n) % RDF::Literal(e)).to eq RDF::Literal(result)
        end
      end
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
        DateTime.parse("2010-01-01T00:00:00Z")      => ["2010-01-01T00:00:00Z",       "2010-01-01T00:00:00Z"],
        DateTime.parse("2010-02-01T00:00:00")       => ["2010-02-01T00:00:00Z",       "2010-02-01T00:00:00Z"],
        DateTime.parse("2010-03-01T04:00:00+01:00") => ["2010-03-01T04:00:00+01:00",  "2010-03-01T03:00:00Z"],
        DateTime.parse("2009-12-31T04:00:00-01:00") => ["2009-12-31T04:00:00-01:00",  "2009-12-31T05:00:00Z"],
        DateTime.parse("-2010-01-01T00:00:00Z")     => ["-2010-01-01T00:00:00Z",      "-2010-01-01T00:00:00Z"],
      }.each do |obj, (str, canon)|
        it "to_str #{obj} to #{str.inspect}" do
          expect(described_class.new(obj).to_s).to eql str
        end

        it "canonicalizes #{obj} to #{canon.inspect}" do
          expect(described_class.new(obj, canonicalize: true).to_s).to eql canon
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
          expect(described_class.new(l).tz).to eq RDF::Literal(r)
        end
      end
    end

    describe "#timezone" do
      {
        "2010-06-21T11:28:01Z"      => RDF::Literal("PT0H", datatype: RDF::XSD.dayTimeDuration),
        "2010-12-21T15:38:02-08:00" => RDF::Literal("-PT8H", datatype: RDF::XSD.dayTimeDuration),
        "2010-12-21T15:38:02+08:00" => RDF::Literal("PT8H", datatype: RDF::XSD.dayTimeDuration),
        "2008-06-20T23:59:00Z"      => RDF::Literal("PT0H", datatype: RDF::XSD.dayTimeDuration),
        "2011-02-01T01:02:03"       => nil,
      }.each do |l, r|
        it "#{l} => #{r.inspect}" do
          expect(described_class.new(l).timezone).to eq r
        end
      end
    end

    describe "#adjust_to_timezone" do
      {
        # Spec examples
        ["2002-03-07T10:00:00"]                   => "2002-03-07T10:00:00Z",
        ["2002-03-07T10:00:00-07:00"]             => "2002-03-07T17:00:00Z",
        ["2002-03-07T10:00:00", "-PT10H"]         => "2002-03-07T10:00:00-10:00",
        ["2002-03-07T10:00:00-07:00", "-PT10H"]   => "2002-03-07T07:00:00-10:00",
        ["2002-03-07T10:00:00-07:00", "PT10H"]    => "2002-03-08T03:00:00+10:00",
        ["2002-03-07T00:00:00+01:00", "-PT8H"]    => "2002-03-06T15:00:00-08:00",
        ["2002-03-07T10:00:00", nil]              => "2002-03-07T10:00:00",
        ["2002-03-07T10:00:00-07:00", nil]        => "2002-03-07T10:00:00",
      }.each do |args, r|
        if r == ArgumentError
          it "#{args.inspect} raises ArgumentError" do
            source = described_class.new(args.shift)
            expect {source.adjust_to_timezone(*args)}.to raise_error(ArgumentError)
          end
        else
          it "#{args.inspect} => #{r.inspect}" do
            source = described_class.new(args.shift)
            result = described_class.new(r)
            expect(source.adjust_to_timezone(*args)).to eq result
          end
        end
      end

      {
        # Test Suite https://github.com/w3c/qt3tests/blob/master/fn/adjust-dateTime-to-timezone.xml
        "fn-adjust-dateTime-to-timezone1args-1": ["1970-01-01T00:00:00Z",       "-PT10H",   "1969-12-31T14:00:00-10:00"],
        "fn-adjust-dateTime-to-timezone1args-2": ["1996-04-07T01:40:52Z",       "-PT10H",   "1996-04-06T15:40:52-10:00"],
        "fn-adjust-dateTime-to-timezone1args-3": ["2030-12-31T23:59:59Z",       "-PT10H",   "2030-12-31T13:59:59-10:00"],
        "fn-adjust-dateTime-to-timezone-1":      ["2002-03-07T10:00:00-05:00",  "-PT5H0M",  "2002-03-07T10:00:00-05:00"],
        "fn-adjust-dateTime-to-timezone-2":      ["2002-03-07T10:00:00-07:00",  "-PT5H0M",  "2002-03-07T12:00:00-05:00"],
        "fn-adjust-dateTime-to-timezone-3":      ["2002-03-07T10:00:00",        "-PT10H",   "2002-03-07T10:00:00-10:00"],
        "fn-adjust-dateTime-to-timezone-4":      ["2002-03-07T10:00:00-07:00",  "-PT10H",   "2002-03-07T07:00:00-10:00"],
        "fn-adjust-dateTime-to-timezone-5":      ["2002-03-07T10:00:00-07:00",  "PT10H",    "2002-03-08T03:00:00+10:00"],
        "fn-adjust-dateTime-to-timezone-6":      ["2002-03-07T00:00:00+01:00",  "-PT8H",    "2002-03-06T15:00:00-08:00"],
        "fn-adjust-dateTime-to-timezone-7":      ["2002-03-07T10:00:00",                    "2002-03-07T10:00:00"],
        "fn-adjust-dateTime-to-timezone-8":      ["2002-03-07T10:00:00-07:00",  nil,        "2002-03-07T10:00:00"],
        "fn-adjust-dateTime-to-timezone-11":     ["2002-03-07T10:00:00-04:00",  nil,        "2002-03-07T10:00:00"],
        "K-AdjDateTimeToTimezoneFunc-7":         ["2001-02-03T08:02:00",        "PT14H1M",  ArgumentError],
        "K-AdjDateTimeToTimezoneFunc-8":         ["2001-02-03T08:02:00",        "-PT14H1M", ArgumentError],
        "K-AdjDateTimeToTimezoneFunc-9":         ["2001-02-03T08:02:00",        "PT14H0M0.001S", ArgumentError],
      }.each do |title, (*args, r)|
        it title do
          source = described_class.new(args.shift)
          if r == ArgumentError
            expect {source.adjust_to_timezone(*args)}.to raise_error(ArgumentError)
          else
            result = described_class.new(r)
            expect(source.adjust_to_timezone(*args)).to eq result
          end
        end
      end
    end

    describe "#==" do
      {
        ["2002-04-02T12:00:00-01:00", "2002-04-02T17:00:00+04:00"] => true,
        ["2002-04-02T12:00:00",       "2002-04-02T23:00:00+06:00"] => false,
        ["2002-04-02T12:00:00",       "2002-04-02T17:00:00"] => false,
        ["2002-04-02T12:00:00",       "2002-04-02T12:00:00"] => true,
        ["2002-04-02T23:00:00-04:00", "2002-04-03T02:00:00-01:00"] => true,
        ["1999-12-31T24:00:00",       "2000-01-01T00:00:00"] => true,
        ["2005-04-04T24:00:00",       "2005-04-04T00:00:00"] => false,
      }.each do |(a, b), res|
        if res
          it "#{a} == #{b}" do
            expect(described_class.new(a)).to eq described_class.new(b)
          end
        else
          it "#{a} != #{b}" do
            expect(described_class.new(a)).not_to eq described_class.new(b)
          end
        end
      end
    end

    describe "#<" do
      {
        ["2010-06-21T11:28:01Z", "2010-06-21T11:28:01Z"] => false,
        ["2010-06-21T11:28:01Z", "2010-06-21T11:28:02Z"] => true,
        ["2010-06-21T11:28:01Z", "2010-06-21T11:28:00Z"] => false,
        ["2010-06-21T02:28:00Z", "2010-06-21T11:28:00-08:00"] => true,
      }.each do |(a, b), res|
        if res
          it "#{a} < #{b}" do
            expect(described_class.new(a)).to be < described_class.new(b)
            expect(described_class.new(a)).not_to be >= described_class.new(b)
          end
        else
          it "#{a} !< #{b}" do
            expect(described_class.new(a)).not_to be < described_class.new(b)
            expect(described_class.new(a)).to be >= described_class.new(b)
          end
        end
      end
    end

    describe "#>" do
      {
        ["2010-06-21T11:28:01Z", "2010-06-21T11:28:01Z"] => false,
        ["2010-06-21T11:28:01Z", "2010-06-21T11:28:02Z"] => false,
        ["2010-06-21T11:28:01Z", "2010-06-21T11:28:00Z"] => true,
        ["2010-06-21T02:28:00Z", "2010-06-21T11:28:00-08:00"] => false,
      }.each do |(a, b), res|
        if res
          it "#{a} > #{b}" do
            expect(described_class.new(a)).to be > described_class.new(b)
            expect(described_class.new(a)).not_to be <= described_class.new(b)
          end
        else
          it "#{a} !> #{b}" do
            expect(described_class.new(a)).not_to be > described_class.new(b)
            expect(described_class.new(a)).to be <= described_class.new(b)
          end
        end
      end
    end

    describe "#+" do
      context "xsd:dayTimeDuration" do
        {
          ["2000-10-30T11:12:00", "P3DT1H15M"] => "2000-11-02T12:27:00",
          ["2000-10-30T11:12:00Z", "P3DT1H15M"] => "2000-11-02T12:27:00Z",
          ["2000-10-30T11:12:00-08:00", "P3DT1H15M"] => "2000-11-02T12:27:00-08:00",
          ["2000-10-30T11:12:00", "-P3D"] => "2000-10-27T11:12:00",
        }.each do |(t, d), res|
          it "#{t} + #{d} == #{res}" do
            t1 = described_class.new(t)
            dur = RDF::Literal(d, datatype: RDF::XSD.dayTimeDuration)
            expect(t1 + dur).to eq described_class.new(res)
          end
        end
      end

      context "xsd:yearMonthDuration" do
        {
          ["2000-10-30T11:12:00", "P1Y2M"] => "2001-12-30T11:12:00",
          ["2000-10-30T11:12:00Z", "P1Y2M"] => "2001-12-30T11:12:00Z",
          ["2000-10-30T11:12:00-08:00", "P1Y2M"] => "2001-12-30T11:12:00-08:00",
          ["2000-10-30T11:12:00", "-P1Y2M"] => "1999-08-30T11:12:00",
        }.each do |(t, d), res|
          it "#{t} + #{d} == #{res}" do
            t1 = described_class.new(t)
            dur = RDF::Literal(d, datatype: RDF::XSD.yearMonthDuration)
            expect(t1 + dur).to eq described_class.new(res)
          end
        end
      end
    end

    describe "#-" do
      context "xsd:dayTimeDuration" do
        {
          ["2000-10-30T11:12:00", "P3DT1H15M"] => "2000-10-27T09:57:00",
          ["2000-10-30T11:12:00Z", "P3DT1H15M"] => "2000-10-27T09:57:00Z",
          ["2000-10-30T11:12:00-08:00", "P3DT1H15M"] => "2000-10-27T09:57:00-08:00",
          ["2000-10-30T11:12:00", "-P3D"] => "2000-11-02T11:12:00",
        }.each do |(t, d), res|
          it "#{t} - #{d} == #{res}" do
            t1 = described_class.new(t)
            dur = RDF::Literal(d, datatype: RDF::XSD.dayTimeDuration)
            expect(t1 - dur).to eq described_class.new(res)
          end
        end
      end

      context "xsd:yearMonthDuration" do
        {
          ["2000-10-30T11:12:00", "P1Y2M"] => "1999-08-30T11:12:00",
          ["2000-10-30T11:12:00Z", "P1Y2M"] => "1999-08-30T11:12:00Z",
          ["2000-10-30T11:12:00-08:00", "P1Y2M"] => "1999-08-30T11:12:00-08:00",
          ["2000-10-30T11:12:00", "-P1Y2M"] => "2001-12-30T11:12:00",
        }.each do |(t, d), res|
          it "#{t} - #{d} == #{res}" do
            t1 = described_class.new(t)
            dur = RDF::Literal(d, datatype: RDF::XSD.yearMonthDuration)
            expect(t1 - dur).to eq described_class.new(res)
          end
        end
      end

      context "xsd:dateTime" do
        {
          ["2000-10-30T11:12:00", "2000-08-30T11:12:00"] => "P61D",
          ["2000-10-30T11:12:00Z", "2000-08-30T11:12:00Z"] => "P61D",
          ["2000-10-30T11:12:00-08:00", "2000-08-30T11:12:00-08:00"] => "P61D",
          ["2000-10-30T11:12:00", "2000-12-30T11:12:00"] => "-P61D",
          ["2000-10-30T06:12:00-05:00", "1999-11-28T09:00:00Z"] => "P337DT2H12M",
        }.each do |(t1, t2), res|
          it "#{t1} - #{t2} == #{res}" do
            t1 = described_class.new(t1)
            t2 = described_class.new(t2)
            res = RDF::Literal(res, datatype: RDF::XSD.dayTimeDuration)
            expect(t1 - t2).to eq res
          end
        end
      end
    end
  end

  describe RDF::Literal::Date do
    it_behaves_like 'RDF::Literal with datatype and grammar', "2010-01-01T00:00:00Z", RDF::XSD.date
    it_behaves_like 'RDF::Literal equality', "2010-01-01Z", DateTime.parse("2010-01-01T00:00:00+00:00")
    it_behaves_like 'RDF::Literal lexical values', "2010-01-01Z"
    it_behaves_like 'RDF::Literal canonicalization', RDF::XSD.date, [
      ["2010-01-01Z",     "2010-01-01Z",      "Friday, 01 January 2010 UTC"],
      ["2010-01-01",      "2010-01-01",       "Friday, 01 January 2010"],
      ["2010-01-01+00:00","2010-01-01Z",      "Friday, 01 January 2010 UTC"],
      ["2010-01-01+01:00","2009-12-31Z",      "Friday, 01 January 2010 +01:00"],
      ["2009-12-31-01:00","2009-12-31Z",      "Thursday, 31 December 2009 -01:00"],
      ["-2010-01-01Z",    "-2010-01-01Z",     "Friday, 01 January -2010 UTC"],
      ["2014-09-01-08:00","2014-09-01Z",      "Monday, 01 September 2014 -08:00"],
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
        ::Date.parse("2010-02-01")  => ["2010-02-01", "2010-02-01"],
        ::Date.parse("-2010-01-01") => ["-2010-01-01","-2010-01-01"],
        ::DateTime.parse("2014-09-01T00:00:00-08:00") => ["2014-09-01", "2014-09-01"],
      }.each do |obj, (str, canon)|
        it "to_str #{obj} to #{str.inspect}" do
          expect(described_class.new(obj).to_s).to eql str
        end

        it "canonicalizes #{obj} to #{canon.inspect}" do
          expect(described_class.new(obj, canonicalize: true).to_s).to eql canon
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
          expect(described_class.new(l).tz).to eq RDF::Literal(r)
        end
      end
    end

    describe "#timezone" do
      {
        "2010-06-21Z"      => RDF::Literal("PT0H", datatype: RDF::XSD.dayTimeDuration),
        "2010-12-21-08:00" => RDF::Literal("-PT8H", datatype: RDF::XSD.dayTimeDuration),
        "2010-12-21+08:00" => RDF::Literal("PT8H", datatype: RDF::XSD.dayTimeDuration),
        "2008-06-20Z"      => RDF::Literal("PT0H", datatype: RDF::XSD.dayTimeDuration),
        "2011-02-01"       => nil,
      }.each do |l, r|
        it "#{l} => #{r.inspect}" do
          expect(described_class.new(l).timezone).to eq r
        end
      end
    end

    describe "#adjust_to_timezone" do
      {
        # Spec examples
        ["2002-03-07"]            => "2002-03-07Z",
        ["2002-03-07-07:00"]      => "2002-03-07Z",
        ["2002-03-07", "-PT10H"]  => "2002-03-07-10:00",
        ["2002-03-07-07:00", "-PT10H"] => "2002-03-06-10:00",
        ["2002-03-07", nil]       => "2002-03-07",
        ["2002-03-07-07:00", nil] => "2002-03-07",
      }.each do |args, r|
        if r == ArgumentError
          it "#{args.inspect} raises ArgumentError" do
            source = described_class.new(args.shift)
            expect {source.adjust_to_timezone(*args)}.to raise_error(ArgumentError)
          end
        else
          it "#{args.inspect} => #{r.inspect}" do
            source = described_class.new(args.shift)
            result = described_class.new(r)
            expect(source.adjust_to_timezone(*args)).to eq result
          end
        end
      end

      {
        # Test Suite https://github.com/w3c/qt3tests/blob/master/fn/adjust-date-to-timezone.xml
        "fn-adjust-date-to-timezone1args-1": ["1970-01-01Z", "-PT10H", "1969-12-31-10:00"],
        "fn-adjust-date-to-timezone1args-2": ["1983-11-17Z", "-PT10H", "1983-11-16-10:00"],
        "fn-adjust-date-to-timezone1args-3": ["2030-12-31Z", "-PT10H", "2030-12-30-10:00"],
        "fn-adjust-date-to-timezone-1":      ["2002-03-07-05:00", "-PT5H0M", "2002-03-07-05:00"],
        "fn-adjust-date-to-timezone-2":      ["2002-03-07-07:00", "-PT5H0M", "2002-03-07-05:00"],
        "fn-adjust-date-to-timezone-3":      ["2002-03-07", "-PT10H", "2002-03-07-10:00"],
        "fn-adjust-date-to-timezone-4":      ["2002-03-07-07:00", "-PT10H", "2002-03-06-10:00"],
        "fn-adjust-date-to-timezone-5":      ["2002-03-07", nil, "2002-03-07"],
        "fn-adjust-date-to-timezone-6":      ["2002-03-07-07:00", nil, "2002-03-07"],
        "K-AdjDateToTimezoneFunc-6":         ["2001-02-03", "PT14H1M", ArgumentError],
        "K-AdjDateToTimezoneFunc-7":         ["2001-02-03", "-PT14H1M", ArgumentError],
        "K-AdjDateToTimezoneFunc-8":         ["2001-02-03", "PT14H0M0.001S", ArgumentError],
      }.each do |title, (*args, r)|
        it title do
          source = described_class.new(args.shift)
          if r == ArgumentError
            expect {source.adjust_to_timezone(*args)}.to raise_error(ArgumentError)
          else
            result = described_class.new(r)
            expect(source.adjust_to_timezone(*args)).to eq result
          end
        end
      end
    end

    describe "#==" do
      {
        ["2004-12-25Z", "2004-12-25+07:00"] => false,
        ["2004-12-25-12:00", "2004-12-26+12:00"] => true,
        ["2004-12-25Z", RDF::Literal::DateTime.new("2004-12-25Z")] => false,
        ["2004-12-25Z", RDF::Literal::Time.new("00:00:00")] => false,
      }.each do |(a, b), res|
        if res
          it "#{a} == #{b}" do
            res = b.is_a?(String) ? described_class.new(b) : b
            expect(described_class.new(a)).to eq res
          end
        else
          it "#{a} != #{b}" do
            res = b.is_a?(String) ? described_class.new(b) : b
            expect(described_class.new(a)).not_to eq res
          end
        end
      end
    end

    describe "#<" do
      {
        ["2010-06-21Z", "2010-06-20Z"]      => false,
        ["2010-06-21Z", "2010-06-21Z"]      => false,
        ["2010-06-21Z", "2010-06-22Z"]      => true,
        ["2010-06-21Z", "2010-06-21-08:00"] => true,
        ["2010-06-21Z", "2010-06-21+08:00"] => false,
      }.each do |(a, b), res|
        if res
          it "#{a} < #{b}" do
            expect(described_class.new(a)).to be < described_class.new(b)
            expect(described_class.new(a)).not_to be >= described_class.new(b)
          end
        else
          it "#{a} !< #{b}" do
            expect(described_class.new(a)).not_to be < described_class.new(b)
            expect(described_class.new(a)).to be >= described_class.new(b)
          end
        end
      end
    end

    describe "#>" do
      {
        ["2010-06-21Z", "2010-06-20Z"]      => true,
        ["2010-06-21Z", "2010-06-21Z"]      => false,
        ["2010-06-21Z", "2010-06-22Z"]      => false,
        ["2010-06-21Z", "2010-06-21-08:00"] => false,
        ["2010-06-21Z", "2010-06-21+08:00"] => true,
      }.each do |(a, b), res|
        if res
          it "#{a} > #{b}" do
            expect(described_class.new(a)).to be > described_class.new(b)
            expect(described_class.new(a)).not_to be <= described_class.new(b)
          end
        else
          it "#{a} !> #{b}" do
            expect(described_class.new(a)).not_to be > described_class.new(b)
            expect(described_class.new(a)).to be <= described_class.new(b)
          end
        end
      end
    end

    describe "#+" do
      context "xsd:dayTimeDuration" do
        {
          ["2000-10-30", "P3DT1H15M"] => "2000-11-02",
          ["2000-10-30Z", "P3DT1H15M"] => "2000-11-02Z",
          ["2000-10-30-08:00", "P3DT1H15M"] => "2000-11-02-08:00",
          ["2000-10-30", "-P3D"] => "2000-10-27",
          ["2004-10-30Z", "P2DT2H30M0S"] => "2004-11-01Z",
        }.each do |(t, d), res|
          it "#{t} + #{d} == #{res}" do
            t1 = described_class.new(t)
            dur = RDF::Literal(d, datatype: RDF::XSD.dayTimeDuration)
            expect(t1 + dur).to eq described_class.new(res)
          end
        end
      end

      context "xsd:yearMonthDuration" do
        {
          ["2000-10-30", "P1Y2M"] => "2001-12-30",
          ["2000-10-30Z", "P1Y2M"] => "2001-12-30Z",
          ["2000-10-30-08:00", "P1Y2M"] => "2001-12-30-08:00",
          ["2000-10-30", "-P1Y2M"] => "1999-08-30",
        }.each do |(t, d), res|
          it "#{t} + #{d} == #{res}" do
            t1 = described_class.new(t)
            dur = RDF::Literal(d, datatype: RDF::XSD.yearMonthDuration)
            expect(t1 + dur).to eq described_class.new(res)
          end
        end
      end

      describe "#-" do
        context "xsd:dayTimeDuration" do
          {
            ["2000-10-30", "P3DT1H15M"] => "2000-10-26",
            ["2000-10-30Z", "P3DT1H15M"] => "2000-10-26Z",
            ["2000-10-30-08:00", "P3DT1H15M"] => "2000-10-26-08:00",
          }.each do |(t, d), res|
            it "#{t} - #{d} == #{res}" do
              t1 = described_class.new(t)
              dur = RDF::Literal(d, datatype: RDF::XSD.dayTimeDuration)
              expect(t1 - dur).to eq described_class.new(res)
            end
          end
        end

        context "xsd:yearMonthDuration" do
          {
            ["2000-10-30", "P1Y2M"] => "1999-08-30",
            ["2000-02-29Z", "P1Y"] => "1999-02-28Z",
            ["2000-10-31-05:00", "P1Y1M"] => "1999-09-30-05:00",
            ["2000-10-30", "-P1Y2M"] => "2001-12-30",
          }.each do |(t, d), res|
            it "#{t} - #{d} == #{res}" do
              t1 = described_class.new(t)
              dur = RDF::Literal(d, datatype: RDF::XSD.yearMonthDuration)
              expect(t1 - dur).to eq described_class.new(res)
            end
          end
        end

        context "xsd:date" do
          {
            ["2000-10-30", "2000-08-30"] => "P61D",
            ["2000-10-30Z", "2000-08-30Z"] => "P61D",
            ["2000-10-30-08:00", "2000-08-30-08:00"] => "P61D",
            ["2000-10-30", "2000-12-30"] => "-P61D",
            ["2000-10-30-05:00", "1999-11-28Z"] => "P337DT5H",
          }.each do |(t1, t2), res|
            it "#{t1} - #{t2} == #{res}" do
              t1 = described_class.new(t1)
              t2 = described_class.new(t2)
              res = RDF::Literal(res, datatype: RDF::XSD.dayTimeDuration)
              expect(t1 - t2).to eq res
            end
          end
        end
      end
    end
  end

  describe RDF::Literal::Time do
    it_behaves_like 'RDF::Literal with datatype and grammar', "00:00:00Z", RDF::XSD.time
    it_behaves_like 'RDF::Literal equality', "00:00:00Z", DateTime.parse("1972-12-31T00:00:00Z")
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
        DateTime.parse("00:00:00Z")      => ["00:00:00Z",       "00:00:00Z"],
        DateTime.parse("01:00:00.0000Z") => ["01:00:00Z",       "01:00:00Z"],
        DateTime.parse("02:00:00")       => ["02:00:00Z",       "02:00:00Z"],
        DateTime.parse("03:00:00+00:00") => ["03:00:00Z",       "03:00:00Z"],
        DateTime.parse("05:00:00+01:00") => ["05:00:00+01:00",  "04:00:00Z"],
        DateTime.parse("07:00:00-01:00") => ["07:00:00-01:00",  "08:00:00Z"],
      }.each do |obj, (str, canon)|
        it "to_str #{obj} to #{str.inspect}" do
          expect(described_class.new(obj).to_s).to eql str
        end

        it "canonicalizes #{obj} to #{canon.inspect}" do
          expect(described_class.new(obj, canonicalize: true).to_s).to eql canon
        end
      end
    end

    describe "#tz" do
      {
        "11:28:01Z"      => "Z",
        "15:38:02-08:00" => "-08:00",
        "23:59:00Z"      => "Z",
        "01:02:03"       => "",
      }.each do |l, r|
        it "#{l} => #{r}" do
          expect(described_class.new(l).tz).to eq RDF::Literal(r)
        end
      end
    end

    describe "#timezone" do
      {
        "11:28:01Z"      => RDF::Literal("PT0H", datatype: RDF::XSD.dayTimeDuration),
        "15:38:02-08:00" => RDF::Literal("-PT8H", datatype: RDF::XSD.dayTimeDuration),
        "23:59:00Z"      => RDF::Literal("PT0H", datatype: RDF::XSD.dayTimeDuration),
        "01:02:03"       => nil,
      }.each do |l, r|
        it "#{l} => #{r.inspect}" do
          expect(described_class.new(l).timezone).to eq r
        end
      end
    end

    describe "#adjust_to_timezone" do
      {
        # Spec examples
        ["01:02:03"]                  => "01:02:03Z",
        ["01:02:03-07:00"]            => "08:02:03Z",
        ["01:02:03", "-PT10H"]        => "01:02:03-10:00",
        ["01:02:03-07:00", "-PT10H"]  => "22:02:03-10:00",
        ["01:02:03", nil]             => "01:02:03",
        ["01:02:03-07:00", nil]       => "01:02:03",
      }.each do |args, r|
        if r == ArgumentError
          it "#{args.inspect} raises ArgumentError" do
            source = described_class.new(args.shift)
            expect {source.adjust_to_timezone(*args)}.to raise_error(ArgumentError)
          end
        else
          it "#{args.inspect} => #{r.inspect}" do
            source = described_class.new(args.shift)
            result = described_class.new(r)
            expect(source.adjust_to_timezone(*args)).to eq result
          end
        end
      end

      {
        # Test Suite https://github.com/w3c/qt3tests/blob/master/fn/adjust-time-to-timezone.xml
        "fn-adjust-time-to-timezone1args-1": ["00:00:00Z",      "-PT10H",   "14:00:00-10:00"],
        "fn-adjust-time-to-timezone1args-2": ["08:03:35Z",      "-PT10H",   "22:03:35-10:00"],
        "fn-adjust-time-to-timezone1args-3": ["23:59:59Z",      "-PT10H",   "13:59:59-10:00"],
        "fn-adjust-time-to-timezone-1":      ["10:00:00-05:00", "-PT5H0M",  "10:00:00-05:00"],
        "fn-adjust-time-to-timezone-2":      ["10:00:00-07:00", "-PT5H0M",  "12:00:00-05:00"],
        "fn-adjust-time-to-timezone-3":      ["10:00:00",       "-PT10H",   "10:00:00-10:00"],
        "fn-adjust-time-to-timezone-4":      ["10:00:00-07:00", "-PT10H",   "07:00:00-10:00"],
        "fn-adjust-time-to-timezone-5":      ["10:00:00-05:00", nil,        "10:00:00"],
        "fn-adjust-time-to-timezone-6":      ["10:00:00-07:00", nil,        "10:00:00"],
        "fn-adjust-time-to-timezone-7":      ["10:00:00-07:00", "PT10H",    "03:00:00+10:00"],
        "K-AdjTimeToTimezoneFunc-6":         ["08:02:00",       "PT14H1M",  ArgumentError],
        "K-AdjTimeToTimezoneFunc-7":         ["08:02:00",       "-PT14H1M", ArgumentError],
        "K-AdjTimeToTimezoneFunc-8":         ["08:02:00",       "PT14H0M0.001S", ArgumentError],
      }.each do |title, (*args, r)|
        it title do
          source = described_class.new(args.shift)
          if r == ArgumentError
            expect {source.adjust_to_timezone(*args)}.to raise_error(ArgumentError)
          else
            result = described_class.new(r)
            expect(source.adjust_to_timezone(*args)).to eq result
          end
        end
      end
    end

    describe "#==" do
      {
        ["01:02:03Z", "01:02:03+07:00"] => false,
        ["01:02:03-12:00", "01:02:03-12:00"] => true,
        ["01:02:03Z", RDF::Literal::DateTime.new("2004-12-26T01:02:03Z")] => false,
        ["01:02:03Z", RDF::Literal::Date.new("2004-12-26")] => false,
        ["08:00:00+09:00", "17:00:00-06:00"] => false,
        ["21:30:00+10:30", "06:00:00-05:00"] => true,
        ["24:00:00+01:00", "00:00:00+01:00"] => true,
      }.each do |(a, b), res|
        if res
          it "#{a} == #{b}" do
            res = b.is_a?(String) ? described_class.new(b) : b
            expect(described_class.new(a)).to eq res
          end
        else
          it "#{a} != #{b}" do
            res = b.is_a?(String) ? described_class.new(b) : b
            expect(described_class.new(a)).not_to eq res
          end
        end
      end
    end

    describe "#<" do
      {
        ["11:28:01Z", "11:28:01Z"] => false,
        ["11:28:01Z", "11:28:02Z"] => true,
        ["11:28:01Z", "11:28:00Z"] => false,
        ["02:28:00Z", "11:28:00-08:00"] => true,
        ["12:00:00-05:00", "23:00:00+06:00"] => false,
        ["11:00:00-05:00", "17:00:00Z"] => true,
        ["23:59:59-05:00", "24:00:00-05:00"] => false,
      }.each do |(a, b), res|
        if res
          it "#{a} < #{b}" do
            expect(described_class.new(a)).to be < described_class.new(b)
            expect(described_class.new(a)).not_to be >= described_class.new(b)
          end
        else
          it "#{a} !< #{b}" do
            expect(described_class.new(a)).not_to be < described_class.new(b)
            expect(described_class.new(a)).to be >= described_class.new(b)
          end
        end
      end
    end

    describe "#>" do
      {
        ["11:28:01Z", "11:28:01Z"]      => false,
        ["11:28:01Z", "11:28:02Z"]      => false,
        ["11:28:01Z", "11:28:00Z"]      => true,
        ["08:00:00+09:00", "17:00:00-06:00"] => false,
      }.each do |(a, b), res|
        if res
          it "#{a} > #{b}" do
            expect(described_class.new(a)).to be > described_class.new(b)
            expect(described_class.new(a)).not_to be <= described_class.new(b)
          end
        else
          it "#{a} !> #{b}" do
            expect(described_class.new(a)).not_to be > described_class.new(b)
            expect(described_class.new(a)).to be <= described_class.new(b)
          end
        end
      end
    end

    describe "#+" do
      context "xsd:dayTimeDuration" do
        {
          ["11:12:00", "P3DT1H15M"] => "12:27:00",
          ["11:12:00Z", "P3DT1H15M"] => "12:27:00Z",
          ["11:12:00-08:00", "P3DT1H15M"] => "12:27:00-08:00",
          ["11:12:00", "-P3D"] => "11:12:00",
        }.each do |(t, d), res|
          it "#{t} + #{d} == #{res}" do
            t1 = described_class.new(t)
            dur = RDF::Literal(d, datatype: RDF::XSD.dayTimeDuration)
            expect(t1 + dur).to eq described_class.new(res)
          end
        end
      end
    end

    describe "#-" do
      context "xsd:dayTimeDuration" do
        {
          ["11:12:00", "P3DT1H15M"] => "09:57:00",
          ["11:12:00Z", "P3DT1H15M"] => "09:57:00Z",
          ["11:12:00-08:00", "P3DT1H15M"] => "09:57:00-08:00",
          ["11:12:00", "-PT3H"] => "14:12:00",
          ["08:20:00-05:00", "P23DT10H10M"] => "22:10:00-05:00",
        }.each do |(t, d), res|
          it "#{t} - #{d} == #{res}" do
            t1 = described_class.new(t)
            dur = RDF::Literal(d, datatype: RDF::XSD.dayTimeDuration)
            expect(t1 - dur).to eq described_class.new(res)
          end
        end
      end

      context "xsd:time" do
        {
          ["11:12:00", "09:57:00"] => "PT1H15M",
          ["11:12:00Z", "04:00:00-05:00"] => "PT2H12M",
          ["11:00:00-05:00", "21:30:00+05:30"] => "PT0S",
          ["17:00:00-06:00", "08:00:00+09:00"] => "P1D",
          ["24:00:00", "23:59:59"] => "-PT23H59M59S",
          ["11:12:00", "14:12:00"] => "-PT3H",
        }.each do |(t1, t2), res|
          it "#{t1} - #{t2} == #{res}" do
            t1 = described_class.new(t1)
            t2 = described_class.new(t2)
            res = RDF::Literal(res, datatype: RDF::XSD.dayTimeDuration)
            expect(t1 - t2).to eq res
          end
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
        expect {described_class.new(-1).abs}.to raise_error(NotImplementedError)
      end
    end

    describe "#round" do
      {
        1                  => 1,
        -1                 => -1,
        0                  => 0,
        BigDecimal("1.1")  => BigDecimal("1"),
        BigDecimal("-1.1") => BigDecimal("-1"),
        BigDecimal("0.5")  => BigDecimal("1"),
        BigDecimal("-0.5") => BigDecimal("0"),
        BigDecimal("1.5")  => BigDecimal("2"),
        BigDecimal("-1.5") => BigDecimal("-1"),
        +0.0e0             => 0.0e0,
        -0.0e0             => 0e0,
        0.5e0              => 1e0,
        -0.5e0             => -0e0,
        1.5e0              => 2e0,
        -1.5e0             => -1e0,
        1.2e0              => 1.0e0,
        -1.2e0             => -1.0e0
      }.each do |value, result|
        it "#{value} => #{result}" do
          expect(RDF::Literal(value).round).to eq RDF::Literal(result)
        end
      end

      it "Numeric does not implement #round" do
        expect {described_class.new(-1).round}.to raise_error(NotImplementedError)
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
        expect(described_class.new(-1).ceil).to eql described_class.new(-1)
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
        expect(described_class.new(-1).floor).to eql described_class.new(-1)
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
        expect(+described_class.new(1)).to eql described_class.new(1)
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

    describe "#exp" do
      {
        0                => 1.0e0,
        1                => 2.7182818284590455e0,
        2                => 7.38905609893065e0,
        -1               => 0.36787944117144233e0,
        Math::PI         => 23.140692632779267e0,
        -Float::INFINITY => 0,
      }.each do |a, res|
        it "#{a} => #{res}" do
          expect(described_class.new(a).exp).to be_within(0.000001).of(described_class.new(res))
        end
      end

      context '#nan?' do
        [Float::NAN].each do |v|
          specify("#{v}") {expect(described_class.new(v).exp.nan?).to be_truthy}
        end
      end

      context '#infinite?' do
        [Float::INFINITY].each do |v|
          specify("#{v}") {expect(described_class.new(v).exp.infinite?).to be_truthy}
        end
      end
    end

    describe "#exp10" do
      {
        0                => 1.0e0,
        1                => 1.0e1,
        0.5              => 3.1622776601683795e0,
        -1               => 1.0e-1,
        -Float::INFINITY => 0,
      }.each do |a, res|
        it "#{a} => #{res}" do
          expect(described_class.new(a).exp10).to be_within(0.000001).of(described_class.new(res))
        end
      end

      context '#nan?' do
        [Float::NAN].each do |v|
          specify("#{v}") {expect(described_class.new(v).exp10.nan?).to be_truthy}
        end
      end

      context '#infinite?' do
        [Float::INFINITY].each do |v|
          specify("#{v}") {expect(described_class.new(v).exp10.infinite?).to be_truthy}
        end
      end
    end

    describe "#log" do
      {
        Math.exp(1)      => 1.0e0,
        1.0e-3           => -6.907755278982137e0,
        2                => 0.6931471805599453e0,
      }.each do |a, res|
        it "#{a} => #{res}" do
          expect(described_class.new(a).log).to be_within(0.000001).of(described_class.new(res))
        end
      end

      context '#nan?' do
        [-1, Float::NAN, -Float::INFINITY].each do |v|
          specify("#{v}") {expect(described_class.new(v).log.nan?).to be_truthy}
        end
      end

      context '#infinite?' do
        [0, Float::INFINITY].each do |v|
          specify("#{v}") {expect(described_class.new(v).log.infinite?).to be_truthy}
        end
      end
    end

    describe "#log10" do
      {
        1.0e3            => 3,
        1.0e-3           => -3,
        2                => 0.3010299956639812e0,
      }.each do |a, res|
        it "#{a} => #{res}" do
          expect(described_class.new(a).log10).to be_within(0.000001).of(described_class.new(res))
        end
      end

      context '#nan?' do
        [-1, Float::NAN, -Float::INFINITY].each do |v|
          specify("#{v}") {expect(described_class.new(v).log10.nan?).to be_truthy}
        end
      end

      context '#infinite?' do
        [0, Float::INFINITY].each do |v|
          specify("#{v}") {expect(described_class.new(v).log10.infinite?).to be_truthy}
        end
      end
    end

    describe "#sqrt" do
      {
        0.0e0  => 0.0e0,
        -0.0e0 => -0.0e0,
        1.0e6  => 1.0e3,
        2.0e0  => 1.4142135623730951e0,
      }.each do |n, result|
        it "#{n}" do
          expect(RDF::Literal(n).sqrt).to be_within(0.000001).of(RDF::Literal(result))
        end
      end

      context '#infinite?' do
        [Float::INFINITY].each do |n|
          specify("#{n}") {expect((RDF::Literal(n).sqrt).infinite?).to be_truthy}
        end
      end

      context '#nan?' do
        [-2.0e0, -Float::INFINITY].each do |n|
          specify("#{n}") {expect((RDF::Literal(n).sqrt).nan?).to be_truthy}
        end
      end
    end

    describe "#sin" do
      {
        0           => 0.0e0,
        Math::PI/2  => 1.0e0,
        -Math::PI/2 => -1.0e0,
        Math::PI    => 0.0e0,
      }.each do |n, result|
        it "#{n}" do
          expect(RDF::Literal(n).sin).to be_within(0.000001).of(RDF::Literal(result))
        end
      end

      context '#nan?' do
        [Float::NAN, Float::INFINITY, -Float::INFINITY].each do |n|
          specify("#{n}") {expect((RDF::Literal(n).sin).nan?).to be_truthy}
        end
      end
    end

    describe "#cos" do
      {
        0           => 1.0e0,
        -0.0e0      => 1.0e0,
        Math::PI/2  => 0.0e0,
        -Math::PI/2 => 0.0e0,
        Math::PI    => -1.0e0,
      }.each do |n, result|
        it "#{n}" do
          expect(RDF::Literal(n).cos).to be_within(0.000001).of(RDF::Literal(result))
        end
      end

      context '#nan?' do
        [Float::NAN, Float::INFINITY, -Float::INFINITY].each do |n|
          specify("#{n}") {expect((RDF::Literal(n).cos).nan?).to be_truthy}
        end
      end
    end

    describe "#tan" do
      {
        0           => 0.0e0,
        -0.0e0      => -0.0e0,
        Math::PI/4  => 1.0e0,
        -Math::PI/4 => -1.0e0,
        #Math::PI/2  => 0.0e0,
        #-Math::PI/2 => -0.0e0,
        Math::PI    => 0.0e0,
        -Math::PI   => -0.0e0,
      }.each do |n, result|
        it "#{n}" do
          expect(RDF::Literal(n).tan).to be_within(0.000001).of(RDF::Literal(result))
        end
      end

      context '#nan?' do
        [Float::NAN, Float::INFINITY, -Float::INFINITY].each do |n|
          specify("#{n}") {expect((RDF::Literal(n).tan).nan?).to be_truthy}
        end
      end
    end

    describe "#asin" do
      {
        0           => 0.0e0,
        -0.0e0      => -0.0e0,
        1.0e0       => 1.5707963267948966e0,
        -1.0e0      => -1.5707963267948966e0,
      }.each do |n, result|
        it "#{n}" do
          expect(RDF::Literal(n).asin).to be_within(0.000001).of(RDF::Literal(result))
        end
      end

      context '#nan?' do
        [2.0e0, Float::NAN, Float::INFINITY, -Float::INFINITY].each do |n|
          specify("#{n}") {expect((RDF::Literal(n).asin).nan?).to be_truthy}
        end
      end
    end

    describe "#acos" do
      {
        0           => 1.5707963267948966e0,
        -0.0e0      => 1.5707963267948966e0,
        1.0e0       => 0.0e0,
        -1.0e0      => 3.141592653589793e0,
      }.each do |n, result|
        it "#{n}" do
          expect(RDF::Literal(n).acos).to be_within(0.000001).of(RDF::Literal(result))
        end
      end

      context '#nan?' do
        [2.0e0, Float::NAN, Float::INFINITY, -Float::INFINITY].each do |n|
          specify("#{n}") {expect((RDF::Literal(n).acos).nan?).to be_truthy}
        end
      end
    end

    describe "#atan" do
      {
        0                => 0.0e0,
        -0.0e0           => -0.0e0,
        1.0e0            => 0.7853981633974483e0,
        -1.0e0           => -0.7853981633974483e0,
        Float::INFINITY  => 1.5707963267948966e0,
        -Float::INFINITY => -1.5707963267948966e0,
      }.each do |n, result|
        it "#{n}" do
          expect(RDF::Literal(n).atan).to be_within(0.000001).of(RDF::Literal(result))
        end
      end

      context '#nan?' do
        [Float::NAN].each do |n|
          specify("#{n}") {expect((RDF::Literal(n).atan).nan?).to be_truthy}
        end
      end
    end

    describe "#atan2" do
      {
        "+0.0e0, 0.0e0":  [+0.0e0, 0.0e0, 0.0e0],
        "-0.0e0, 0.0e0":  [-0.0e0, 0.0e0, -0.0e0],
        "+0.0e0, -0.0e0": [+0.0e0, -0.0e0, 3.141592653589793e0],
        "-0.0e0, -0.0e0": [-0.0e0, -0.0e0, -3.141592653589793e0],
        "-1, 0.0e0":      [-1, 0.0e0, -1.5707963267948966e0],
        "+1, 0.0e0":      [+1, 0.0e0, 1.5707963267948966e0],
        "-0.0e0, -1":     [-0.0e0, -1, -3.141592653589793e0],
        "+0.0e0, -1":     [+0.0e0, -1, 3.141592653589793e0],
        "-0.0e0, +1":     [-0.0e0, +1, 0.0e0],
        "+0.0e0, +1":     [+0.0e0, +1, 0.0e0],
      }.each do |name, (a, b, result)|
        it name do
          expect(RDF::Literal(a).atan2 RDF::Literal(b)).to eq RDF::Literal(result)
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
        "direction without language" => {value: "foo", direction: "ltr"}
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
        "numeric 1=<xyz>" => [RDF::Literal(1), RDF::URI("http://example/xyz")],  # From expr-equal/expr-2-2
        "numeric 1=_:xyz" => [RDF::Literal(1), RDF::Node.new("xyz")],  # From expr-equal/expr-2-2
        "numeric <xyz>=1" => [RDF::URI("http://example/xyz"), RDF::Literal(1)],  # From expr-equal/expr-2-2
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
