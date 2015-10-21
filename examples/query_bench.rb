#!/usr/bin/env ruby

require 'benchmark'
require 'rdf'
require 'rdf/vocab'
require 'rdf/ntriples'
graph = RDF::Graph.load("etc/doap.nt")

puts graph.query(predicate: RDF::Vocab::FOAF.name).is_a?(RDF::Queryable)

Benchmark.bmbm do |bench|
  bench.report("query_pattern") do
    100_000.times do
      graph.query(predicate: RDF::Vocab::FOAF.name) {}
    end
  end
end
