require 'rdf'

describe RDF::Query do
  context "when created" do
    it "should be instantiable" do
      lambda { RDF::Query.new }.should_not raise_error
    end
  end

  context "solution modifiers" do
    before :each do
      @graph = RDF::Repository.load("spec/data/test.nt")
      @query = RDF::Query.new(:solutions => @graph.map { |stmt| stmt.to_hash(:s, :p, :o) })
    end

    it "should support projection" do
      @query.select(:s, :p, :o)
      @query.solutions.each do |vars, vals|
        vars.keys.should include(:s, :p, :o)
      end

      @query.select(:s, :p)
      @query.solutions.each do |vars, vals|
        vars.keys.should include(:s, :p)
        vars.keys.should_not include(:o)
      end

      @query.select(:s)
      @query.solutions.each do |vars, vals|
        vars.keys.should include(:s)
        vars.keys.should_not include(:p, :o)
      end
    end
  end
end
