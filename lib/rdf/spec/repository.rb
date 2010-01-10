require 'rdf/spec'

share_as :RDF_Repository do
  include RDF::Spec::Matchers

  before :each do
    raise '+@repository+ must be defined in a before(:each) block' unless instance_variable_get('@repository')
    @filename   = File.expand_path(File.join(File.dirname(__FILE__), '..', '..', '..', 'etc', 'doap.nt'))
    @statements = RDF::NTriples::Reader.new(File.open(@filename)).to_a
    @enumerable = @repository
  end

  it "should be empty initially" do
    @repository.empty?.should be_true
    @repository.count.should be_zero
  end

  it "should be readable" do
    @repository.readable?.should be_true
  end

  it "should be mutable" do
    @repository.immutable?.should be_false
    @repository.mutable?.should be_true
  end

  context "when inserting statements" do
    it "should support #insert" do
      @repository.should respond_to(:insert)
    end

    it "should not raise errors" do
      lambda { @repository.insert(@statements.first) }.should_not raise_error
    end

    it "should support inserting one statement at a time" do
      @repository.insert(@statements.first)
    end

    it "should support inserting multiple statements at a time" do
      @repository.insert(*@statements)
    end

    it "should insert statements successfully" do
      @repository.insert(*@statements)
      @repository.count.should == @statements.size
    end
  end

  context "when deleting statements" do
    it "should support #delete" do
      @repository.should respond_to(:delete)
    end

    it "should not raise errors"
    it "should support deleting one statement at a time"
    it "should support deleting multiple statements at a time"
    it "should delete statements successfully"
  end

  context "when clearing all statements" do
    it "should support #clear" do
      @repository.should respond_to(:clear)
    end
  end

  context "when enumerating statements" do
    require 'rdf/spec/enumerable'

    before :each do
      @repository.insert(*@statements)
      @enumerable = @repository
    end

    it_should_behave_like RDF_Enumerable
  end
end
