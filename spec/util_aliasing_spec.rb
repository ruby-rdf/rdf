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

  subject {RDF::Util::Aliasing::Aliased.new}

  context "when aliasing a method" do
    it "should create a new instance method with the given name" do
      expect(subject).to respond_to(:aliased)
    end
  end

  context "the aliased method" do
    it "should accept any arguments" do
      expect { subject.aliased }.not_to raise_error
      expect { subject.aliased(1) }.not_to raise_error
      expect { subject.aliased(1, 2) }.not_to raise_error
    end

    it "should accept a block" do
      expect { subject.aliased(1, 2) do 3 end }.not_to raise_error
    end

    it "should invoke the original method with the given arguments" do
      expect(subject.aliased).to          eq subject.original
      expect(subject.aliased(1, 2)).to    eq subject.original(1, 2)
      expect(subject.aliased(1, 2, 3)).to eq subject.original(1, 2, 3)
    end

    it "should invoke the original method with the given block" do
      expect(subject.aliased { 1 }).to       eq subject.original { 1 }
      expect(subject.aliased(1) { 2 }).to    eq subject.original(1) { 2 }
      expect(subject.aliased(1, 2) { 3 }).to eq subject.original(1, 2) { 3 }
    end

    it "should update if the original method is redefined" do
      module ::RDF::Util::Aliasing
        class Aliased
          def original(*args, &block)
            "redefined return value: #{args.join('::')} and #{block.call if block_given?}"
          end
        end
      end

      expect(subject.rebound(1, 2)).not_to eq subject.original(1, 2)
      expect(subject.aliased(1, 2)).to     eq subject.original(1, 2)

      expect(subject.rebound(1, 2) { 3 }).not_to eq subject.original(1, 2) { 3 }
      expect(subject.aliased(1, 2) { 3 }).to     eq subject.original(1, 2) { 3 }
    end
  end
end
