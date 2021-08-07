require "bundler/setup"
begin
  require 'simplecov'
  require 'simplecov-lcov'
  require 'coveralls'

  SimpleCov::Formatter::LcovFormatter.config do |config|
    #Coveralls is coverage by default/lcov. Send info results
    config.report_with_single_file = true
    config.single_report_path = 'coverage/lcov.info'
  end

  SimpleCov.formatter = SimpleCov::Formatter::MultiFormatter.new([
    SimpleCov::Formatter::HTMLFormatter,
    SimpleCov::Formatter::LcovFormatter
  ])
  SimpleCov.start do
    add_group "Mixins", 'lib/rdf/mixin'
    add_group "Models", 'lib/rdf/model'
    add_group "Query", 'lib/rdf/query'
    add_filter "/spec/"
  end
rescue LoadError => e
  STDERR.puts "Coverage Skipped: #{e.message}"
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
