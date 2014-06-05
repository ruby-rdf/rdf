require File.join(File.dirname(__FILE__), 'spec_helper')

describe RDF::Query::Solution do
  describe "new" do
    it "is instantiable" do
      expect { RDF::Query::Solution.new }.not_to raise_error
    end
  end
  
  describe "#compatible?" do
    it "returns true if two solutions have equivalent bindings" do
      s1 = RDF::Query::Solution.new({:a => "1"})
      s2 = RDF::Query::Solution.new({:a => "1"})
      expect(s1.compatible?(s2)).to be_truthy
    end

    it "returns true if two solutions have overlapping equivalent bindings" do
      s1 = RDF::Query::Solution.new({:a => "1", :c => "3"})
      s2 = RDF::Query::Solution.new({:a => "1", :b => "2"})
      expect(s1.compatible?(s2)).to be_truthy
    end
    
    it "returns false if two solutions any mappings which are different" do
      s1 = RDF::Query::Solution.new({:a => "1", :c => "3"})
      s2 = RDF::Query::Solution.new({:a => "3", :c => "3"})
      expect(s1.compatible?(s2)).to be_falsey
    end

    context "subsetByExcl02" do
      {
        "lifeForm1 and lifeForm2" => [
          RDF::Query::Solution.new(:animal => RDF::URI("http://www.w3.org/2009/sparql/docs/tests/data-sparql11/negation#lifeForm1")),
          RDF::Query::Solution.new(:animal => RDF::URI("http://www.w3.org/2009/sparql/docs/tests/data-sparql11/negation#lifeForm2"),
                                   :type => RDF::URI("http://www.w3.org/2009/sparql/docs/tests/data-sparql11/negation#Reptile")),
          false
        ],
        "lifeForm1 and lifeForm3" => [
          RDF::Query::Solution.new(:animal => RDF::URI("http://www.w3.org/2009/sparql/docs/tests/data-sparql11/negation#lifeForm1")),
          RDF::Query::Solution.new(:animal => RDF::URI("http://www.w3.org/2009/sparql/docs/tests/data-sparql11/negation#lifeForm3"),
                                   :type => RDF::URI("http://www.w3.org/2009/sparql/docs/tests/data-sparql11/negation#Insect")),
          false
        ],
        "lifeForm2 and lifeForm2" => [
          RDF::Query::Solution.new(:animal => RDF::URI("http://www.w3.org/2009/sparql/docs/tests/data-sparql11/negation#lifeForm2")),
          RDF::Query::Solution.new(:animal => RDF::URI("http://www.w3.org/2009/sparql/docs/tests/data-sparql11/negation#lifeForm2"),
                                   :type => RDF::URI("http://www.w3.org/2009/sparql/docs/tests/data-sparql11/negation#Reptile")),
          true
        ],
        "lifeForm2 and lifeForm3" => [
          RDF::Query::Solution.new(:animal => RDF::URI("http://www.w3.org/2009/sparql/docs/tests/data-sparql11/negation#lifeForm2")),
          RDF::Query::Solution.new(:animal => RDF::URI("http://www.w3.org/2009/sparql/docs/tests/data-sparql11/negation#lifeForm3"),
                                   :type => RDF::URI("http://www.w3.org/2009/sparql/docs/tests/data-sparql11/negation#Insect")),
          false
        ],
        "lifeForm3 and lifeForm2" => [
          RDF::Query::Solution.new(:animal => RDF::URI("http://www.w3.org/2009/sparql/docs/tests/data-sparql11/negation#lifeForm3")),
          RDF::Query::Solution.new(:animal => RDF::URI("http://www.w3.org/2009/sparql/docs/tests/data-sparql11/negation#lifeForm2"),
                                   :type => RDF::URI("http://www.w3.org/2009/sparql/docs/tests/data-sparql11/negation#Reptile")),
          false
        ],
        "lifeForm3 and lifeForm3" => [
          RDF::Query::Solution.new(:animal => RDF::URI("http://www.w3.org/2009/sparql/docs/tests/data-sparql11/negation#lifeForm3")),
          RDF::Query::Solution.new(:animal => RDF::URI("http://www.w3.org/2009/sparql/docs/tests/data-sparql11/negation#lifeForm3"),
                                   :type => RDF::URI("http://www.w3.org/2009/sparql/docs/tests/data-sparql11/negation#Insect")),
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
      s1 = RDF::Query::Solution.new({:a => "1"})
      s2 = RDF::Query::Solution.new({:a => "1"})
      expect(s1.eql?(s2)).to be_truthy
    end

    it "returns false if two solutions have overlapping equivalent bindings" do
      s1 = RDF::Query::Solution.new({:a => "1", :c => "3"})
      s2 = RDF::Query::Solution.new({:a => "1", :b => "2"})
      expect(s1.eql?(s2)).to be_falsey
    end
    
    it "returns false if two solutions any mappings which are different" do
      s1 = RDF::Query::Solution.new({:a => "1", :c => "3"})
      s2 = RDF::Query::Solution.new({:a => "3", :c => "3"})
      expect(s1.eql?(s2)).to be_falsey
    end
  end

  describe "#disjoint?" do
    {
      "with equivalent solutions" => [
        RDF::Query::Solution.new({:a => "1", :c => "3"}),
        RDF::Query::Solution.new({:a => "1", :c => "3"}),
        false
      ],
      "with overlapping solutions" => [
        RDF::Query::Solution.new({:a => "1", :b => "3"}),
        RDF::Query::Solution.new({:a => "1", :c => "3"}),
        false
      ],
      "with disjoint solutions" => [
        RDF::Query::Solution.new({:a => "1", :b => "3"}),
        RDF::Query::Solution.new({:A => "1", :B => "3"}),
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
          RDF::Query::Solution.new(:animal => RDF::URI("http://www.w3.org/2009/sparql/docs/tests/data-sparql11/negation#lifeForm1")),
          RDF::Query::Solution.new(:animal => RDF::URI("http://www.w3.org/2009/sparql/docs/tests/data-sparql11/negation#lifeForm2"),
                                   :type => RDF::URI("http://www.w3.org/2009/sparql/docs/tests/data-sparql11/negation#Reptile")),
          true
        ],
        "lifeForm1 and lifeForm3" => [
          RDF::Query::Solution.new(:animal => RDF::URI("http://www.w3.org/2009/sparql/docs/tests/data-sparql11/negation#lifeForm1")),
          RDF::Query::Solution.new(:animal => RDF::URI("http://www.w3.org/2009/sparql/docs/tests/data-sparql11/negation#lifeForm3"),
                                   :type => RDF::URI("http://www.w3.org/2009/sparql/docs/tests/data-sparql11/negation#Insect")),
          true
        ],
        "lifeForm2 and lifeForm2" => [
          RDF::Query::Solution.new(:animal => RDF::URI("http://www.w3.org/2009/sparql/docs/tests/data-sparql11/negation#lifeForm2")),
          RDF::Query::Solution.new(:animal => RDF::URI("http://www.w3.org/2009/sparql/docs/tests/data-sparql11/negation#lifeForm2"),
                                   :type => RDF::URI("http://www.w3.org/2009/sparql/docs/tests/data-sparql11/negation#Reptile")),
          false
        ],
        "lifeForm2 and lifeForm3" => [
          RDF::Query::Solution.new(:animal => RDF::URI("http://www.w3.org/2009/sparql/docs/tests/data-sparql11/negation#lifeForm2")),
          RDF::Query::Solution.new(:animal => RDF::URI("http://www.w3.org/2009/sparql/docs/tests/data-sparql11/negation#lifeForm3"),
                                   :type => RDF::URI("http://www.w3.org/2009/sparql/docs/tests/data-sparql11/negation#Insect")),
          true
        ],
        "lifeForm3 and lifeForm2" => [
          RDF::Query::Solution.new(:animal => RDF::URI("http://www.w3.org/2009/sparql/docs/tests/data-sparql11/negation#lifeForm3")),
          RDF::Query::Solution.new(:animal => RDF::URI("http://www.w3.org/2009/sparql/docs/tests/data-sparql11/negation#lifeForm2"),
                                   :type => RDF::URI("http://www.w3.org/2009/sparql/docs/tests/data-sparql11/negation#Reptile")),
          true
        ],
        "lifeForm3 and lifeForm3" => [
          RDF::Query::Solution.new(:animal => RDF::URI("http://www.w3.org/2009/sparql/docs/tests/data-sparql11/negation#lifeForm3")),
          RDF::Query::Solution.new(:animal => RDF::URI("http://www.w3.org/2009/sparql/docs/tests/data-sparql11/negation#lifeForm3"),
                                   :type => RDF::URI("http://www.w3.org/2009/sparql/docs/tests/data-sparql11/negation#Insect")),
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
    let!(:solution) {RDF::Query::Solution.new(:title => "foo", :mbox => "jrhacker@example.org")}

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

    it "Retrieving all bindings in the solution as a Hash" do
      expect(solution.to_hash).to eq({:title => "foo", :mbox => "jrhacker@example.org"})
    end
  end
end
