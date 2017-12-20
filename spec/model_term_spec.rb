require File.join(File.dirname(__FILE__), 'spec_helper')

describe RDF::Term do
  subject {"".extend(described_class)}
  let(:other) {"foo".extend(described_class)}

  it "should not be instantiable" do
    expect { described_class.new }.to raise_error(NoMethodError)
  end

  it "#==" do
    is_expected.to eq subject
    is_expected.not_to eq other
  end

  it "#eql?" do
    is_expected.to eql subject
    is_expected.not_to eql other
  end

  it "#term?" do
    is_expected.to be_term
  end

  it "#to_term" do
    expect(subject.to_term).to equal subject
  end

  it "#to_ruby" do
    expect {subject.to_ruby}.not_to raise_error
  end

  it "#to_base" do
    expect(subject.to_base).to be_a(String)
  end

  it "#compatible?" do
    is_expected.not_to be_compatible(other)
  end

end
