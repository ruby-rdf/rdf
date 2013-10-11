require File.join(File.dirname(__FILE__), 'spec_helper')

describe RDF::Query::Solutions do
  let(:uri) {
    RDF::Query::Solution.new(
      :author => RDF::URI("http://ar.to/#self"),
      :age => RDF::Literal(0),
      :name => RDF::Literal("Arto Bendiken", :language => :es),
      :description => RDF::Literal("Description"),
      :updated => RDF::Literal(Date.today),
      :created => RDF::Literal(Date.parse("1970-01-01")),
      :title => RDF::Literal("RDF 1.1"),
      :price => RDF::Literal(30)
    )
  }
  let(:lit) {
    RDF::Query::Solution.new(
      :author => RDF::Literal("Gregg Kellogg"),
      :age => RDF::Literal(0),
      :name => RDF::Literal("Gregg Kellogg", :language => :en),
      :description => RDF::Literal("Description"),
      :updated => RDF::Literal(Date.today - 1),
      :created => RDF::Literal(Date.parse("1970-01-01")),
      :title => RDF::Literal("SPARQL 1.1 Query"),
      :price => RDF::Literal(40),
      :date => RDF::Literal(Date.parse("1957-02-27"))
    )
  }

  let(:solutions) {
    solns = RDF::Query::Solutions.new
    solns.concat [uri, lit]
    solns
  }
  subject {solutions}

  describe "new" do
    it "is instantiable" do
      expect { RDF::Query::Solutions.new }.not_to raise_error
      expect(RDF::Query::Solutions.new).to be_a(Array)
    end
  end

  describe "#filter" do
    it "using a hash" do
      {
        {:author  => RDF::URI("http://ar.to/#self")} => [uri],
        {:author  => "Gregg Kellogg"} => [lit],
        {:author  => [RDF::URI("http://ar.to/#self"), "Gregg Kellogg"]} => [uri, lit],
        {:updated => RDF::Literal(Date.today)} => [uri],
      }.each do |arg, result|
        expect(solutions.dup.filter(arg)).to eq result
      end
    end

    it "using a block" do
      {
        lambda { |solution| solution.author.literal? } => [lit],
        lambda { |solution| solution.title.to_s =~ /^SPARQL/ } => [lit],
        lambda { |solution| solution.price < 30.5 } => [uri],
        lambda { |solution| solution.bound?(:date) } => [lit],
        lambda { |solution| solution.age.datatype == RDF::XSD.integer } => [uri, lit],
        lambda { |solution| solution.name.language == :es } => [uri]
      }.each do |block, result|
        expect(solutions.dup.filter(&block)).to eq result
      end
    end
  end

  describe "#-" do
    {
      "subsetByExcl01" => [
        RDF::Query::Solutions.new.concat([
          RDF::Query::Solution.new(:animal => RDF::URI("http://www.w3.org/2009/sparql/docs/tests/data-sparql11/negation#lifeForm1")),
          RDF::Query::Solution.new(:animal => RDF::URI("http://www.w3.org/2009/sparql/docs/tests/data-sparql11/negation#lifeForm2")),
          RDF::Query::Solution.new(:animal => RDF::URI("http://www.w3.org/2009/sparql/docs/tests/data-sparql11/negation#lifeForm3")),
        ]),
        RDF::Query::Solutions.new.concat([
          RDF::Query::Solution.new(:animal => RDF::URI("http://www.w3.org/2009/sparql/docs/tests/data-sparql11/negation#lifeForm2"),
                                   :type => RDF::URI("http://www.w3.org/2009/sparql/docs/tests/data-sparql11/negation#Reptile")),
          RDF::Query::Solution.new(:animal => RDF::URI("http://www.w3.org/2009/sparql/docs/tests/data-sparql11/negation#lifeForm3"),
                                   :type => RDF::URI("http://www.w3.org/2009/sparql/docs/tests/data-sparql11/negation#Insect")),
        ]),
        RDF::Query::Solutions.new.concat([
          RDF::Query::Solution.new(:animal => RDF::URI("http://www.w3.org/2009/sparql/docs/tests/data-sparql11/negation#lifeForm1")),
        ])
      ],
      "exists-02" => [
        RDF::Query::Solutions.new.concat([
          RDF::Query::Solution.new(:a => RDF::URI("http://example/a0"), :b => RDF::URI("http://example/b0"), :c => RDF::URI("http://example/c0")),
          RDF::Query::Solution.new(:a => RDF::URI("http://example/a1"), :b => RDF::URI("http://example/b1"), :c => RDF::URI("http://example/c1")),
          RDF::Query::Solution.new(:a => RDF::URI("http://example/a2"), :b => RDF::URI("http://example/b2"), :c => RDF::URI("http://example/c2")),
          RDF::Query::Solution.new(:a => RDF::URI("http://example/a3"), :b => RDF::URI("http://example/b3"), :c => RDF::URI("http://example/c3")),
        ]),
        RDF::Query::Solutions.new.concat([
          RDF::Query::Solution.new(:d => RDF::URI("http://example/d0")),
          RDF::Query::Solution.new(:d => RDF::URI("http://example/d1"), :b => RDF::URI("http://example/b1"), :c => RDF::URI("http://example/c1")),
          RDF::Query::Solution.new(:d => RDF::URI("http://example/d2"), :b => RDF::URI("http://example/b2")),
          RDF::Query::Solution.new(:d => RDF::URI("http://example/d3"), :b => RDF::URI("http://example/b3"), :c => RDF::URI("http://example/cx")),
        ]),
        RDF::Query::Solutions.new.concat([
          RDF::Query::Solution.new(:a => RDF::URI("http://example/a0"), :b => RDF::URI("http://example/b0"), :c => RDF::URI("http://example/c0")),
          RDF::Query::Solution.new(:a => RDF::URI("http://example/a3"), :b => RDF::URI("http://example/b3"), :c => RDF::URI("http://example/c3")),
        ])
      ],
      "full-minuend" => [
        RDF::Query::Solutions.new.concat([
          RDF::Query::Solution.new(:a => RDF::URI("http://example/a1"), :b => RDF::URI("http://example/b1")),
          RDF::Query::Solution.new(:a => RDF::URI("http://example/a2"), :b => RDF::URI("http://example/b2")),
          RDF::Query::Solution.new(:a => RDF::URI("http://example/a3"), :b => RDF::URI("http://example/b3")),
          RDF::Query::Solution.new(:a => RDF::URI("http://example/a4")),
        ]),
        RDF::Query::Solutions.new.concat([
          RDF::Query::Solution.new(:d => RDF::URI("http://example/d1"), :b => RDF::URI("http://example/b1")),
          RDF::Query::Solution.new(:d => RDF::URI("http://example/d3"), :b => RDF::URI("http://example/b3"), :c => RDF::URI("http://example/c3")),
          RDF::Query::Solution.new(:d => RDF::URI("http://example/d4"), :b => RDF::URI("http://example/b4"), :c => RDF::URI("http://example/c4")),
          RDF::Query::Solution.new(:d => RDF::URI("http://example/d5")),
        ]),
        RDF::Query::Solutions.new.concat([
          RDF::Query::Solution.new(:a => RDF::URI("http://example/a2"), :b => RDF::URI("http://example/b2")),
          RDF::Query::Solution.new(:a => RDF::URI("http://example/a4")),
        ])
      ],
    }.each do |name, (left, right, result)|
      it name do
        expect(left.minus(right)).to eq result
      end
    end
  end

  describe "#order_by" do
    it "Reordering solutions based on a variable or proc" do
      expect(solutions.dup.order_by(:updated, lambda {|a, b| b <=> a})).to eq [lit, uri]
    end
  end

  describe "#select" do
    it "Selecting/Projecting particular variables only (1)" do
      expect(solutions.select(:title)).to eq [
        RDF::Query::Solution.new(:title => RDF::Literal("RDF 1.1")),
        RDF::Query::Solution.new(:title => RDF::Literal("SPARQL 1.1 Query")),
      ]
    end

    it "Selecting/Projecting particular variables only (2)" do
      expect(solutions.select(:title, :description)).to eq [
        RDF::Query::Solution.new(:title => RDF::Literal("RDF 1.1"), :description => RDF::Literal("Description")),
        RDF::Query::Solution.new(:title => RDF::Literal("SPARQL 1.1 Query"), :description => RDF::Literal("Description")),
      ]
    end
  end

  describe "#project" do
    it "Selecting/Projecting particular variables only" do
      expect(solutions.project(:title)).to eq [
        RDF::Query::Solution.new(:title => RDF::Literal("RDF 1.1")),
        RDF::Query::Solution.new(:title => RDF::Literal("SPARQL 1.1 Query")),
      ]
    end
  end

  describe "#distinct" do
    it "Eliminating duplicate solutions" do
      solutions << uri
      expect(solutions).to eq [uri, lit, uri]
      expect(solutions.distinct).to eq [uri, lit]
    end
  end

  describe "#offset" do
    it "Eliminating duplicate solutions", :pending => ("rubinius index problem" if RUBY_ENGINE == "rbx") do
      expect(solutions.offset(20).limit(20)).to be_empty
    end
  end

  describe "#count" do
    it "Counting the number of matching solutions" do
      expect(solutions.count).to eq 2
      expect(solutions.count { |solution| solution.price < 30.5 }).to eq 1
    end
  end

  describe "#each" do
    it "Iterating over all found solutions" do
      expect {|b| solutions.each(&b)}.to yield_successive_args(uri, lit)
    end
  end
end
