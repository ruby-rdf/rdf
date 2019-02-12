require File.join(File.dirname(__FILE__), 'spec_helper')

describe RDF::Query::Variable do
  context ".new unbound" do
    let(:var) {described_class.new(:x)}
    subject {var}

    it "is named" do
      expect(subject).to be_named
      expect(subject.name).to eq :x
    end

    it "has no value" do
      expect(subject.value).to be_nil
    end
    
    context "distinguished" do
      it "is distinguished" do
        expect(subject).to be_distinguished
      end

      it "can be made non-distinguished" do
        subject.distinguished = false
        expect(subject).to_not be_distinguished
      end

      it "has a string representation" do
        expect(subject.to_s).to eq "?x"
      end

      it "intuits from ?foo" do
        var = described_class.new("?foo")
        expect(var).to be_distinguished
        expect(var).not_to be_existential
        expect(var.to_s).to eq '?foo'
      end

      it "intuits from ?foo with override" do
        var = described_class.new("?foo", existential: true)
        expect(var).to be_distinguished
        expect(var).to be_existential
        expect(var.to_s).to eq '$foo'
      end
    end
    
    context "existential" do
      subject { var.existential = true; var }
      it "is existential" do
        expect(subject).to be_existential
      end

      it "can be made universal" do
        subject.existential = false
        expect(subject).not_to be_existential
      end

      it "has a string representation" do
        expect(subject.to_s).to eq "$x"
      end

      it "intuits from $foo" do
        var = described_class.new("?foo")
        expect(var).to be_distinguished
        expect(var).not_to be_existential
      end

      it "intuits from $foo" do
        var = described_class.new("$foo")
        expect(var).to be_distinguished
        expect(var).to be_existential
        expect(var.to_s).to eq '$foo'
      end

      it "intuits from $foo with override" do
        var = described_class.new("$foo", existential: false)
        expect(var).to be_distinguished
        expect(var).not_to be_existential
        expect(var.to_s).to eq '?foo'
      end
    end
    
    context "non-distinguished" do
      subject { var.distinguished = false; var }
      it "is nondistinguished" do
        expect(subject).to_not be_distinguished
      end

      it "can be created as non-distinguished" do
        expect(described_class.new(:x, distinguished: false)).not_to be_distinguished
      end

      it "can be made distinguished" do
        subject.distinguished = true
        expect(subject).to be_distinguished
      end

      it "has a string representation" do
        expect(subject.to_s).to eq "??x"
      end

      it "intuits from ??foo" do
        var = described_class.new("??foo")
        expect(var).not_to be_distinguished
        expect(var).not_to be_existential
        expect(var.to_s).to eq '??foo'
      end

      it "intuits from ??foo with explicit override" do
        var = described_class.new("??foo", distinguished: true)
        expect(var).to be_distinguished
        expect(var).not_to be_existential
        expect(var.to_s).to eq '?foo'
      end
    
      context "existential" do
        subject { var.existential = true; var.distinguished = false; var }
        it "is existential" do
          expect(subject).to be_existential
        end

        it "can be made universal" do
          subject.existential = false
          expect(subject).not_to be_existential
        end

        it "has a string representation" do
          expect(subject.to_s).to eq "$$x"
        end

        it "intuits from $$foo" do
          var = described_class.new("$$foo")
          expect(var).not_to be_distinguished
          expect(var).to be_existential
          expect(var.to_s).to eq '$$foo'
        end
      end
    end
    
    it "is convertible to a symbol" do
      expect(subject.to_sym).to eq :x
    end

    it "has no value" do
      expect(subject.value).to be_nil
    end

    it "is unbound" do
      expect(subject).to be_unbound
      expect(subject).not_to be_bound
      expect(subject.variables).to eq({x: subject})
      expect(subject.bindings).to eq({})
    end

    describe "#==" do
      it "matches any Term" do
        [RDF::URI("foo"), RDF::Node.new, RDF::Literal("foo"), subject].each do |value|
          expect(subject).to eq value
        end
      end

      it "does not match non-terms" do
        [nil, true, false, 123].each do |value|
          expect(subject).to_not eq value
        end
      end
    end

    describe "#eql?" do
      it "matches any Term" do
        [RDF::URI("foo"), RDF::Node.new, RDF::Literal("foo"), subject].each do |value|
          expect(subject).to be_eql value
        end
      end

      it "does not match non-terms" do
        [nil, true, false, 123].each do |value|
          expect(subject).to_not be_eql value
        end
      end
    end

    describe "#===" do
      it "matches any Term" do
        [RDF::URI("foo"), RDF::Node.new, RDF::Literal("foo"), subject].each do |value|
          expect((subject === value)).to be_truthy
        end
      end

      it "does not match non-terms" do
        [nil, true, false, 123].each do |value|
          expect((subject === value)).to be_falsey
        end
      end
    end
  end

  context ".new non-distinguished" do
    subject {described_class.new(:x, RDF::Literal(123))}

    it "has a value" do
      expect(subject.value).to eq RDF::Literal(123)
    end

    it "is bound" do
      expect(subject).not_to be_unbound
      expect(subject).to be_bound
      expect(subject.variables).to eq({x: subject})
      expect(subject.bindings).to eq({x: RDF::Literal(123)})
    end

    it "matches only its value" do
      [nil, true, false, RDF::Literal(456)].each do |value|
        expect((subject === value)).to be_falsey
      end
      expect((subject === RDF::Literal(123))).to be_truthy
    end

    it "has a string representation" do
      expect(subject.to_s).to eq "?x=123"
    end
  end

  context ".new bound" do
    subject {described_class.new(:x, RDF::Literal(123))}

    it "has a value" do
      expect(subject.value).to eq RDF::Literal(123)
    end

    it "is bound" do
      expect(subject).not_to be_unbound
      expect(subject).to be_bound
      expect(subject.variables).to eq({x: subject})
      expect(subject.bindings).to eq({x: RDF::Literal(123)})
    end

    it "matches only its value" do
      [nil, true, false, RDF::Literal(456)].each do |value|
        expect((subject === value)).to be_falsey
      end
      expect((subject === RDF::Literal(123))).to be_truthy
    end

    it "has a string representation" do
      expect(subject.to_s).to eq "?x=123"
    end
  end

  context "when rebound" do
    subject {described_class.new(:x, RDF::Literal(123))}

    it "returns the previous value" do
      expect(subject.bind(RDF::Literal(456))).to eq RDF::Literal(123)
      expect(subject.bind(RDF::Literal(789))).to eq RDF::Literal(456)
    end

    it "is still bound" do
      subject.bind!(RDF::Literal(456))
      expect(subject).not_to be_unbound
      expect(subject).to be_bound
    end
  end

  context "when unbound" do
    subject {described_class.new(:x, RDF::Literal(123))}

    it "returns the previous value" do
      expect(subject.unbind).to eq RDF::Literal(123)
      expect(subject.unbind).to eq nil
    end

    it "is not bound" do
      subject.unbind!
      expect(subject).to be_unbound
      expect(subject).not_to be_bound
    end
  end

  context "Examples" do
    subject {described_class.new(:y, 123)}
    it "Creating a named unbound variable" do
      var = described_class.new(:x)
      expect(var).to be_unbound
      expect(var.value).to be_nil
    end

    it "Creating an anonymous unbound variable" do
      expect(described_class.new.name).to be_a(Symbol)
    end

    it "Unbound variables match any value" do
      expect(described_class.new).to eq RDF::Literal(42)
    end

    it "Creating a bound variable" do
      expect(subject).to be_bound
      expect(subject.value).to eq 123
    end

    it "Bound variables match only their actual value" do
      expect(subject).to_not eq 42
      expect(subject).to eq 123
    end

    it "Getting the variable name" do
      expect(subject).to be_named
      expect(subject.name).to eq :y
      expect(subject.to_sym).to eq :y
    end

    it "Rebinding a variable returns the previous value" do
      expect(subject.bind!(456)).to eq 123
      expect(subject.value).to eq 456
    end

    it "Unbinding a previously bound variable" do
      subject.unbind!
      expect(subject).to be_unbound
    end

    it "Getting the string representation of a variable" do
      var = described_class.new(:x)
      expect(var.to_s).to eq "?x"
      expect(subject.to_s).to eq "?y=123"
    end

    describe "#to_s" do
      it "can be undistinguished" do
        var = described_class.new("a")
        expect(var.to_s).to eq "?a"
        var.distinguished = false
        expect(var.to_s).to eq "??a"
      end
    end
  end
end
