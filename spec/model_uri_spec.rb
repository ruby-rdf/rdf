require File.join(File.dirname(__FILE__), 'spec_helper')

require 'rdf/spec/uri'

describe RDF::URI do

  before :each do
    @new = Proc.new { | *args | RDF::URI.new(*args) }
  end

  it_should_behave_like RDF_URI

end
