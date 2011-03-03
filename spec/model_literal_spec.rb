require File.join(File.dirname(__FILE__), 'spec_helper')
require 'rdf/spec/literal'

describe RDF::Literal do
  XSD = RDF::XSD

   def self.literal(selector)
     case selector
     when :empty       then ['']
     when :plain       then ['Hello']
     when :empty_lang  then ['', {:language => :en}]
     when :plain_lang  then ['Hello', {:language => :en}]
     when :false       then [false]
     when :true        then [true]
     when :int         then [123]
     when :long        then [9223372036854775807]
     when :double      then [3.1415]
     when :date        then [Date.new(2010)]
     when :datetime    then [DateTime.new(2011)]
     when :time        then [Time.parse('01:02:03Z')]
     when :date        then [Date.new(2010)]
     when :xml_no_ns   then ["foo <sup>bar</sup> baz!", {:datatype => RDF.XMLLiteral}]
     when :xml_ns      then ["foo <sup>bar</sup> baz!", {:datatype => RDF.XMLLiteral,
                             :namespaces => {"dc" => RDF::DC.to_s}}]
     when :xml_ns2     then ["foo <sup xmlns:dc=\"http://purl.org/dc/terms/\" xmlns:rdf=\"http://www.w3.org/1999/02/22-rdf-syntax-ns#\">bar</sup> baz!",
                            {:datatype => RDF.XMLLiteral,
                            :namespaces => {"" => RDF::DC.to_s}}]
     when :xml_ns_lang then ["foo <sup>bar</sup> baz!", {:datatype => RDF.XMLLiteral,
                            :namespaces => {"dc" => RDF::DC.to_s}, :language => :fr}]
     when :xml_lang_em then ["foo <sup>bar</sup><sub xml:lang=\"en\">baz</sub>",
                            {:datatype => RDF.XMLLiteral,
                            :namespaces => {"dc" => RDF::DC.to_s},
                            :language => :fr}]
     when :xml_def_ns  then ["foo <sup>bar</sup> baz!", {:datatype => RDF.XMLLiteral,
                            :namespaces => {"" => RDF::DC.to_s}}]
     else
       raise("unexpected literal: :#{selector}")
     end
   end

   def self.literals(*selector)
     selector.inject([]) do |ary, sel|
       ary += case sel
       when :all_plain_no_lang then [:empty, :plain].map {|sel| literal(sel)}
       when :all_plain_lang    then [:empty_lang, :plain_lang].map {|sel| literal(sel)}
       when :all_native        then [:false, :true, :int, :long, :double, :time, :date, :datetime].map {|sel| literal(sel)}
       when :all_xml           then [:xml_no_ns, :xml_ns, :xml_ns2, :xml_ns_lang, :xml_lang_em, :xml_def_ns].map {|sel| literal(sel)}
       when :all_plain         then literals(:all_plain_no_lang, :all_plain_lang)
       else                         literals(:all_plain, :all_native, :all_xml)
       end
     end
   end

   describe "new" do
     it "instantiates empty string" do
       lambda { RDF::Literal.new('') }.should_not raise_error
     end

     it "instantiates empty string with language" do
       lambda { RDF::Literal.new('', :language => :en) }.should_not raise_error
     end

     it "instantiates from native datatype" do
       lambda { RDF::Literal.new(123) }.should_not raise_error
     end

     describe "c18n" do
       it "normalizes language to lower-case" do
         RDF::Literal.new('Upper', :language => :EN, :canonicalize => true).language.should == :en
       end

       it "supports sub-taged language specification" do
         RDF::Literal.new('Hi', :language => :"en-us", :canonicalize => true).language.should == :"en-us"
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
           RDF::Literal.new(value, :datatype => RDF::XSD.boolean, :canonicalize => false).to_s.should == value
         end

         it "normalizes boolean '#{value}' to '#{str}'" do
           RDF::Literal.new(value, :datatype => RDF::XSD.boolean, :canonicalize => true).to_s.should == str
         end

         it "instantiates '#{value}' as RDF::Literal::Boolean" => true do
           RDF::Literal.new(value, :datatype => RDF::XSD.boolean, :canonicalize => true).should be_a(RDF::Literal::Boolean)
         end

         it "causes normalized '#{value}' to be == '#{str}'" do
           RDF::Literal.new(value, :datatype => RDF::XSD.boolean, :canonicalize => true).should == RDF::Literal.new(str, :datatype => RDF::XSD.boolean, :canonicalize => false)
         end
       end

       {
         "01" => "1",
         "1"  => "1",
         "-1" => "-1",
         "+1" => "1",
       }.each_pair do |value, str|
         it "does not normalize integer '#{value}' by default" do
           RDF::Literal.new(value, :datatype => RDF::XSD.integer, :canonicalize => false).to_s.should == value
         end

         it "normalizes integer '#{value}' to '#{str}'" do
           RDF::Literal.new(value, :datatype => RDF::XSD.integer, :canonicalize => true).to_s.should == str
         end

         it "instantiates '#{value}' as RDF::Literal::Integer" => true do
           RDF::Literal.new(value, :datatype => RDF::XSD.integer, :canonicalize => true).should be_a(RDF::Literal::Integer)
         end

         it "causes normalized '#{value}' to be == '#{str}'" do
           RDF::Literal.new(value, :datatype => RDF::XSD.integer, :canonicalize => true).should == RDF::Literal.new(str, :datatype => RDF::XSD.integer, :canonicalize => false)
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
           RDF::Literal.new(value, :datatype => RDF::XSD.decimal, :canonicalize => false).to_s.should == value
         end

         it "normalizes decimal '#{value}' to '#{str}'" do
           RDF::Literal.new(value, :datatype => RDF::XSD.decimal, :canonicalize => true).to_s.should == str
         end

         it "instantiates '#{value}' as RDF::Literal::Decimal" => true do
           RDF::Literal.new(value, :datatype => RDF::XSD.decimal, :canonicalize => true).should be_a(RDF::Literal::Decimal)
         end

         it "causes normalized '#{value}' to be == '#{str}'" do
           RDF::Literal.new(value, :datatype => RDF::XSD.decimal, :canonicalize => true).should == RDF::Literal.new(str, :datatype => RDF::XSD.decimal, :canonicalize => false)
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
       }.each_pair do |value, str|
         it "does not normalize double '#{value}' by default" do
           RDF::Literal.new(value, :datatype => RDF::XSD.double, :canonicalize => false).to_s.should == value
         end

         it "normalizes double '#{value}' to '#{str}'" do
           RDF::Literal.new(value, :datatype => RDF::XSD.double, :canonicalize => true).to_s.should == str
         end

         it "instantiates '#{value}' as RDF::Literal::Double" => true do
           RDF::Literal.new(value, :datatype => RDF::XSD.double, :canonicalize => true).should be_a(RDF::Literal::Double)
         end

         it "causes normalized '#{value}' to be == '#{str}'" do
           RDF::Literal.new(value, :datatype => RDF::XSD.double, :canonicalize => true).should == RDF::Literal.new(str, :datatype => RDF::XSD.double, :canonicalize => false)
         end
       end

       # DateTime
       {
         "2010-01-01T00:00:00Z"      => "2010-01-01T00:00:00Z",
         "2010-01-01T00:00:00.0000Z" => "2010-01-01T00:00:00Z",
         "2010-01-01T00:00:00"       => "2010-01-01T00:00:00Z",
         "2010-01-01T00:00:00+00:00" => "2010-01-01T00:00:00Z",
         "2010-01-01T01:00:00+01:00" => "2010-01-01T00:00:00Z",
         "2009-12-31T23:00:00-01:00" => "2010-01-01T00:00:00Z",
         "-2010-01-01T00:00:00Z"     => "-2010-01-01T00:00:00Z",
       }.each_pair do |value, str|
         it "does not normalize dateTime '#{value}' by default" do
           RDF::Literal.new(value, :datatype => RDF::XSD.dateTime, :canonicalize => false).to_s.should == value
         end

         it "normalizes dateTime '#{value}' to '#{str}'" do
           RDF::Literal.new(value, :datatype => RDF::XSD.dateTime, :canonicalize => true).to_s.should == str
         end

         it "instantiates '#{value}' as RDF::Literal::DateTime" => true do
           RDF::Literal.new(value, :datatype => RDF::XSD.dateTime, :canonicalize => true).should be_a(RDF::Literal::DateTime)
         end

         it "causes normalized '#{value}' to be == '#{str}'" do
           RDF::Literal.new(value, :datatype => RDF::XSD.dateTime, :canonicalize => true).should == RDF::Literal.new(str, :datatype => RDF::XSD.dateTime, :canonicalize => false)
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
         it "does not normalize date '#{value}' by default" do
           RDF::Literal.new(value, :datatype => RDF::XSD.date, :canonicalize => false).to_s.should == value
         end

         it "normalizes date '#{value}' to '#{str}'" do
           RDF::Literal.new(value, :datatype => RDF::XSD.date, :canonicalize => true).to_s.should == str
         end

         it "instantiates '#{value}' as RDF::Literal::Date" => true do
           RDF::Literal.new(value, :datatype => RDF::XSD.date, :canonicalize => true).should be_a(RDF::Literal::Date)
         end

         it "causes normalized '#{value}' to be == '#{str}'" do
           RDF::Literal.new(value, :datatype => RDF::XSD.date, :canonicalize => true).should == RDF::Literal.new(str, :datatype => RDF::XSD.date, :canonicalize => false)
         end
       end

       # Time
       {
         "00:00:00Z"      => "00:00:00Z",
         "00:00:00.0000Z" => "00:00:00Z",
         "00:00:00+00:00" => "00:00:00Z",
         "01:00:00+01:00" => "00:00:00Z",
         "23:00:00-01:00" => "00:00:00Z",
       }.each_pair do |value, str|
         it "does not normalize dateTime '#{value}' by default" do
           RDF::Literal.new(value, :datatype => RDF::XSD.time, :canonicalize => false).to_s.should == value
         end

         it "normalizes time '#{value}' to '#{str}'" do
           RDF::Literal.new(value, :datatype => RDF::XSD.time, :canonicalize => true).to_s.should == str
         end

         it "instantiates '#{value}' as RDF::Literal::Time" => true do
           RDF::Literal.new(value, :datatype => RDF::XSD.time, :canonicalize => true).should be_a(RDF::Literal::Time)
         end

         it "causes normalized '#{value}' to be == '#{str}'" do
           RDF::Literal.new(value, :datatype => RDF::XSD.time, :canonicalize => true).should == RDF::Literal.new(str, :datatype => RDF::XSD.time, :canonicalize => false)
         end
       end
     end
   end

   describe "#plain?" do
     literals(:all_plain_no_lang).each do |args|
       it "returns true for #{args.inspect}" do
         literal = RDF::Literal.new(*args)
         literal.plain?.should be_true
       end
     end

     literals(:all_plain_lang, :all_native, :all_xml).each do |args|
       it "returns false for #{args.inspect}" do
         literal = RDF::Literal.new(*args)
         literal.plain?.should be_false
       end
     end
   end

   describe "#language" do
     literals(:all_plain_no_lang, :all_native, :all_xml).each do |args|
       it "returns nil for #{args.inspect}" do
         literal = RDF::Literal.new(*args)
         literal.language.should be_nil
       end
     end

     literals(:all_plain_lang).each do |args|
       it "returns language for #{args.inspect}" do
         literal = RDF::Literal.new(*args)
         literal.language.should == :en
       end
     end
   end

   describe "#datatype" do
     literals(:all_plain).each do |args|
       it "returns nil for #{args.inspect}" do
         literal = RDF::Literal.new(*args)
         literal.datatype.should be_nil
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
         RDF::Literal.new(value).datatype.should == XSD[type]
       end
     end

     literals(:all_xml).each do |args|
       it "returns datatype for #{args.inspect}" do
         literal = RDF::Literal.new(*args)
         literal.datatype.should == RDF.XMLLiteral
       end
     end
   end

  describe "#typed?" do
    literals(:all_plain).each do |args|
      it "returns false for #{args.inspect}" do
        literal = RDF::Literal.new(*args)
        literal.typed?.should be_false
      end
    end

    literals(:all_native, :all_xml).each do |args|
      it "returns true for #{args.inspect}" do
        literal = RDF::Literal.new(*args)
        literal.typed?.should be_true
      end
    end
  end

   describe "#==" do
     literals(:all_plain).each do |args|
       it "returns true for #{args.inspect}" do
         literal = RDF::Literal.new(*args)
         literal.should == RDF::Literal.new(*args)
       end
     end

     literals(:all_plain_no_lang).each do |args|
       it "returns true for value of #{args.inspect}" do
         literal = RDF::Literal.new(*args)
         literal.should == literal.value
       end
     end

     literals(:all_plain_lang).each do |args|
       it "returns false for value of #{args.inspect}" do
         literal = RDF::Literal.new(*args)
         literal.should_not == literal.value
       end
     end

     literals(:all_native).each do |args|
       it "returns true for #{args.inspect}" do
         literal = RDF::Literal.new(*args)
         literal.should == RDF::Literal.new(*args)
       end

       it "returns true for value of #{args.inspect}" do
         literal = RDF::Literal.new(*args)
         #literal.should == literal.value # FIXME: fails on xsd:date, xsd:time, and xsd:dateTime
       end
     end

     literals(:all_xml).each do |args|
       it "returns true for #{args.inspect}" do
         literal = RDF::Literal.new(*args)
         literal.should == RDF::Literal.new(*args)
       end

       it "returns false for value of #{args.inspect}" do
         literal = RDF::Literal.new(*args)
         literal.should_not == literal.value
       end
     end

     it "returns true for languaged taged literals differring in case" do
       l1 = RDF::Literal.new("foo", :language => :en)
       l2 = RDF::Literal.new("foo", :language => :EN)
       l1.should == l2
     end
   end

   describe "#to_s" do
     literals(:all_plain).each do |args|
       it "returns value for #{args.inspect}" do
         literal = RDF::Literal.new(*args)
         literal.to_s.should eql(literal.value)
       end
     end

     {
       literal(:int)      => "123",
       literal(:true)     => "true",
       literal(:false)    => "false",
       literal(:long)     => "9223372036854775807",
       literal(:double)   => "3.1415",
       literal(:date)     => "2010-01-01Z",
       literal(:datetime) => "2011-01-01T00:00:00Z",
       literal(:time)     => "01:02:03Z"
     }.each_pair do |args, rep|
       it "returns #{rep} for #{args.inspect}" do
         literal = RDF::Literal.new(*args)
         literal.to_s.should eql(rep)
       end
     end

     {
       literal(:xml_no_ns)   => %("foo <sup>bar</sup> baz!"^^<http://www.w3.org/1999/02/22-rdf-syntax-ns#XMLLiteral>),
       literal(:xml_ns)      => %("foo <sup>bar</sup> baz!"^^<http://www.w3.org/1999/02/22-rdf-syntax-ns#XMLLiteral>),
       literal(:xml_ns_lang) => %("foo <sup xml:lang=\\"fr\\">bar</sup> baz!"^^<http://www.w3.org/1999/02/22-rdf-syntax-ns#XMLLiteral>),
       literal(:xml_lang_em) => %("foo <sup xml:lang=\\"fr\\">bar</sup><sub xml:lang=\\"en\\">baz</sub>"^^<http://www.w3.org/1999/02/22-rdf-syntax-ns#XMLLiteral>),
       literal(:xml_def_ns)  => %("foo <sup xmlns=\\"http://purl.org/dc/terms/\\">bar</sup> baz!"^^<http://www.w3.org/1999/02/22-rdf-syntax-ns#XMLLiteral>),
       literal(:xml_ns2)     => %(fixme),
     }.each_pair do |args, rep|
       it "returns n3 rep for #{args.inspect}" do
         literal = RDF::Literal.new(*args)
         pending {literal.to_s.should == rep}
       end
     end
   end

   describe "#object" do
     literals(:all_plain).each do |args|
       it "returns value for #{args.inspect}" do
         literal = RDF::Literal.new(*args)
         literal.object.should eql(literal.value)
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
         literal.object.should eql(value)
       end
     end
   end

   describe "#anonymous?" do
     it "returns false" do
       RDF::Literal.new("").anonymous?.should be_false
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
         RDF::Literal.new(value, :datatype => RDF::XSD.boolean).valid?.should be_true
         RDF::Literal.new(value, :datatype => RDF::XSD.boolean).invalid?.should be_false
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
         RDF::Literal.new(value, :datatype => RDF::XSD.integer).valid?.should be_true
         RDF::Literal.new(value, :datatype => RDF::XSD.integer).invalid?.should be_false
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
         RDF::Literal.new(value, :datatype => RDF::XSD.decimal).valid?.should be_true
         RDF::Literal.new(value, :datatype => RDF::XSD.decimal).invalid?.should be_false
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
     }.each_pair do |value, str|
       it "validates double '#{value}'" do
         RDF::Literal.new(value, :datatype => RDF::XSD.double).valid?.should be_true
         RDF::Literal.new(value, :datatype => RDF::XSD.double).invalid?.should be_false
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
         RDF::Literal.new(value, :datatype => RDF::XSD.dateTime).valid?.should be_true
         RDF::Literal.new(value, :datatype => RDF::XSD.dateTime).invalid?.should be_false
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
         RDF::Literal.new(value, :datatype => RDF::XSD.date).valid?.should be_true
         RDF::Literal.new(value, :datatype => RDF::XSD.date).invalid?.should be_false
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
         RDF::Literal.new(value, :datatype => RDF::XSD.time).valid?.should be_true
         RDF::Literal.new(value, :datatype => RDF::XSD.time).invalid?.should be_false
       end
     end
   end

   describe "#invalid?" do
     {
       "foo"                    => RDF::XSD.boolean,
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

       "+2010-01-01Z"           => RDF::XSD.date,
       "2010-01-01TFOO"         => RDF::XSD.date,
       "02010-01-01"            => RDF::XSD.date,
       "2010-1-1"               => RDF::XSD.date,
       "0000-01-01"             => RDF::XSD.date,

       "+00:00:00Z"             => RDF::XSD.time,
       "-00:00:00Z"             => RDF::XSD.time,
     }.each_pair do |value, datatype|
       it "does not validate for '#{value}'" do
         RDF::Literal.new(value, :datatype => datatype).invalid?.should be_true
         RDF::Literal.new(value, :datatype => datatype).valid?.should be_false
       end
     end
   end
  
  describe RDF::Literal::Numeric do
    context "type-promotion" do
      context "for numbers" do
        {
          :integer => {
            :integer            => :integer,
            :nonPositiveInteger => :integer,
            :negativeInteger    => :integer,
            :long               => :integer,
            :int                => :integer,
            :short              => :integer,
            :byte               => :integer,
            :nonNegativeInteger => :integer,
            :unsignedLong       => :integer,
            :unsignedInt        => :integer,
            :unsignedShort      => :integer,
            :unsignedByte       => :integer,
            :positiveInteger    => :integer,
            :decimal            => :decimal,
            :float              => :float,
            :double             => :double,
          },
          :decimal => {
            :integer            => :decimal,
            :nonPositiveInteger => :decimal,
            :negativeInteger    => :decimal,
            :long               => :decimal,
            :int                => :decimal,
            :short              => :decimal,
            :byte               => :decimal,
            :nonNegativeInteger => :decimal,
            :unsignedLong       => :decimal,
            :unsignedInt        => :decimal,
            :unsignedShort      => :decimal,
            :unsignedByte       => :decimal,
            :positiveInteger    => :decimal,
            :decimal            => :decimal,
            :float              => :float,
            :double             => :double,
          },
          :float => {
            :integer            => :float,
            :nonPositiveInteger => :float,
            :negativeInteger    => :float,
            :long               => :float,
            :int                => :float,
            :short              => :float,
            :byte               => :float,
            :nonNegativeInteger => :float,
            :unsignedLong       => :float,
            :unsignedInt        => :float,
            :unsignedShort      => :float,
            :unsignedByte       => :float,
            :positiveInteger    => :float,
            :decimal            => :float,
            :float              => :float,
            :double             => :double,
          },
          :double => {
            :integer            => :double,
            :nonPositiveInteger => :double,
            :negativeInteger    => :double,
            :long               => :double,
            :int                => :double,
            :short              => :double,
            :byte               => :double,
            :nonNegativeInteger => :double,
            :unsignedLong       => :double,
            :unsignedInt        => :double,
            :unsignedShort      => :double,
            :unsignedByte       => :double,
            :positiveInteger    => :double,
            :decimal            => :double,
            :float              => :double,
            :double             => :double,
          },
        }.each do |left, right_result|
          if left == :integer
            # Type promotion is equivalent for sub-types of xsd:integer
            (right_result.keys - [:integer, :decimal, :float, :double]).each do |l|
              o_l = RDF::Literal.new(([:nonPositiveInteger, :negativeInteger].include?(l) ? "-1" : "1"), :datatype => RDF::XSD.send(l))
              right_result.each do |right, result|
                o_r = RDF::Literal.new(([:nonPositiveInteger, :negativeInteger].include?(right) ? "-1" : "1"), :datatype => RDF::XSD.send(right))
                
                it "returns #{result} for #{l} + #{right}" do
                  (o_l + o_r).datatype.should == RDF::XSD.send(result)
                end
                it "returns #{result} for #{l} - #{right}" do
                  (o_l - o_r).datatype.should == RDF::XSD.send(result)
                end
                it "returns #{result} for #{l} * #{right}" do
                  (o_l * o_r).datatype.should == RDF::XSD.send(result)
                end
                it "returns #{result} for #{l} / #{right}" do
                  (o_l / o_r).datatype.should == RDF::XSD.send(result)
                end

                it "returns #{result} for #{right} + #{l}" do
                  (o_r + o_l).datatype.should == RDF::XSD.send(result)
                end
                it "returns #{result} for #{right} - #{l}" do
                  (o_r - o_l).datatype.should == RDF::XSD.send(result)
                end
                it "returns #{result} for #{right} * #{l}" do
                  (o_r * o_l).datatype.should == RDF::XSD.send(result)
                end
                it "returns #{result} for #{right} / #{l}" do
                  (o_r / o_l).datatype.should == RDF::XSD.send(result)
                end
              end
            end
          end

          o_l = RDF::Literal.new("1", :datatype => RDF::XSD.send(left))
          right_result.each do |right, result|
            o_r = RDF::Literal.new(([:nonPositiveInteger, :negativeInteger].include?(right) ? "-1" : "1"), :datatype => RDF::XSD.send(right))
            
            it "returns #{result} for #{left} + #{right}" do
              (o_l + o_r).datatype.should == RDF::XSD.send(result)
            end
            it "returns #{result} for #{left} - #{right}" do
              (o_l - o_r).datatype.should == RDF::XSD.send(result)
            end
            it "returns #{result} for #{left} * #{right}" do
              (o_l * o_r).datatype.should == RDF::XSD.send(result)
            end
            it "returns #{result} for #{left} / #{right}" do
              (o_l / o_r).datatype.should == RDF::XSD.send(result)
            end

            it "returns #{result} for #{right} + #{left}" do
              (o_r + o_l).datatype.should == RDF::XSD.send(result)
            end
            it "returns #{result} for #{right} - #{left}" do
              (o_r - o_l).datatype.should == RDF::XSD.send(result)
            end
            it "returns #{result} for #{right} * #{left}" do
              (o_r * o_l).datatype.should == RDF::XSD.send(result)
            end
            it "returns #{result} for #{right} / #{left}" do
              (o_r / o_l).datatype.should == RDF::XSD.send(result)
            end
          end
        end
      end
    end

    [RDF::Literal::Float, RDF::Literal::Double].each do |c|
      describe c do
        before(:each) do
          @nan = c.new("NaN")
          @inf = c.new("INF")
        end
    
        it "recognizes INF" do
          @inf.should be_infinite
          RDF::Literal.new('INF', :datatype => c::DATATYPE).should == @inf
        end
    
        it "recognizes -INF" do
          @inf.should be_infinite
          RDF::Literal.new('-INF', :datatype => c::DATATYPE).should == -@inf
        end
    
        it "recognizes NaN" do
          @nan.should be_nan
          RDF::Literal.new('NaN', :datatype => c::DATATYPE).should be_nan
        end
    
        [-1, 0, 1].map {|n| c.new(n)}.each do |n|
          {
            :"+" => [c.new("INF"), c.new("INF"), c.new("-INF"), c.new("-INF")],
            :"-" => [c.new("INF"), c.new("-INF"), c.new("-INF"), c.new("INF")],
          }.each do |op, (lp, rp, lm, rm)|
            it "returns #{lp} for INF #{op} #{n}" do
              @inf.send(op, n).should == lp
            end
            
            it "returns #{rp} for #{n} #{op} INF" do
              n.send(op, @inf).should == rp
            end

            it "returns #{lm} for -INF #{op} #{n}" do
              (-@inf).send(op, n).should == lm
            end
            
            it "returns #{rm} for #{n} #{op} -INF" do
              n.send(op, -@inf).should == rm
            end
          end
          
          it "#{n} + NaN" do
            (n + -@nan).should be_nan
            (-@nan + n).should be_nan
          end
        end

        # Multiplication
        {
          -1 => [c.new("-INF"), c.new("-INF")],
          0  => [:nan, :nan],
          1  => [c.new("INF"), c.new("INF")],
        }.each do |n, (p, m)|
          it "returns #{p} for #{n} * INF" do
            if p == :nan
              (c.new(n) * @inf).should be_nan
            else
              (c.new(n) * @inf).should == p
            end
          end

          it "returns #{p} for INF * #{n}" do
            if p == :nan
              (@inf * c.new(n)).should be_nan
            else
              (@inf * c.new(n)).should == p
            end
          end
        end

        it "adds infinities" do
          (@inf + @inf).should == @inf
          (@inf + -@inf).should be_nan
          (-@inf + -@inf).should == -@inf
          (-@inf + @inf).should be_nan
        end

        it "adds NaN" do
          (@inf + @nan).should be_nan
          (@nan + @nan).should be_nan
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
        "numeric '1'^xsd:int=1" => [RDF::Literal::Int.new("1"), RDF::Literal(1)],
        "numeric -INF=-INF" => [-RDF::Literal::Double.new("INF"), -RDF::Literal::Double.new("INF")],
        "numeric 1='1'^xsd:int" => [RDF::Literal(1), RDF::Literal::Int.new("1")],
        "numeric 1='1'^xsd:int" => [RDF::Literal(1), RDF::Literal::Int.new("1")],
        "numeric INF=INF" => [RDF::Literal::Double.new("INF"), RDF::Literal::Double.new("INF")],
        "open-eq-02 'xyz'^^<unknown>='xyz'^^<unknown>" => [RDF::Literal("xyz", :datatype => RDF::URI("unknown")), RDF::Literal("xyz", :datatype => RDF::URI("unknown"))],
        "open-eq-03 '01'^xsd:integer=1" => [RDF::Literal::Integer.new("01"), RDF::Literal(1)],
        "open-eq-03 '1'^xsd:integer=1" => [RDF::Literal::Integer.new("1"), RDF::Literal(1)],
        "open-eq-07 'xyz'='xyz'" => [RDF::Literal("xyz"), RDF::Literal("xyz")],
        "open-eq-07 'xyz'='xyz'^^xsd:string" => [RDF::Literal("xyz"), RDF::Literal("xyz", :datatype => XSD.string)],
        "open-eq-07 'xyz'@EN='xyz'@EN" => [RDF::Literal("xyz", :language => :EN), RDF::Literal("xyz", :language => :EN)],
        "open-eq-07 'xyz'@EN='xyz'@en" => [RDF::Literal("xyz", :language => :EN), RDF::Literal("xyz", :language => :en)],
        "open-eq-07 'xyz'@en='xyz'@EN" => [RDF::Literal("xyz", :language => :en), RDF::Literal("xyz", :language => :EN)],
        "open-eq-07 'xyz'@en='xyz'@en" => [RDF::Literal("xyz", :language => :en), RDF::Literal("xyz", :language => :en)],
        "open-eq-07 'xyz'xsd:string='xyz'" => [RDF::Literal("xyz", :datatype => XSD.string), RDF::Literal("xyz")],
        "open-eq-07 'xyz'^^<unknown>='xyz'^^<unknown>" => [RDF::Literal("xyz", :datatype => RDF::URI("unknown")), RDF::Literal("xyz", :datatype => RDF::URI("unknown"))],
        "open-eq-07 'xyz'^^xsd:integer='xyz'^^xsd:integer" => [RDF::Literal::Integer.new("xyz"), RDF::Literal::Integer.new("xyz")],
        "open-eq-07 'xyz'^^xsd:string='xyz'xsd:string" => [RDF::Literal("xyz", :datatype => XSD.string), RDF::Literal("xyz", :datatype => XSD.string)],
        "token 'xyz'^^xsd:token=xyz'^^xsd:token" => [RDF::Literal(:xyz), RDF::Literal(:xyz)],
      }.each do |label, (left, right)|
        it "returns true for #{label}" do
          left.should == right
          left.should be_equal_tc(right)
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
        "eq-2-2 'zzz'^^<unknown>='1'" => [RDF::Literal("zzz", :datatype => RDF::URI("unknown")), RDF::Literal("1")],
        "eq-2-2 '1'='zzz'^^<unknown>" => [RDF::Literal("1"), RDF::Literal("zzz", :datatype => RDF::URI("unknown"))],
        "eq-2-2 'zzz'^^<unknown>='zzz'" => [RDF::Literal("zzz", :datatype => RDF::URI("unknown")), RDF::Literal("zzz")],
        "eq-2-2 'zzz'='zzz'^^<unknown>" => [RDF::Literal("zzz"), RDF::Literal("zzz", :datatype => RDF::URI("unknown"))],
        "language 'xyz'@en='xyz'@dr" => [RDF::Literal("xyz", :language => :en), RDF::Literal("xyz", :language => :"dr")],
        "language 'xyz'@en='xyz'@en-us" => [RDF::Literal("xyz", :language => :en), RDF::Literal("xyz", :language => :"en-us")],
        "numeric +INF=-INF" => [RDF::Literal::Double.new("INF"), -RDF::Literal::Double.new("INF")],
        "numeric -INF=INF" => [-RDF::Literal::Double.new("INF"), RDF::Literal::Double.new("INF")],
        "numeric 1.0=2.0" => [RDF::Literal(1.0), RDF::Literal(2.0)],
        "numeric 1=2" => [RDF::Literal(1), RDF::Literal(2)],
        "numeric NaN=NaN" => [-RDF::Literal::Double.new("NaN"), RDF::Literal::Double.new("NaN")],
        "open-eq-04 '02'^xsd:integer=1" => [RDF::Literal::Integer.new("02"), RDF::Literal(1)],
        "open-eq-04 '2'^xsd:integer=1" => [RDF::Literal::Integer.new("2"), RDF::Literal(1)],
        "open-eq-08 '<xyz>=xyz'@en" => [RDF::URI("xyz"), RDF::Literal("xyz", :language => :en)],
        "open-eq-08 'xyz'='xyz'@EN" => [RDF::Literal("xyz"), RDF::Literal("xyz", :language => :EN)],
        "open-eq-08 'xyz'='xyz'@en" => [RDF::Literal("xyz"), RDF::Literal("xyz", :language => :en)],
        "open-eq-08 'xyz'=<xyz>" => [RDF::Literal("xyz"), RDF::URI("xyz")],
        "open-eq-08 'xyz'=_:xyz" => [RDF::Literal("xyz"), RDF::Node.new("xyz")],
        "open-eq-08 'xyz'@EN='xyz'" => [RDF::Literal("xyz", :language => :EN), RDF::Literal("xyz")],
        "open-eq-08 'xyz'@en='xyz'" => [RDF::Literal("xyz", :language => :en), RDF::Literal("xyz")],
        "open-eq-08 'xyz'@en='xyz'^^<unknown>" => [RDF::Literal("xyz", :language => :en), RDF::Literal("xyz", :datatype => RDF::URI("unknown"))],
        "open-eq-08 'xyz'@en='xyz'^^xsd:integer" => [RDF::Literal("xyz", :language => :en), RDF::Literal("xyz", :datatype => XSD.integer)],
        "open-eq-08 'xyz'@en='xyz'^^xsd:string" => [RDF::Literal("xyz", :language => :en), RDF::Literal("xyz", :datatype => XSD.string)],
        "open-eq-08 'xyz'@en=<xyz>" => [RDF::Literal("xyz", :language => :en), RDF::URI("xyz")],
        "open-eq-08 'xyz'@en==_:xyz" => [RDF::Literal("xyz"), RDF::Node.new("xyz")],
        "open-eq-08 'xyz'^^<unknown>='xyz'@en" => [RDF::Literal("xyz", :datatype => RDF::URI("unknown")), RDF::Literal("xyz", :language => :en)],
        "open-eq-08 'xyz'^^xsd:integer='xyz'@en" => [RDF::Literal("xyz", :datatype => XSD.integer), RDF::Literal("xyz", :language => :en)],
        "open-eq-08 'xyz'^^xsd:integer=<xyz>" => [RDF::Literal("xyz", :datatype => XSD.integer), RDF::URI("xyz")],
        "open-eq-08 'xyz'^^xsd:string='xyz'@en" => [RDF::Literal("xyz", :datatype => XSD.string), RDF::Literal("xyz", :language => :en)],
        "open-eq-08 <xyz>='xyz'" => [RDF::URI("xyz"), RDF::Literal("xyz")],
        "open-eq-08 <xyz>='xyz'@en" => [RDF::URI("xyz"), RDF::Literal("xyz", :language => :en)],
        "open-eq-08 <xyz>='xyz'^^xsd:integer" => [RDF::URI("xyz"), RDF::Literal("xyz", :datatype => XSD.integer)],
        "open-eq-08 _:xyz='abc'" => [RDF::Node.new("xyz"), RDF::Literal("abc")],
        "open-eq-08 _:xyz='xyz'" => [RDF::Node.new("xyz"), RDF::Literal("xyz")],
        "open-eq-08 _:xyz='xyz'@en=" => [RDF::Node.new("xyz"), RDF::Literal("xyz")],
        "open-eq-10 'xyz'='abc'" => [RDF::Literal("xyz"), RDF::Literal("abc")],
        "open-eq-10 'xyz'='abc'@EN" => [RDF::Literal("xyz"), RDF::Literal("abc", :language => :EN)],
        "open-eq-10 'xyz'='abc'@en" => [RDF::Literal("xyz"), RDF::Literal("abc", :language => :en)],
        "open-eq-10 'xyz'='abc'^^xsd:string" => [RDF::Literal("xyz"), RDF::Literal("abc", :datatype => XSD.string)],
        "open-eq-10 'xyz'=<abc>" => [RDF::Literal("xyz"), RDF::URI("abc")],
        "open-eq-10 'xyz'=_:abc" => [RDF::Literal("xyz"), RDF::Node.new("abc")],
        "open-eq-10 'xyz'@en='abc'@en" => [RDF::Literal("xyz", :language => :en), RDF::Literal("abc", :language => :en)],
        "open-eq-10 'xyz'@en='abc'^^xsd:integer" => [RDF::Literal("xyz", :language => :en), RDF::Literal("abc", :datatype => XSD.integer)],
      }.each do |label, (left, right)|
        it "returns false for #{label}" do
          left.should_not == right
          left.should_not be_equal_tc(right)
        end
      end
    end
    
    context TypeError do
      {
        "boolean 'true'=true" => [RDF::Literal("true"), RDF::Literal::Boolean.new("true")],
        "boolean true='true'" => [RDF::Literal::Boolean.new("true"), RDF::Literal("true")],
        "numeric '1'=1" => [RDF::Literal("1"), RDF::Literal(1)],
        "numeric 1='1'" => [RDF::Literal(1), RDF::Literal("1")],
        "numeric 1=<xyz>" => [RDF::Literal(1), RDF::URI("xyz")],  # From expr-equal/expr-2-2
        "numeric 1=_:xyz" => [RDF::Literal(1), RDF::Node.new("xyz")],  # From expr-equal/expr-2-2
        "numeric <xyz>=1" => [RDF::URI("xyz"), RDF::Literal(1)],  # From expr-equal/expr-2-2
        "numeric _:xyz=1" => [RDF::Node.new("xyz"), RDF::Literal(1)],  # From expr-equal/expr-2-2
        "open-eq-04 'a'^^<unknown>=1" => [RDF::Literal.new("a", :datatype => RDF::URI("unknown")), RDF::Literal(1)],
        "open-eq-06 'b'^^<unknown>='a'^^<unknown>" => [RDF::Literal.new("b", :datatype => RDF::URI("unknown")), RDF::Literal.new("a", :datatype => RDF::URI("unknown"))],
        "open-eq-06 1='a'^^<unknown>" => [RDF::Literal(1), RDF::Literal.new("a", :datatype => RDF::URI("unknown"))],
        "open-eq-08 'xyz'='xyz'^^<unknown>" => [RDF::Literal("xyz"), RDF::Literal("xyz", :datatype => RDF::URI("unknown"))],
        "open-eq-08 'xyz'='xyz'^^<unknown>" => [RDF::Literal("xyz"), RDF::Literal.new("xyz", :datatype => RDF::URI("unknown"))],
        "open-eq-08 'xyz'='xyz'^^xsd:integer" => [RDF::Literal("xyz"), RDF::Literal("xyz", :datatype => XSD.integer)],
        "open-eq-08 'xyz'='xyz'^^xsd:integer" => [RDF::Literal("xyz"), RDF::Literal::Integer.new("xyz")],
        "open-eq-08 'xyz'^^<unknown>='xyz'" => [RDF::Literal("xyz", :datatype => RDF::URI("unknown")), RDF::Literal("xyz")],
        "open-eq-08 'xyz'^^<unknown>='xyz'" => [RDF::Literal("xyz", :datatype => RDF::URI("unknown")), RDF::Literal.new("xyz")],
        "open-eq-08 'xyz'^^xsd:integer='xyz'" => [RDF::Literal("xyz", :datatype => XSD.integer), RDF::Literal("xyz")],
        "open-eq-08 'xyz'^^xsd:integer='xyz'" => [RDF::Literal::Integer.new("xyz"), RDF::Literal.new("xyz")],
        "open-eq-10 'xyz'='abc'^^xsd:integer" => [RDF::Literal("xyz"), RDF::Literal("abc", :datatype => XSD.integer)],
        "open-eq-10 'xyz'^^<unknown>='abc'^^<unknown>" => [RDF::Literal("xyz", :datatype => RDF::URI("unknown")), RDF::Literal("abc", :datatype => RDF::URI("unknown"))],
        "open-eq-10 'xyz'^^xsd:integer='abc'" => [RDF::Literal("xyz", :datatype => XSD.integer), RDF::Literal("abc")],
        "open-eq-10 'xyz'^^xsd:integer='abc'^^xsd:integer" => [RDF::Literal::Integer.new("xyz"), RDF::Literal::Integer.new("abc")],
        "token 'xyz'^^xsd:token=abc'^^xsd:token" => [RDF::Literal(:xyz), RDF::Literal(:abc)],
      }.each do |label, (left, right)|
        it "raises TypeError for #{label}" do
          left.should_not == right
          lambda {left.equal_tc?(right)}.should raise_error(TypeError)
        end
      end
    end
  end
end
