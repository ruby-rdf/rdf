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
      expect(RDF::Node.instance_variable_get(:@cache)[:a]).to eq RDF::Node.intern("a")
    end

    it "freezes instance" do
      expect(RDF::Node.intern("a")).to be_frozen
    end
  end

  describe ".uuid" do
    it "generates a BNode" do
      expect(described_class.uuid).to be_a_node
    end

    it "accepts format: :default" do
      expect(described_class.uuid(format: :default)).to be_a_node
    end

    it "accepts format: :compact" do
      expect(described_class.uuid(format: :compact)).to be_a_node
    end

    it "rejects grammar: option" do
      expect {
        described_class.uuid(grammar: /\S+/)
      }.to raise_error(ArgumentError)
    end
  end

  context "as method" do
    it "with no args" do
      expect(described_class).to receive(:new).with(no_args)
      RDF::Node()
    end

    it "with positional arg" do
      expect(described_class).to receive(:new).with("a")
      RDF::Node("a")
    end
  end

  describe "#==" do
    specify {expect(new.call("a")).to eq new.call("a")}
    specify {expect(new.call(:a)).to eq new.call("a")}
    specify {expect(new.call("a")).not_to eq new.call("b")}
    specify {expect(new.call("a")).not_to eq Object.new}

    it 'does not equal non-nodes' do
      other = new.call(:a)
      allow(other).to receive(:node?).and_return(false)
      expect(new.call(:a)).not_to eq other
    end

    it 'does not equal nodes with a different term hash' do
      other = new.call(:a)
      allow(other.to_term).to receive(:hash).and_return('fake-hash')
      expect(new.call(:a)).not_to eq other
    end
  end

  describe "#eql" do
    specify {expect(new.call("a")).not_to eql new.call("a")}
    specify {expect(RDF::Node.intern("a")).to eql RDF::Node.intern("a")}
    specify {expect(RDF::Node.intern(:a)).to eql RDF::Node.intern("a")}
  end

  it "#start_with?" do
    expect(RDF::Node('foo')).to be_start_with('_:foo')
    expect(RDF::Node('bar')).not_to be_start_with('_:foo')
  end

  subject {new.call("foo")}

  describe "#dup" do
    specify {expect(subject.dup).to eql subject}
  end

  its(:to_base) {is_expected.to eq "_:foo"}
  its(:to_unique_base) {is_expected.to match /^_:g/}

  describe "#to_unique_base" do
    it "uses the to_unique_base of original if duped" do
      dup = subject.dup
      expect(dup.to_unique_base).to eql subject.to_unique_base
    end
  end

  {
    "" => true,
    "foo" => true,
    foo: true,
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

  describe "#make_unique!" do
    it "changes the id if assigned" do
      ub = subject.to_unique_base
      subject.make_unique!
      expect(subject.id).to eql ub[2..-1]
    end

    it "changes the id of a duplicated node based on the original node" do
      subject.freeze
      dup = subject.dup.make_unique!
      expect(dup.id).to eql subject.to_unique_base[2..-1]
    end
  end

  describe "#compatible?" do
    {
      %(_:abc) => {
        %("b") => false,
        %("b^^<http://www.w3.org/2001/XMLSchema#string>") => false,
        %("b"@ja) => false,
        %(<a>) => false,
        %(_:a) => false,
      },
    }.each do |l1, props|
      props.each do |l2, res|
        it "#{l1} should #{'not ' unless res}be compatible with #{l2}" do
          if res
            expect(RDF::NTriples::Reader.parse_object l1).to be_compatible(RDF::NTriples::Reader.parse_object l2)
          else
            expect(RDF::NTriples::Reader.parse_object l1).not_to be_compatible(RDF::NTriples::Reader.parse_object l2)
          end
        end
      end
    end
  end
end
