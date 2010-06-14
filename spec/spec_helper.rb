require 'rdf'
require 'rdf/spec'

Spec::Runner.configure do |config|
  config.include(RDF::Spec::Matchers)
end

def fixture_path(filename)
  File.join(File.dirname(__FILE__), 'data', filename)
end
