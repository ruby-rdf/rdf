require File.join(File.dirname(__FILE__), 'spec_helper')

describe RDF::Util::Aliasing do
  before :all do
    class Aliasing
      def self.alias_method(new, old) 
        define_method(new) do | *args , &block |
          send(old, *args, &block)
        end
      end
  
      def old(*args, &block)
        "#{args.join(',')} and #{block.call if block_given?}"
      end
  
      alias_method :alias, :old
  
    end
  end

  before :each do
    @alias = Aliasing.new
  end

  it "should create a new method for :new" do
    @alias.should respond_to :alias
  end

  it "should not raise errors for any arguments sent" do
    lambda { @alias.alias }.should_not raise_error
    lambda { @alias.alias(1) }.should_not raise_error
    lambda { @alias.alias(1,2) }.should_not raise_error
    lambda { @alias.alias(1,2) do "return value" end }.should_not raise_error
  end

  it "should return the same results as the old method" do
    @alias.alias(1,2).should == @alias.old(1,2)
    @alias.alias(1,2) { "test" }.should == @alias.old(1,2) { "test" }
  end

  it "should update the aliased method if the old one is overwritten" do
    class Aliasing
      def old(*args, &block)
        "some new return value based on #{args.join('::')} and #{block.call if block_given?}"
      end
    end
    @alias.alias(1,2).should == @alias.old(1,2)
    @alias.alias(1,2) { "test" }.should == @alias.old(1,2) { "test" }
  end


end
