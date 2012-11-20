require File.join(File.dirname(__FILE__), 'spec_helper')
require 'rdf/spec/inferable'

describe RDF::Inferable do
  # @see lib/rdf/spec/enumerable.rb in rdf-spec
  include RDF_Inferable
end
