require 'rdf'
require 'rdf/spec'

def etc_file(filename)
  File.join(File.dirname(__FILE__), '..','etc', filename)
end

def fixture(filename)
  File.join(File.dirname(__FILE__), 'data', filename)
end

Spec::Runner.configure do |config|
  config.include(RDF::Spec::Matchers)
end
