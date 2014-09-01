# coding: utf-8
require File.join(File.dirname(__FILE__), 'spec_helper')

describe RDF::Literal do
  XSD = RDF::XSD

  def self.literal(selector)
    case selector
    when :empty       then [''.freeze]
    when :plain       then ['Hello'.freeze]
    when :empty_lang  then [''.freeze, {language: :en}]
    when :plain_lang  then ['Hello'.freeze, {language: :en}]
    when :string      then ['String.freeze', {datatype: RDF::XSD.string}]
    when :false       then [false]
    when :true        then [true]
    when :int         then [123]
    when :long        then [9223372036854775807]
    when :double      then [3.1415]
    when :date        then [Date.new(2010)]
    when :datetime    then [DateTime.new(2011)]
    when :time        then [Time.parse('01:02:03Z')]
    when :date        then [Date.new(2010)]
    else
      raise("unexpected literal: :#{selector}")
    end
  end

  def self.literals(*selector)
    selector.inject([]) do |ary, sel|
      ary += case sel
      when :all_simple        then [:empty, :plain, :string].map {|sel| literal(sel)}
      when :all_plain_lang    then [:empty_lang, :plain_lang].map {|sel| literal(sel)}
      when :all_native        then [:false, :true, :int, :long, :double, :time, :date, :datetime].map {|sel| literal(sel)}
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

      {
        "true"  => "true",
        "false" => "false",
        "tRuE"  => "true",
        "FaLsE" => "false",
        "1"     => "true",
        "0"     => "false",
      }.each_pair do |value, str|
        it "does not normalize boolean '#{value}' by default" do
          expect(RDF::Literal.new(value, datatype: RDF::XSD.boolean, canonicalize: false).to_s).to eq value
        end

        it "normalizes boolean '#{value}' to '#{str}'" do
          expect(RDF::Literal.new(value, datatype: RDF::XSD.boolean, canonicalize: true).to_s).to eq str
        end

        it "instantiates '#{value}' as RDF::Literal::Boolean" do
          expect(RDF::Literal.new(value, datatype: RDF::XSD.boolean, canonicalize: true)).to be_a(RDF::Literal::Boolean)
        end

        it "causes normalized '#{value}' to be == '#{str}'" do
          expect(RDF::Literal.new(value, datatype: RDF::XSD.boolean, canonicalize: true)).to eq RDF::Literal.new(str, datatype: RDF::XSD.boolean, canonicalize: false)
        end
      end

      {
        "01" => "1",
        "1"  => "1",
        "-1" => "-1",
        "+1" => "1",
      }.each_pair do |value, str|
        it "does not normalize integer '#{value}' by default" do
          expect(RDF::Literal.new(value, datatype: RDF::XSD.integer, canonicalize: false).to_s).to eq value
        end

        it "normalizes integer '#{value}' to '#{str}'" do
          expect(RDF::Literal.new(value, datatype: RDF::XSD.integer, canonicalize: true).to_s).to eq str
        end

        it "instantiates '#{value}' as RDF::Literal::Integer" do
          expect(RDF::Literal.new(value, datatype: RDF::XSD.integer, canonicalize: true)).to be_a(RDF::Literal::Integer)
        end

        it "causes normalized '#{value}' to be == '#{str}'" do
          expect(RDF::Literal.new(value, datatype: RDF::XSD.integer, canonicalize: true)).to eq RDF::Literal.new(str, datatype: RDF::XSD.integer, canonicalize: false)
        end
      end

      {
        "1"                              => "1.0",
        "-1"                             => "-1.0",
        "1."                             => "1.0",
        "1.0"                            => "1.0",
        "1.00"                           => "1.0",
        "+001.00"                        => "1.0",
        "123.456"                        => "123.456",
        "2.345"                          => "2.345",
        "1.000000000"                    => "1.0",
        "2.3"                            => "2.3",
        "2.234000005"                    => "2.234000005",
        "2.2340000000000005"             => "2.2340000000000005",
        "2.23400000000000005"            => "2.234",
        "2.23400000000000000000005"      => "2.234",
        "1.2345678901234567890123457890" => "1.2345678901234567",
      }.each_pair do |value, str|
        it "does not normalize decimal '#{value}' by default" do
          expect(RDF::Literal.new(value, datatype: RDF::XSD.decimal, canonicalize: false).to_s).to eq value
        end

        it "normalizes decimal '#{value}' to '#{str}'" do
          expect(RDF::Literal.new(value, datatype: RDF::XSD.decimal, canonicalize: true).to_s).to eq str
        end

        it "instantiates '#{value}' as RDF::Literal::Decimal" do
          expect(RDF::Literal.new(value, datatype: RDF::XSD.decimal, canonicalize: true)).to be_a(RDF::Literal::Decimal)
        end

        it "causes normalized '#{value}' to be == '#{str}'" do
          expect(RDF::Literal.new(value, datatype: RDF::XSD.decimal, canonicalize: true)).to eq RDF::Literal.new(str, datatype: RDF::XSD.decimal, canonicalize: false)
        end
      end

      {
        "1"         => "1.0E0",
        "-1"        => "-1.0E0",
        "+01.000"   => "1.0E0",
        #"1."        => "1.0E0",
        "1.0"       => "1.0E0",
        "123.456"   => "1.23456E2",
        "1.0e+1"    => "1.0E1",
        "1.0e-10"   => "1.0E-10",
        "123.456e4" => "1.23456E6",
        "3E1"       => "3.0E1",
        "1.1e-01"   => "1.1E-1",
      }.each_pair do |value, str|
        it "does not normalize double '#{value}' by default" do
          expect(RDF::Literal.new(value, datatype: RDF::XSD.double, canonicalize: false).to_s).to eq value
        end

        it "normalizes double '#{value}' to '#{str}'" do
          expect(RDF::Literal.new(value, datatype: RDF::XSD.double, canonicalize: true).to_s).to eq str
        end

        it "instantiates '#{value}' as RDF::Literal::Double" do
          expect(RDF::Literal.new(value, datatype: RDF::XSD.double, canonicalize: true)).to be_a(RDF::Literal::Double)
        end

        it "causes normalized '#{value}' to be == '#{str}'" do
          expect(RDF::Literal.new(value, datatype: RDF::XSD.double, canonicalize: true)).to eq RDF::Literal.new(str, datatype: RDF::XSD.double, canonicalize: false)
        end
      end

      # Native representations
      [Date.today, Time.now, DateTime.now].each do |v|
        it "creates a valid literal from #{v.inspect}" do
          expect(RDF::Literal(v, canonicalize: true)).to be_valid
        end
      end

      # DateTime
      {
        "2010-01-01T00:00:00Z"      => "2010-01-01T00:00:00Z",
        "2010-01-01T00:00:00.0000Z" => "2010-01-01T00:00:00Z",
        "2010-01-01T00:00:00"       => "2010-01-01T00:00:00",
        "2010-01-01T00:00:00+00:00" => "2010-01-01T00:00:00Z",
        "2010-01-01T01:00:00+01:00" => "2010-01-01T00:00:00Z",
        "2009-12-31T23:00:00-01:00" => "2010-01-01T00:00:00Z",
        "-2010-01-01T00:00:00Z"     => "-2010-01-01T00:00:00Z",
      }.each_pair do |value, str|
        it "does not normalize dateTime '#{value}' by default" do
          expect(RDF::Literal.new(value, datatype: RDF::XSD.dateTime, canonicalize: false).to_s).to eq value
        end

        it "normalizes dateTime '#{value}' to '#{str}'" do
          expect(RDF::Literal.new(value, datatype: RDF::XSD.dateTime, canonicalize: true).to_s).to eq str
        end

        it "instantiates '#{value}' as RDF::Literal::DateTime" do
          expect(RDF::Literal.new(value, datatype: RDF::XSD.dateTime, canonicalize: true)).to be_a(RDF::Literal::DateTime)
        end

        it "causes normalized '#{value}' to be == '#{str}'" do
          expect(RDF::Literal.new(value, datatype: RDF::XSD.dateTime, canonicalize: true)).to eq RDF::Literal.new(str, datatype: RDF::XSD.dateTime, canonicalize: false)
        end
      end

      # Date
      {
        "2010-01-01Z"      => "2010-01-01Z",
        "2010-01-01"       => "2010-01-01",
        "2010-01-01+00:00" => "2010-01-01Z",
        "2010-01-01+01:00" => "2010-01-01+01:00",
        "2009-12-31-01:00" => "2009-12-31-01:00",
        "-2010-01-01Z"     => "-2010-01-01Z",
      }.each_pair do |value, str|
        it "does not normalize date '#{value}' by default" do
          expect(RDF::Literal.new(value, datatype: RDF::XSD.date, canonicalize: false).to_s).to eq value
        end

        it "normalizes date '#{value}' to '#{str}'" do
          expect(RDF::Literal.new(value, datatype: RDF::XSD.date, canonicalize: true).to_s).to eq str
        end

        it "instantiates '#{value}' as RDF::Literal::Date" do
          expect(RDF::Literal.new(value, datatype: RDF::XSD.date, canonicalize: true)).to be_a(RDF::Literal::Date)
        end

        it "causes normalized '#{value}' to be == '#{str}'" do
          expect(RDF::Literal.new(value, datatype: RDF::XSD.date, canonicalize: true)).to eq RDF::Literal.new(str, datatype: RDF::XSD.date, canonicalize: false)
        end
      end

      # Time
      {
        "00:00:00Z"      => "00:00:00Z",
        "00:00:00"       => "00:00:00",
        "00:00:00.0000Z" => "00:00:00Z",
        "00:00:00+00:00" => "00:00:00Z",
        "01:00:00+01:00" => "00:00:00Z",
        "23:00:00-01:00" => "00:00:00Z",
      }.each_pair do |value, str|
        it "does not normalize dateTime '#{value}' by default" do
          expect(RDF::Literal.new(value, datatype: RDF::XSD.time, canonicalize: false).to_s).to eq value
        end

        it "normalizes time '#{value}' to '#{str}'" do
          expect(RDF::Literal.new(value, datatype: RDF::XSD.time, canonicalize: true).to_s).to eq str
        end

        it "instantiates '#{value}' as RDF::Literal::Time" do
          expect(RDF::Literal.new(value, datatype: RDF::XSD.time, canonicalize: true)).to be_a(RDF::Literal::Time)
        end

        it "causes normalized '#{value}' to be == '#{str}'" do
          expect(RDF::Literal.new(value, datatype: RDF::XSD.time, canonicalize: true)).to eq RDF::Literal.new(str, datatype: RDF::XSD.time, canonicalize: false)
        end
      end
    end
  end

  describe "#plain?" do
    literals(:all_plain).each do |args|
      it "returns true for #{args.inspect}" do
        expect(RDF::Literal.new(*args)).to be_plain
      end
    end

    (literals(:all) - literals(:all_plain)).each do |args|
      it "returns false for #{args.inspect}" do
        expect(RDF::Literal.new(*args)).not_to be_plain
      end
    end
  end

  describe "#simple?" do
    literals(:all_simple).each do |args|
      it "returns true for #{args.inspect}" do
        expect(RDF::Literal.new(*args)).to be_simple
      end
    end

    (literals(:all) - literals(:all_simple)).each do |args|
      it "returns false for #{args.inspect}" do
        expect(RDF::Literal.new(*args)).not_to be_simple
      end
    end
  end

  describe "#language" do
    literals(:all_plain_lang).each do |args|
      it "returns language for #{args.inspect}" do
        expect(RDF::Literal.new(*args).language).to eq :en
      end
    end

    (literals(:all) - literals(:all_plain_lang)).each do |args|
      it "returns nil for #{args.inspect}" do
        expect(RDF::Literal.new(*args).language).to be_nil
      end
    end
  end

  describe "#datatype" do
    literals(:all_simple).each do |args|
      it "returns xsd:string for #{args.inspect}" do
        literal = RDF::Literal.new(*args)
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
      Time.parse("01:02:03Z") => "time"
    }.each_pair do |value, type|
      it "returns xsd.#{type} for #{value.inspect} #{value.class}" do
        expect(RDF::Literal.new(value).datatype).to eq XSD[type]
      end
    end
  end

  describe "#typed?" do
    literals(:all_simple, :all_plain_lang).each do |args|
      it "returns false for #{args.inspect}" do
        expect(RDF::Literal.new(*args)).not_to be_typed
      end
    end

    (literals(:all) - literals(:all_simple, :all_plain_lang)).each do |args|
      it "returns true for #{args.inspect}" do
        expect(RDF::Literal.new(*args)).to be_typed
      end
    end
  end

  describe "#==" do
    literals(:all_plain).each do |args|
      it "returns true for #{args.inspect}" do
        expect(RDF::Literal.new(*args)).to eq RDF::Literal.new(*args)
      end
    end

    literals(:all_simple).each do |args|
      it "returns true for value of #{args.inspect}" do
        expect(RDF::Literal.new(*args)).to eq RDF::Literal.new(*args).value
      end
    end

    literals(:all_plain_lang).each do |args|
      it "returns false for value of #{args.inspect}" do
        expect(RDF::Literal.new(*args)).not_to eq RDF::Literal.new(*args).value
      end
    end

    literals(:all_native).each do |args|
      it "returns true for #{args.inspect}" do
        expect(RDF::Literal.new(*args)).to eq RDF::Literal.new(*args)
      end

      it "returns true for value of #{args.inspect}" do
        literal = RDF::Literal.new(*args)
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
        literal = RDF::Literal.new(*args)
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
        literal = RDF::Literal.new(*args)
        expect(literal.to_s).to eql(rep)
      end
    end
  end

  describe "#object" do
    literals(:all_plain).each do |args|
      it "returns value for #{args.inspect}" do
        literal = RDF::Literal.new(*args)
        expect(literal.object).to eql(literal.value)
      end
    end

    {
      literal(:int)      => 123,
      literal(:true)     => true,
      literal(:false)    => false,
      literal(:long)     => 9223372036854775807,
      literal(:double)   => 3.1415,
      literal(:date)     => Date.new(2010),
      literal(:datetime) => DateTime.new(2011),
      literal(:time)     => Time.parse('01:02:03Z')
    }.each_pair do |args, value|
      it "returns object for #{args.inspect}" do
        literal = RDF::Literal.new(*args)
        expect(literal.object).to eql(value)
      end
    end
  end

  describe "#anonymous?" do
    it "returns false" do
      expect(RDF::Literal.new("")).not_to be_anonymous
    end
  end

  describe "#valid?" do
    # Boolean
    {
      "true"  => "true",
      "false" => "false",
      "tRuE"  => "true",
      "FaLsE" => "false",
      "1"     => "true",
      "0"     => "false",
    }.each_pair do |value, str|
      it "validates boolean '#{value}'" do
        expect(RDF::Literal.new(value, datatype: RDF::XSD.boolean)).to be_valid
        expect(RDF::Literal.new(value, datatype: RDF::XSD.boolean)).not_to be_invalid
      end
    end

    # Integer
    {
      "01" => "1",
      "1"  => "1",
      "-1" => "-1",
      "+1" => "1",
    }.each_pair do |value, str|
      it "validates integer '#{value}'" do
        expect(RDF::Literal.new(value, datatype: RDF::XSD.integer)).to be_valid
        expect(RDF::Literal.new(value, datatype: RDF::XSD.integer)).not_to be_invalid
      end
    end

    # Decimal
    {
      "1"                              => "1.0",
      "-1"                             => "-1.0",
      "1."                             => "1.0",
      "1.0"                            => "1.0",
      "1.00"                           => "1.0",
      "+001.00"                        => "1.0",
      "123.456"                        => "123.456",
      "2.345"                          => "2.345",
      "1.000000000"                    => "1.0",
      "2.3"                            => "2.3",
      "2.234000005"                    => "2.234000005",
      "2.2340000000000005"             => "2.2340000000000005",
      "2.23400000000000005"            => "2.234",
      "2.23400000000000000000005"      => "2.234",
      "1.2345678901234567890123457890" => "1.2345678901234567",
    }.each_pair do |value, str|
      it "validates decimal '#{value}'" do
        expect(RDF::Literal.new(value, datatype: RDF::XSD.decimal)).to be_valid
        expect(RDF::Literal.new(value, datatype: RDF::XSD.decimal)).not_to be_invalid
      end
    end

    # Double
    {
      "1"         => "1.0E0",
      "-1"        => "-1.0E0",
      "+01.000"   => "1.0E0",
      #"1."        => "1.0E0",
      "1.0"       => "1.0E0",
      "123.456"   => "1.23456E2",
      "1.0e+1"    => "1.0E1",
      "1.0e-10"   => "1.0E-10",
      "123.456e4" => "1.23456E6",
      "+INF"      => "INF",
      "INF"       => "INF",
      "-INF"      => "-INF",
      "NaN"       => "NaN",
      "3E1"       => "3.0E1"
    }.each_pair do |value, str|
      it "validates double '#{value}'" do
        expect(RDF::Literal.new(value, datatype: RDF::XSD.double)).to be_valid
        expect(RDF::Literal.new(value, datatype: RDF::XSD.double)).not_to be_invalid
      end
    end

    # DateTime
    {
      "2010-01-01T00:00:00Z"      => "2010-01-01T00:00:00Z",
      "2010-01-01T00:00:00.0000Z" => "2010-01-01T00:00:00Z",
      "2010-01-01T00:00:00"       => "2010-01-01T00:00:00Z",
      "2010-01-01T00:00:00+00:00" => "2010-01-01T00:00:00Z",
      "2010-01-01T01:00:00+01:00" => "2010-01-01T01:00:00+01:00",
      "2009-12-31T23:00:00-01:00" => "2009-12-31T23:00:00-01:00",
      "-2010-01-01T00:00:00Z"     => "-2010-01-01T00:00:00Z",
    }.each_pair do |value, str|
      it "validates dateTime '#{value}'" do
        expect(RDF::Literal.new(value, datatype: RDF::XSD.dateTime)).to be_valid
        expect(RDF::Literal.new(value, datatype: RDF::XSD.dateTime)).not_to be_invalid
      end
    end

    # Date
    {
      "2010-01-01Z"      => "2010-01-01Z",
      "2010-01-01"       => "2010-01-01Z",
      "2010-01-01+00:00" => "2010-01-01Z",
      "2010-01-01+01:00" => "2010-01-01Z",
      "2009-12-31-01:00" => "2009-12-31Z",
      "-2010-01-01Z"     => "-2010-01-01Z",
    }.each_pair do |value, str|
      it "validates date '#{value}'" do
        expect(RDF::Literal.new(value, datatype: RDF::XSD.date)).to be_valid
        expect(RDF::Literal.new(value, datatype: RDF::XSD.date)).not_to be_invalid
      end
    end

    # Time
    {
      "00:00:00Z"      => "00:00:00Z",
      "00:00:00.0000Z" => "00:00:00Z",
      "00:00:00"       => "00:00:00Z",
      "00:00:00+00:00" => "00:00:00Z",
      "01:00:00+01:00" => "00:00:00Z",
      "23:00:00-01:00" => "00:00:00Z",
    }.each_pair do |value, str|
      it "validates time '#{value}'" do
        expect(RDF::Literal.new(value, datatype: RDF::XSD.time)).to be_valid
        expect(RDF::Literal.new(value, datatype: RDF::XSD.time)).not_to be_invalid
      end
    end
  end

  describe "#invalid?" do
    {
      "foo"                    => RDF::XSD.boolean,
      "bar"                    => RDF::XSD.integer,
      "baz"                    => RDF::XSD.decimal,
      "fub"                    => RDF::XSD.double,
      "xyz"                    => RDF::XSD.integer,
      "12xyz"                  => RDF::XSD.integer,
      "12.xyz"                 => RDF::XSD.decimal,
      "xy.z"                   => RDF::XSD.double,
      "+1.0z"                  => RDF::XSD.double,

      "+2010-01-01T00:00:00Z"  => RDF::XSD.dateTime,
      "2010-01-01T00:00:00FOO" => RDF::XSD.dateTime,
      "02010-01-01T00:00:00"   => RDF::XSD.dateTime,
      "2010-01-01"             => RDF::XSD.dateTime,
      "2010-1-1T00:00:00"      => RDF::XSD.dateTime,
      "0000-01-01T00:00:00"    => RDF::XSD.dateTime,
      "2010-07"                => RDF::XSD.dateTime,
      "2010"                   => RDF::XSD.dateTime,

      "+2010-01-01Z"           => RDF::XSD.date,
      "2010-01-01TFOO"         => RDF::XSD.date,
      "02010-01-01"            => RDF::XSD.date,
      "2010-1-1"               => RDF::XSD.date,
      "0000-01-01"             => RDF::XSD.date,
      "2011-07"                => RDF::XSD.date,
      "2011"                   => RDF::XSD.date,

      "+00:00:00Z"             => RDF::XSD.time,
      "-00:00:00Z"             => RDF::XSD.time,
    }.each_pair do |value, datatype|
      it "does not validate for '#{value}'" do
        expect(RDF::Literal.new(value, datatype: datatype)).to be_invalid
        expect(RDF::Literal.new(value, datatype: datatype)).not_to be_valid
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
      end
    end
  end

  describe RDF::Literal::Double do
    before(:each) do
      @nan = RDF::Literal::Double.new("NaN")
      @inf = RDF::Literal::Double.new("INF")
    end

    it "recognizes INF" do
      expect(@inf).to be_infinite
      expect(RDF::Literal.new('INF', datatype: RDF::Literal::Double::DATATYPE)).to eq @inf
    end

    it "recognizes -INF" do
      expect(@inf).to be_infinite
      expect(RDF::Literal.new('-INF', datatype: RDF::Literal::Double::DATATYPE)).to eq -@inf
    end

    it "recognizes NaN" do
      expect(@nan).to be_nan
      expect(RDF::Literal.new('NaN', datatype: RDF::Literal::Double::DATATYPE)).to be_nan
    end

    [-1, 0, 1].map {|n| RDF::Literal::Double.new(n)}.each do |n|
      {
        :"+" => [RDF::Literal::Double.new("INF"), RDF::Literal::Double.new("INF"), RDF::Literal::Double.new("-INF"), RDF::Literal::Double.new("-INF")],
        :"-" => [RDF::Literal::Double.new("INF"), RDF::Literal::Double.new("-INF"), RDF::Literal::Double.new("-INF"), RDF::Literal::Double.new("INF")],
      }.each do |op, (lp, rp, lm, rm)|
        it "returns #{lp} for INF #{op} #{n}" do
          expect(@inf.send(op, n)).to eq lp
        end

        it "returns #{rp} for #{n} #{op} INF" do
          expect(n.send(op, @inf)).to eq rp
        end

        it "returns #{lm} for -INF #{op} #{n}" do
          expect((-@inf).send(op, n)).to eq lm
        end

        it "returns #{rm} for #{n} #{op} -INF" do
          expect(n.send(op, -@inf)).to eq rm
        end
      end

      it "#{n} + NaN" do
        expect(n + -@nan).to be_nan
        expect(-@nan + n).to be_nan
      end
    end

    # Multiplication
    {
      -1 => [RDF::Literal::Double.new("-INF"), RDF::Literal::Double.new("-INF")],
      0  => [:nan, :nan],
      1  => [RDF::Literal::Double.new("INF"), RDF::Literal::Double.new("INF")],
    }.each do |n, (p, m)|
      it "returns #{p} for #{n} * INF" do
        if p == :nan
          expect(RDF::Literal::Double.new(n) * @inf).to be_nan
        else
          expect(RDF::Literal::Double.new(n) * @inf).to eq p
        end
      end

      it "returns #{p} for INF * #{n}" do
        if p == :nan
          expect(@inf * RDF::Literal::Double.new(n)).to be_nan
        else
          expect(@inf * RDF::Literal::Double.new(n)).to eq p
        end
      end
    end

    it "adds infinities" do
      expect(@inf + @inf).to eq @inf
      expect(@inf + -@inf).to be_nan
      expect(-@inf + -@inf).to eq -@inf
      expect(-@inf + @inf).to be_nan
    end

    it "adds NaN" do
      expect(@inf + @nan).to be_nan
      expect(@nan + @nan).to be_nan
    end
  end

  describe RDF::Literal::DateTime do
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

  describe RDF::Literal::Time do
    subject {
      double("time", :to_s => "05:50:00")
    }
    it "parses as string if #to_time raises an error" do
      expect(subject).to receive(:to_time).at_least(:once).and_raise(StandardError)
      expect {RDF::Literal::Time.new(subject)}.not_to raise_error
      expect(RDF::Literal::Time.new(subject).object).to eq ::Time.parse(subject.to_s)
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
        "no language with rdf:langString" => {value: "foo", datatype: RDF::langString},
      }.each do |name, opts|
        it "raises error for #{name}" do
          expect {RDF::Literal.new(opts.delete(:value), opts)}.to raise_error(ArgumentError)
        end
      end

      {
        "no language with xsd:string" => {value: "foo", datatype: RDF::XSD.string},
        "no language with xsd:date" => {value: "foo", datatype: RDF::XSD.date},
        "language with rdf:langString" => {value: "foo", language: "en", datatype: RDF::langString},
      }.each do |name, opts|
        it "should not raise error for #{name}" do
          expect {RDF::Literal.new(opts.delete(:value), opts)}.not_to raise_error
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
        "open-eq-08 'xyz'='xyz'^^<unknown>" => [RDF::Literal("xyz"), RDF::Literal.new("xyz", datatype: RDF::URI("unknown"))],
        "open-eq-08 'xyz'='xyz'^^xsd:integer" => [RDF::Literal("xyz"), RDF::Literal("xyz", datatype: XSD.integer)],
        "open-eq-08 'xyz'='xyz'^^xsd:integer" => [RDF::Literal("xyz"), RDF::Literal::Integer.new("xyz")],
        "open-eq-08 'xyz'^^<unknown>='xyz'" => [RDF::Literal("xyz", datatype: RDF::URI("unknown")), RDF::Literal("xyz")],
        "open-eq-08 'xyz'^^<unknown>='xyz'" => [RDF::Literal("xyz", datatype: RDF::URI("unknown")), RDF::Literal.new("xyz")],
        "open-eq-08 'xyz'^^xsd:integer='xyz'" => [RDF::Literal("xyz", datatype: XSD.integer), RDF::Literal("xyz")],
        "open-eq-08 'xyz'^^xsd:integer='xyz'" => [RDF::Literal::Integer.new("xyz"), RDF::Literal.new("xyz")],
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
