require File.join(File.dirname(__FILE__), 'spec_helper')

describe RDF::Resource do
  subject {Proc.new { |*args| RDF::Resource.new(*args) }}

  it "should instantiate blank nodes" do
    resource = subject.call('_:foobar')
    expect(resource).to be_a_node
    expect(resource.id).to eq 'foobar'
  end

  it "should instantiate URIs" do
    resource = subject.call('https://rubygems.org/gems/rdf')
    expect(resource).to be_a_uri
    expect(resource.to_s).to eq 'https://rubygems.org/gems/rdf'
  end

  context "as method" do
    it "with positional arg" do
      expect(described_class).to receive(:new).with('https://rubygems.org/gems/rdf')
      subject.call('https://rubygems.org/gems/rdf')
    end
  end
end
