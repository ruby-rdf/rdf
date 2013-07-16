require File.join(File.dirname(__FILE__), 'spec_helper')

describe RDF::Node do
  before :each do
    @new = Proc.new { |*args| RDF::Node.new(*args) }
  end

  it "should be instantiable" do
    expect { @new.call }.not_to raise_error
  end
  
  it "== a node with the same identifier" do
    expect(@new.call("a")).to eq(@new.call("a"))
  end

  it "is unlabled given an empty ID" do
    expect(@new.call("").to_s).not_to eq("_:")
  end
  it "not eql? a node with the same identifier" do
    expect(@new.call("a")).not_to be_eql(@new.call("a"))
  end

  subject {RDF::Node("foo")}

  {
    "" => true,
    "foo" => true,
    "1bc" => true,
    #".foo" => false
  }.each do |l, valid|
    context "given '#{l}'" do
      if valid
        specify {expect(RDF::Node(l)).to be_valid}
        specify {expect(RDF::Node(l)).not_to be_invalid}
        describe "#validate!" do
          specify {expect {RDF::Node(l).validate!}.not_to raise_error}
        end
      else
        specify {expect(RDF::Node(l)).not_to be_valid}
        specify {expect(RDF::Node(l)).to be_invalid}
        describe "#validate!" do
          specify {expect {RDF::Node(l).validate!}.to raise_error(ArgumentError)}
        end
      end
      describe "#canonicalize!" do
        specify {
          n = RDF::Node(l)
          expect(n.canonicalize!).to eq(n)
        }
      end
    end
  end
end
