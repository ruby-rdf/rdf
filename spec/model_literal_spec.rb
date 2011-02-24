require File.join(File.dirname(__FILE__), 'spec_helper')
require 'rdf/spec/literal'

describe RDF::Literal do
  before :each do
    @new = Proc.new { |*args| RDF::Literal.new(*args) }
  end

  # @see lib/rdf/spec/literal.rb in rdf-spec
  it_should_behave_like RDF_Literal
  
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
end
