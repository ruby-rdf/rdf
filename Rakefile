#!/usr/bin/env ruby
$:.unshift(File.expand_path(File.join(File.dirname(__FILE__), 'lib')))
require 'rubygems'
require 'rdf'

namespace :gem do
  desc "Build the rdf-#{File.read('VERSION').chomp}.gem file"
  task :build do
    sh "gem build rdf.gemspec && mv rdf-#{File.read('VERSION').chomp}.gem pkg/"
  end

  desc "Release the rdf-#{File.read('VERSION').chomp}.gem file"
  task :release do
    sh "gem push pkg/rdf-#{File.read('VERSION').chomp}.gem"
  end
end

desc 'Default: run specs.'
task :default => :spec
task :specs => :spec

require 'rspec/core/rake_task'
desc 'Run specifications'
RSpec::Core::RakeTask.new do |spec|
  spec.rspec_opts = %w(--options spec/spec.opts) if File.exists?('spec/spec.opts')
end

desc "Run specifications for continuous integration"
RSpec::Core::RakeTask.new("spec:ci") do |spec|
  spec.rspec_opts = %w(--options spec/spec.opts) if File.exists?('spec/spec.opts')
end

desc "Generate etc/doap.nt from etc/doap.ttl."
task :doap do
  sh "bin/rdf serialize etc/doap.ttl --output etc/doap.nt"
end

require 'linkeddata'
require 'rdf/cli/vocab-loader'

desc "Generate Vocabularies"
vocab_sources = {
  cc:     {uri: "http://creativecommons.org/ns#"},
  cert:   {uri: "http://www.w3.org/ns/auth/cert#"},
  dc:     {uri: "http://purl.org/dc/terms/"},
  dc11:   {uri: "http://purl.org/dc/elements/1.1/"},
  doap:   {uri: "http://usefulinc.com/ns/doap#"},
  exif:   {uri: "http://www.w3.org/2003/12/exif/ns#"},
  foaf:   {uri: "http://xmlns.com/foaf/0.1/"},
  geo:    {uri: "http://www.w3.org/2003/01/geo/wgs84_pos#"},
  gr:     {uri: "http://purl.org/goodrelations/v1#", source: "http://www.heppnetz.de/ontologies/goodrelations/v1.owl"},
  ht:     {uri: "http://www.w3.org/2006/http#"},
  ical:   {uri: "http://www.w3.org/2002/12/cal/icaltzd#"},
  ma:     {uri: "http://www.w3.org/ns/ma-ont#", source: "http://www.w3.org/ns/ma-ont.rdf"},
  mo:     {uri: "http://purl.org/ontology/mo/"},
  og:     {uri: "http://ogp.me/ns#"},
  owl:    {uri: "http://www.w3.org/2002/07/owl#"},
  prov:   {uri: "http://www.w3.org/ns/prov#"},
  rdfs:   {uri: "http://www.w3.org/2000/01/rdf-schema#"},
  # Result requires manual editing
  #rdfv:   {uri: "http://www.w3.org/1999/02/22-rdf-syntax-ns#",
  #        extra: {
  #          about: {comment: "RDF/XML attribute declaring subject"},
  #          Alt: {comment: "RDF/XML Alt container"},
  #          Bag: {comment: "RDF/XML Bag container"},
  #          datatype: {comment: "RDF/XML literal datatype"},
  #          Description: {comment: "RDF/XML node element"},
  #          ID: {comment: "RDF/XML attribute creating a Reification"},
  #          li: {comment: "RDF/XML container membership list element"},
  #          nil: {comment: "The empty list, with no items in it. If the rest of a list is nil then the list has no more items in it."},
  #          nodeID: {comment: "RDF/XML Blank Node identifier"},
  #          object: {comment: "RDF/XML reification object"},
  #          parseType: {comment: "Parse type for RDF/XML, either Collection, Literal or Resource"},
  #          predicate: {comment: "RDF/XML reification predicate"},
  #          resource: {comment: "RDF/XML attribute declaring object"},
  #          Seq: {comment: "RDF/XML Seq container"},
  #          Statement: {comment: "RDF/XML reification Statement"},
  #          subject: {comment: "RDF/XML reification subject"},
  #        }},
  rsa:    {uri: "http://www.w3.org/ns/auth/rsa#"},
  rss:    {uri: "http://purl.org/rss/1.0/", source: "http://purl.org/rss/1.0/schema.rdf"},
  schema: {uri: "http://schema.org/", source: "http://schema.org/docs/schema_org_rdfa.html"},
  sioc:   {uri: "http://rdfs.org/sioc/ns#"},
  skos:   {uri: "http://www.w3.org/2004/02/skos/core#"},
  skosxl: {uri: "http://www.w3.org/2008/05/skos-xl#", source: "http://www.w3.org/TR/skos-reference/skos-xl.rdf"},
  v:      {uri: "http://rdf.data-vocabulary.org/#", source: "etc/rdf.data-vocab.ttl"},
  vmd:    {uri: "http://data-vocabulary.org/", source: "etc/data-vocab.ttl"},
  vcard:  {uri: "http://www.w3.org/2006/vcard/ns#"},
  void:   {uri: "http://rdfs.org/ns/void#", source: "http://vocab.deri.ie/void.rdf"},
  vs:     {uri: "http://www.w3.org/2003/06/sw-vocab-status/ns#"},
  wdrs:   {uri: "http://www.w3.org/2007/05/powder-s#"},
  wot:    {uri: "http://xmlns.com/wot/0.1/", source: "http://xmlns.com/wot/0.1/index.rdf"},
  xhtml:  {uri: "http://www.w3.org/1999/xhtml#", strict: false},
  xhv:    {uri: "http://www.w3.org/1999/xhtml/vocab#", strict: false},
  xsd:    {uri: "http://www.w3.org/2001/XMLSchema#",
           source: "etc/xsd.ttl",
           strict: false},
}

task :gen_vocabs => vocab_sources.keys.map {|v| "lib/rdf/vocab/#{v}.rb"}

vocab_sources.each do |id, v|
  file "lib/rdf/vocab/#{id}.rb" => :do_build do
    puts "Generate lib/rdf/vocab/#{id}.rb"
    begin
      out = StringIO.new
      loader = RDF::VocabularyLoader.new(id.to_s.upcase)
      loader.uri = v[:uri]
      loader.source = v[:source] if v[:source]
      loader.extra = v[:extra] if v[:extra]
      loader.strict = v.fetch(:strict, true)
      loader.output = out
      loader.run
      out.rewind
      File.open("lib/rdf/vocab/#{id}.rb", "w") {|f| f.write out.read}
    rescue
      puts "Failed to load #{id}: #{$!.message}"
    end
  end
end

task :do_build