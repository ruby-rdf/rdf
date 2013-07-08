require File.join(File.dirname(__FILE__), 'spec_helper')

describe RDF::Util::Aliasing do
  before :all do
    module ::RDF::Util::Aliasing
      class Aliased
        def original(*args, &block)
          "original return value: #{args.join(',')} and #{block.call if block_given?}"
        end

        alias_method :rebound, :original        # early-bound alias

        extend RDF::Util::Aliasing::LateBound   # magic happens
        alias_method :aliased, :original        # late-bound alias
      end unless defined?(Aliased)
    end
  end

  before :each do
    @alias = RDF::Util::Aliasing::Aliased.new
  end

  context "when aliasing a method" do
    it "should create a new instance method with the given name" do
      @alias.should respond_to(:aliased)
    end
  end

  context "the aliased method" do
    it "should accept any arguments" do
      expect { @alias.aliased }.not_to raise_error
      expect { @alias.aliased(1) }.not_to raise_error
      expect { @alias.aliased(1, 2) }.not_to raise_error
    end

    it "should accept a block" do
      expect { @alias.aliased(1, 2) do 3 end }.not_to raise_error
    end

    it "should invoke the original method with the given arguments" do
      @alias.aliased.should          == @alias.original
      @alias.aliased(1, 2).should    == @alias.original(1, 2)
      @alias.aliased(1, 2, 3).should == @alias.original(1, 2, 3)
    end

    it "should invoke the original method with the given block" do
      @alias.aliased { 1 }.should       == @alias.original { 1 }
      @alias.aliased(1) { 2 }.should    == @alias.original(1) { 2 }
      @alias.aliased(1, 2) { 3 }.should == @alias.original(1, 2) { 3 }
    end

    it "should update if the original method is redefined" do
      module ::RDF::Util::Aliasing
        class Aliased
          def original(*args, &block)
            "redefined return value: #{args.join('::')} and #{block.call if block_given?}"
          end
        end
      end

      @alias.rebound(1, 2).should_not == @alias.original(1, 2)
      @alias.aliased(1, 2).should     == @alias.original(1, 2)

      @alias.rebound(1, 2) { 3 }.should_not == @alias.original(1, 2) { 3 }
      @alias.aliased(1, 2) { 3 }.should     == @alias.original(1, 2) { 3 }
    end
  end
end
