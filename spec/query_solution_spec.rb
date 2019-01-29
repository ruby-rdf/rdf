require File.join(File.dirname(__FILE__), 'spec_helper')

describe RDF::Query::Solution do
  subject {described_class.new(a: 1, "?b": 2, "??c": 3, "$d": 4, "$$e": 5)}

  describe "new" do
    it "is instantiable" do
      expect { described_class.new }.not_to raise_error
    end
  end

  describe "#each_binding" do
    it "returns an enumerator" do
      expect(subject.each_binding).to be_an Enumerator
    end

    it "yields each binding" do
      expect{|b| subject.each_binding(&b)}.to yield_successive_args([:a, 1], [:"?b", 2], [:"??c", 3], [:"$d", 4], [:"$$e", 5])
    end
  end

  describe "#enum_binding" do
    it "returns each binding" do
      expect(subject.enum_binding.to_a).to include([:a, 1], [:"?b", 2], [:"??c", 3], [:"$d", 4], [:"$$e", 5])
    end
  end

  describe "#each_name" do
    it "returns an enumerator" do
      expect(subject.each_name).to be_an Enumerator
    end

    it "yields each name" do
      expect{|b| subject.each_name(&b)}.to yield_successive_args(:a, :"?b", :"??c", :"$d", :"$$e")
    end
  end

  describe "#enum_name" do
    it "returns each name" do
      expect(subject.enum_name.to_a).to include(:a, :"?b", :"??c", :"$d", :"$$e")
    end
  end

  describe "#each_value" do
    it "returns an enumerator" do
      expect(subject.each_value).to be_an Enumerator
    end

    it "yields each value" do
      expect{|b| subject.each_value(&b)}.to yield_successive_args(1, 2, 3, 4, 5)
    end
  end

  describe "#enum_value" do
    it "returns each value" do
      expect(subject.enum_value.to_a).to include(1, 2, 3, 4, 5)
    end
  end

  describe "#each_variable" do
    it "returns an enumerator" do
      expect(subject.each_variable).to be_an Enumerator
    end

    it "yields each variable" do
      expect{|b| subject.each_variable(&b)}.to yield_control.exactly(5).times
    end
  end

  describe "#enum_variable" do
    it "creates distinguished variables" do
      expect(subject.enum_variable.map(&:distinguished?)).to eq([true, true, false, true, false])
    end

    it "creates existential variables" do
      expect(subject.enum_variable.map(&:existential?)).to eq([false, false, false, true, true])
    end
  end

  describe "#compatible?" do
    it "returns true if two solutions have equivalent bindings" do
      s1 = described_class.new({a: "1"})
      s2 = described_class.new({a: "1"})
      expect(s1.compatible?(s2)).to be_truthy
    end

    it "returns true if two solutions have overlapping equivalent bindings" do
      s1 = described_class.new({a: "1", c: "3"})
      s2 = described_class.new({a: "1", b: "2"})
      expect(s1.compatible?(s2)).to be_truthy
    end

    it "returns false if two solutions any mappings which are different" do
      s1 = described_class.new({a: "1", c: "3"})
      s2 = described_class.new({a: "3", c: "3"})
      expect(s1.compatible?(s2)).to be_falsey
    end

    context "subsetByExcl02" do
      {
        "lifeForm1 and lifeForm2" => [
          described_class.new(animal: RDF::URI("http://www.w3.org/2009/sparql/docs/tests/data-sparql11/negation#lifeForm1")),
          described_class.new(animal: RDF::URI("http://www.w3.org/2009/sparql/docs/tests/data-sparql11/negation#lifeForm2"),
                                type: RDF::URI("http://www.w3.org/2009/sparql/docs/tests/data-sparql11/negation#Reptile")),
          false
        ],
        "lifeForm1 and lifeForm3" => [
          described_class.new(animal: RDF::URI("http://www.w3.org/2009/sparql/docs/tests/data-sparql11/negation#lifeForm1")),
          described_class.new(animal: RDF::URI("http://www.w3.org/2009/sparql/docs/tests/data-sparql11/negation#lifeForm3"),
                                type: RDF::URI("http://www.w3.org/2009/sparql/docs/tests/data-sparql11/negation#Insect")),
          false
        ],
        "lifeForm2 and lifeForm2" => [
          described_class.new(animal: RDF::URI("http://www.w3.org/2009/sparql/docs/tests/data-sparql11/negation#lifeForm2")),
          described_class.new(animal: RDF::URI("http://www.w3.org/2009/sparql/docs/tests/data-sparql11/negation#lifeForm2"),
                                type: RDF::URI("http://www.w3.org/2009/sparql/docs/tests/data-sparql11/negation#Reptile")),
          true
        ],
        "lifeForm2 and lifeForm3" => [
          described_class.new(animal: RDF::URI("http://www.w3.org/2009/sparql/docs/tests/data-sparql11/negation#lifeForm2")),
          described_class.new(animal: RDF::URI("http://www.w3.org/2009/sparql/docs/tests/data-sparql11/negation#lifeForm3"),
                                type: RDF::URI("http://www.w3.org/2009/sparql/docs/tests/data-sparql11/negation#Insect")),
          false
        ],
        "lifeForm3 and lifeForm2" => [
          described_class.new(animal: RDF::URI("http://www.w3.org/2009/sparql/docs/tests/data-sparql11/negation#lifeForm3")),
          described_class.new(animal: RDF::URI("http://www.w3.org/2009/sparql/docs/tests/data-sparql11/negation#lifeForm2"),
                                type: RDF::URI("http://www.w3.org/2009/sparql/docs/tests/data-sparql11/negation#Reptile")),
          false
        ],
        "lifeForm3 and lifeForm3" => [
          described_class.new(animal: RDF::URI("http://www.w3.org/2009/sparql/docs/tests/data-sparql11/negation#lifeForm3")),
          described_class.new(animal: RDF::URI("http://www.w3.org/2009/sparql/docs/tests/data-sparql11/negation#lifeForm3"),
                                type: RDF::URI("http://www.w3.org/2009/sparql/docs/tests/data-sparql11/negation#Insect")),
          true
        ],
      }.each do |name, (l, r, expect)|
        context name do
          if expect
            specify {expect(l).to be_compatible(r)}
          else
            specify {expect(l).not_to be_compatible(r)}
          end
        end
      end
    end
  end

  describe "#eql?" do
    it "returns true if two solutions have equivalent bindings" do
      s1 = described_class.new({a: "1"})
      s2 = described_class.new({a: "1"})
      expect(s1.eql?(s2)).to be_truthy
    end

    it "returns false if two solutions have overlapping equivalent bindings" do
      s1 = described_class.new({a: "1", c: "3"})
      s2 = described_class.new({a: "1", b: "2"})
      expect(s1.eql?(s2)).to be_falsey
    end

    it "returns false if two solutions any mappings which are different" do
      s1 = described_class.new({a: "1", c: "3"})
      s2 = described_class.new({a: "3", c: "3"})
      expect(s1.eql?(s2)).to be_falsey
    end
  end

  describe "#disjoint?" do
    {
      "with equivalent solutions" => [
        described_class.new({a: "1", c: "3"}),
        described_class.new({a: "1", c: "3"}),
        false
      ],
      "with overlapping solutions" => [
        described_class.new({a: "1", b: "3"}),
        described_class.new({a: "1", c: "3"}),
        false
      ],
      "with disjoint solutions" => [
        described_class.new({a: "1", b: "3"}),
        described_class.new({A: "1", B: "3"}),
        true
      ]
    }.each do |name, (l, r, expect)|
      context name do
        if expect
          specify {expect(l).to be_disjoint(r)}
        else
          specify {expect(l).not_to be_disjoint(r)}
        end
      end
    end

    context "subsetByExcl02" do
      {
        "lifeForm1 and lifeForm2" => [
          described_class.new(animal: RDF::URI("http://www.w3.org/2009/sparql/docs/tests/data-sparql11/negation#lifeForm1")),
          described_class.new(animal: RDF::URI("http://www.w3.org/2009/sparql/docs/tests/data-sparql11/negation#lifeForm2"),
                                type: RDF::URI("http://www.w3.org/2009/sparql/docs/tests/data-sparql11/negation#Reptile")),
          true
        ],
        "lifeForm1 and lifeForm3" => [
          described_class.new(animal: RDF::URI("http://www.w3.org/2009/sparql/docs/tests/data-sparql11/negation#lifeForm1")),
          described_class.new(animal: RDF::URI("http://www.w3.org/2009/sparql/docs/tests/data-sparql11/negation#lifeForm3"),
                                type: RDF::URI("http://www.w3.org/2009/sparql/docs/tests/data-sparql11/negation#Insect")),
          true
        ],
        "lifeForm2 and lifeForm2" => [
          described_class.new(animal: RDF::URI("http://www.w3.org/2009/sparql/docs/tests/data-sparql11/negation#lifeForm2")),
          described_class.new(animal: RDF::URI("http://www.w3.org/2009/sparql/docs/tests/data-sparql11/negation#lifeForm2"),
                                type: RDF::URI("http://www.w3.org/2009/sparql/docs/tests/data-sparql11/negation#Reptile")),
          false
        ],
        "lifeForm2 and lifeForm3" => [
          described_class.new(animal: RDF::URI("http://www.w3.org/2009/sparql/docs/tests/data-sparql11/negation#lifeForm2")),
          described_class.new(animal: RDF::URI("http://www.w3.org/2009/sparql/docs/tests/data-sparql11/negation#lifeForm3"),
                                type: RDF::URI("http://www.w3.org/2009/sparql/docs/tests/data-sparql11/negation#Insect")),
          true
        ],
        "lifeForm3 and lifeForm2" => [
          described_class.new(animal: RDF::URI("http://www.w3.org/2009/sparql/docs/tests/data-sparql11/negation#lifeForm3")),
          described_class.new(animal: RDF::URI("http://www.w3.org/2009/sparql/docs/tests/data-sparql11/negation#lifeForm2"),
                                type: RDF::URI("http://www.w3.org/2009/sparql/docs/tests/data-sparql11/negation#Reptile")),
          true
        ],
        "lifeForm3 and lifeForm3" => [
          described_class.new(animal: RDF::URI("http://www.w3.org/2009/sparql/docs/tests/data-sparql11/negation#lifeForm3")),
          described_class.new(animal: RDF::URI("http://www.w3.org/2009/sparql/docs/tests/data-sparql11/negation#lifeForm3"),
                                type: RDF::URI("http://www.w3.org/2009/sparql/docs/tests/data-sparql11/negation#Insect")),
          false
        ],
      }.each do |name, (l, r, expect)|
        context name do
          if expect
            specify {expect(l).to be_disjoint(r)}
          else
            specify {expect(l).not_to be_disjoint(r)}
          end
        end
      end
    end
  end

  context "Examples" do
    let(:foo) {RDF::Query::Variable.new(:title, "foo")}
    let(:bar) {RDF::Query::Variable.new(:mbox, "jrhacker@example.org")}
    let!(:solution) {described_class.new(title: "foo", mbox: "jrhacker@example.org")}

    it "Iterating over every binding in the solution" do
      expect {|b| solution.each_binding(&b)}.to yield_successive_args([:title, "foo"], [:mbox, "jrhacker@example.org"])
      expect {|b| solution.each_variable(&b)}.to yield_successive_args(foo, bar)
    end

    it "Iterating over every value in the solution" do
      expect {|b| solution.each_value(&b)}.to yield_successive_args("foo", "jrhacker@example.org")
    end

    it "Checking whether a variable is bound or unbound" do
      expect(solution).to be_bound(:title)
      expect(solution).not_to be_unbound(:mbox)
    end

    it "Retrieving the value of a bound variable" do
      expect(solution[:mbox]).to eq "jrhacker@example.org"
      expect(solution.mbox).to eq "jrhacker@example.org"
    end

    it "Responding to a bound variable" do
      expect(solution).to respond_to :mbox
    end
  end
end
