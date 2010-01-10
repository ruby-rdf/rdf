require 'rdf/spec'

share_as :RDF_Enumerable do
  include RDF::Spec::Matchers

  before :each do
    raise '+@enumerable+ must be defined in a before(:each) block' unless instance_variable_get('@enumerable')
    raise '+@statements+ must be defined in a before(:each) block' unless instance_variable_get('@statements')
  end

  it "should support #empty?" do
    @enumerable.respond_to?(:empty?).should be_true

    ([].extend(RDF::Enumerable)).empty?.should be_true
    @enumerable.empty?.should be_false
  end

  it "should support #count and #size" do
    [:count, :size, :length].each do |method|
      @enumerable.respond_to?(method).should be_true

      @enumerable.send(method).should == @statements.size
    end
  end

  context "statements" do
    it "should support #statements" do
      @enumerable.respond_to?(:statements).should be_true

      @enumerable.statements.should be_instance_of(Array)
      @enumerable.statements.size.should == @statements.size
      @enumerable.statements.each { |statement| statement.should be_a_statement }
    end

    it "should support #has_statement?" do
      @enumerable.respond_to?(:has_statement?).should be_true

      @statements.each do |statement|
        @enumerable.has_statement?(statement).should be_true
      end

      @enumerable.has_statement?([RDF::Node.new, RDF::URI.new("http://example.org/unknown"), RDF::Node.new]).should be_false
    end

    it "should support #each_statement" do
      @enumerable.respond_to?(:each_statement).should be_true

      @enumerable.each_statement.should be_instance_of(Enumerable::Enumerator)
      @enumerable.each_statement { |statement| statement.should be_a_statement }
    end

    it "should support #enum_statement" do
      @enumerable.respond_to?(:enum_statement).should be_true

      @enumerable.enum_statement.should be_instance_of(Enumerable::Enumerator)
    end
  end

  context "triples" do
    it "should support #triples" do
      @enumerable.respond_to?(:triples).should be_true

      @enumerable.triples.should be_instance_of(Array)
      @enumerable.triples.size.should == @statements.size
      @enumerable.triples.each { |triple| triple.should be_a_triple }
    end

    it "should support #has_triple?" do
      @enumerable.respond_to?(:has_triple?).should be_true

      @statements.each do |statement|
        @enumerable.has_triple?(statement.to_triple).should be_true
      end
    end

    it "should support #each_triple" do
      @enumerable.respond_to?(:each_triple).should be_true

      @enumerable.each_triple.should be_instance_of(Enumerable::Enumerator)
      @enumerable.each_triple { |*triple| triple.should be_a_triple }
    end

    it "should support #enum_triple" do
      @enumerable.respond_to?(:enum_triple).should be_true

      @enumerable.enum_triple.should be_instance_of(Enumerable::Enumerator)
    end
  end

  context "quads" do
    it "should support #quads" do
      @enumerable.respond_to?(:quads).should be_true

      @enumerable.quads.should be_instance_of(Array)
      @enumerable.quads.size.should == @statements.size
      @enumerable.quads.each { |quad| quad.should be_a_quad }
    end

    it "should support #has_quad?" do
      @enumerable.respond_to?(:has_quad?).should be_true

      @statements.each do |statement|
        @enumerable.has_quad?(statement.to_quad).should be_true
      end
    end

    it "should support #each_quad" do
      @enumerable.respond_to?(:each_quad).should be_true

      @enumerable.each_quad.should be_instance_of(Enumerable::Enumerator)
      @enumerable.each_quad { |*quad| quad.should be_a_quad }
    end

    it "should support #enum_quad" do
      @enumerable.respond_to?(:enum_quad).should be_true

      @enumerable.enum_quad.should be_instance_of(Enumerable::Enumerator)
    end
  end

  context "subjects" do
    it "should support #subjects" do
      @enumerable.respond_to?(:subjects).should be_true

      @enumerable.subjects.should be_instance_of(Array)
      @enumerable.subjects.each { |value| value.should be_a_resource }
    end

    it "should support #has_subject?" do
      @enumerable.respond_to?(:has_subject?).should be_true

      @statements.each do |statement|
        @enumerable.has_subject?(statement.subject).should be_true
      end
    end

    it "should support #each_subject" do
      @enumerable.respond_to?(:each_subject).should be_true

      @enumerable.each_subject.should be_instance_of(Enumerable::Enumerator)
      @enumerable.each_subject { |value| value.should be_a_resource }
    end

    it "should support #enum_subject" do
      @enumerable.respond_to?(:enum_subject).should be_true

      @enumerable.enum_subject.should be_instance_of(Enumerable::Enumerator)
    end
  end

  context "predicates" do
    it "should support #predicates" do
      @enumerable.respond_to?(:predicates).should be_true

      @enumerable.predicates.should be_instance_of(Array)
      @enumerable.predicates.each { |value| value.should be_a_uri }
    end

    it "should support #has_predicate?" do
      @enumerable.respond_to?(:has_predicate?).should be_true

      @statements.each do |statement|
        @enumerable.has_predicate?(statement.predicate).should be_true
      end
    end

    it "should support #each_predicate" do
      @enumerable.respond_to?(:each_predicate).should be_true

      @enumerable.each_predicate.should be_instance_of(Enumerable::Enumerator)
      @enumerable.each_predicate { |value| value.should be_a_uri }
    end

    it "should support #enum_predicate" do
      @enumerable.respond_to?(:enum_predicate).should be_true

      @enumerable.enum_predicate.should be_instance_of(Enumerable::Enumerator)
    end
  end

  context "objects" do
    it "should support #objects" do
      @enumerable.respond_to?(:objects).should be_true

      @enumerable.objects.should be_instance_of(Array)
      @enumerable.objects.each { |value| value.should be_a_value }
    end

    it "should support #has_object?" do
      @enumerable.respond_to?(:has_object?).should be_true

      @statements.each do |statement|
        @enumerable.has_object?(statement.object).should be_true
      end
    end

    it "should support #each_object" do
      @enumerable.respond_to?(:each_object).should be_true

      @enumerable.each_object.should be_instance_of(Enumerable::Enumerator)
      @enumerable.each_object { |value| value.should be_a_value }
    end

    it "should support #enum_object" do
      @enumerable.respond_to?(:enum_object).should be_true

      @enumerable.enum_object.should be_instance_of(Enumerable::Enumerator)
    end
  end

  context "contexts" do
    it "should support #contexts" do
      @enumerable.respond_to?(:contexts).should be_true

      @enumerable.contexts.should be_instance_of(Array)
      @enumerable.contexts.each { |value| value.should be_a_resource }
    end

    it "should support #has_context?" do
      @enumerable.respond_to?(:has_context?).should be_true

      @statements.each do |statement|
        if statement.has_context?
          @enumerable.has_context?(statement.context).should be_true
        end
      end
    end

    it "should support #each_context" do
      @enumerable.respond_to?(:each_context).should be_true

      @enumerable.each_context.should be_instance_of(Enumerable::Enumerator)
      @enumerable.each_context { |value| value.should be_a_resource }
    end

    it "should support #enum_context" do
      @enumerable.respond_to?(:enum_context).should be_true

      @enumerable.enum_context.should be_instance_of(Enumerable::Enumerator)
    end
  end

  it "should support #to_hash" do
    @enumerable.respond_to?(:to_hash).should be_true

    # TODO
  end
end
