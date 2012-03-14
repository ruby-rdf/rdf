require File.join(File.dirname(__FILE__), 'spec_helper')
require 'rdf/spec/format'
require 'rdf/ntriples'
require 'rdf/nquads'

class RDF::Format::FooFormat < RDF::Format
  content_type     'application/test', :extension => :test
  reader { RDF::NTriples::Reader }
  def self.detect(sample)
    sample == "foo"
  end
end

class RDF::Format::BarFormat < RDF::Format
  content_type     'application/test', :extension => :test
  reader { RDF::NTriples::Reader }
  def self.detect(sample)
    sample == "bar"
  end
end

describe RDF::Format do
  before(:each) do
    @format_class = RDF::Format
  end
  
  # @see lib/rdf/spec/format.rb in rdf-spec
  it_should_behave_like RDF_Format
  
  # If there are multiple formats that assert the same type or extension,
  # Format.for should yield to return a sample used for detection
  describe ".for" do
    {
      "path with extension" => "filename.test",
      "file_name"           => {:file_name => "filename.test"},
      "file_extension"      => {:file_extension => "test"},
      "content_type"        => {:content_type => "application/test"},
    }.each do |condition, arg|
      it "yields given conflicting #{condition}" do
        yielded = false
        RDF::Format.for(arg) { yielded = true }
        yielded.should be_true
      end

      it "returns detected format given conflicting #{condition}" do
        RDF::Format.for(arg) { "foo" }.should == RDF::Format::FooFormat
        RDF::Format.for(arg) { "bar" }.should == RDF::Format::BarFormat
      end
    end
  end
end
