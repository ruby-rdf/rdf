require File.join(File.dirname(__FILE__), 'spec_helper')

describe RDF::Node do
  let(:new) {Proc.new { |*args| RDF::Node.new(*args) }}

  it "should be instantiable" do
    expect { new.call }.not_to raise_error
  end
  
  describe ".intern" do
    before(:each) {RDF::URI.instance_variable_set(:@cache, nil)}
    it "caches Node instance" do
      RDF::Node.intern("a")
      expect(RDF::Node.instance_variable_get(:@cache)["a"]).to eq RDF::Node.intern("a")
    end

    it "freezes instance" do
      expect(RDF::Node.intern("a")).to be_frozen
    end
  end

  describe "#eq" do
    specify {expect(new.call("a")).to eq new.call("a")}
    specify {expect(new.call(:a)).to eq new.call("a")}
    specify {expect(new.call("a")).not_to eq new.call("b")}
  end

  describe "#eql" do
    specify {expect(new.call("a")).not_to eql new.call("a")}
    specify {expect(RDF::Node.intern("a")).to eql RDF::Node.intern("a")}
    specify {expect(RDF::Node.intern(:a)).to eql RDF::Node.intern("a")}
  end

  subject {new.call("foo")}

  describe "#dup" do
    specify {expect(subject.dup).to eql subject}
  end

  {
    "" => true,
    "foo" => true,
    :foo => true,
    "1bc" => true,
  }.each do |l, valid|
    context "given '#{l}'" do
      if valid
        specify {expect(new.call(l)).to be_valid}
        specify {expect(new.call(l)).not_to be_invalid}
        describe "#validate!" do
          specify {expect {new.call(l).validate!}.not_to raise_error}
        end
      else
        specify {expect(new.call(l)).not_to be_valid}
        specify {expect(new.call(l)).to be_invalid}
        describe "#validate!" do
          specify {expect {new.call(l).validate!}.to raise_error(ArgumentError)}
        end
      end
      describe "#canonicalize!" do
        specify {
          n = new.call(l)
          expect(n.canonicalize!).to eq(n)
        }
      end
    end
  end
end
