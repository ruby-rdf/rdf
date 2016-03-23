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
task default: :spec
task specs: :spec

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

require 'rdf/vocab/writer'

desc "Generate Vocabularies"
vocab_sources = {
  owl:    {uri: "http://www.w3.org/2002/07/owl#"},
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
  xsd:    {uri: "http://www.w3.org/2001/XMLSchema#",
           source: "etc/xsd.ttl",
           strict: false},
}

task gen_vocabs: vocab_sources.keys.map {|v| "lib/rdf/vocab/#{v}.rb"}

vocab_sources.each do |id, v|
  file "lib/rdf/vocab/#{id}.rb" => :do_build do
    puts "Generate lib/rdf/vocab/#{id}.rb"
    cmd = "bin/rdf serialize --uri '#{v[:uri]}' --output-format vocabulary"
    cmd += " --class-name #{id.to_s.upcase}"
    cmd += " -o lib/rdf/vocab/#{id}.rb_t"
    cmd += " --strict" if v.fetch(:strict, true)
    cmd += " '" + v.fetch(:source, v[:uri]) + "'"
    puts "  #{cmd}"
    begin
      %x{#{cmd} && mv lib/rdf/vocab/#{id}.rb_t lib/rdf/vocab/#{id}.rb}
    rescue
      %x{rm -f lib/rdf/vocab/#{id}.rb_t}
      puts "Failed to load #{id}: #{$!.message}"
    end
  end
end

task :do_build