#!/usr/bin/env ruby

require 'benchmark/ips'
require 'rdf'
require 'rdf/vocab'
require 'rdf/ntriples'
graph = RDF::Graph.load("etc/doap.nt")

puts graph.query({predicate: RDF::Vocab::FOAF.name}).is_a?(RDF::Queryable)

Benchmark.ips do |x|
  x.config(:time => 10, :warmup => 5)
  x.report('query_pattern') { graph.query({predicate: RDF::Vocab::FOAF.name}) {} }
end
