#!/usr/bin/env ruby

require 'benchmark'
require 'rdf'
require 'rdf/ntriples'
graph = RDF::Graph.load("etc/doap.nt")

puts graph.query(:predicate => RDF::FOAF.name).is_a?(RDF::Queryable)

Benchmark.bmbm do |bench|
  bench.report("query_pattern") do
    100_000.times do
      graph.query(:predicate => RDF::FOAF.name)
    end
  end
end
