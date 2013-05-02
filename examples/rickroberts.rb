#!/usr/bin/env ruby

require 'rdf'

file = File.expand_path("../england.nt", __FILE__)
triples = File.read(file)

graph = RDF::Graph.new # takes similar amounts of time if this is a repository

start = Time.now

RDF::Reader.for(:ntriples).new(triples) do |reader|
  reader.each_statement do |statement|
    graph << statement
  end
end

#statements = []
#i = 0
#RDF::Reader.for(:ntriples).open(file) {|r| r.each {|s| statements << s}}
#statements.extend(RDF::Enumerable)
finish = Time.now

#statements.subjects.count
puts "it took #{finish - start}s"
