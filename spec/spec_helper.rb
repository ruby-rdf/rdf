require "bundler/setup"
begin
  require 'simplecov'
  require 'coveralls'
  SimpleCov.formatter = SimpleCov::Formatter::MultiFormatter.new([
    SimpleCov::Formatter::HTMLFormatter,
    Coveralls::SimpleCov::Formatter
  ])
  SimpleCov.start do
    add_group "Mixins", 'lib/rdf/mixin'
    add_group "Models", 'lib/rdf/model'
    add_group "Query", 'lib/rdf/query'
    add_filter "/spec/"
  end
  Coveralls.wear!
rescue LoadError
end
require 'rdf'
require 'rdf/vocab'
require 'rdf/spec'
require 'rdf/spec/matchers'

RSpec.configure do |config|
  config.include(RDF::Spec::Matchers)
  config.filter_run focus: true
  config.run_all_when_everything_filtered = true
  config.exclusion_filter = {ruby: lambda { |version|
    RUBY_VERSION.to_s !~ /^#{version}/
  }}
end

def fixture_path(filename)
  File.join(File.dirname(__FILE__), 'data', filename)
end

Encoding.default_external = Encoding::UTF_8
Encoding.default_internal = Encoding::UTF_8
