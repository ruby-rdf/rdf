#!/usr/bin/env ruby
$:.unshift(File.expand_path(File.join(File.dirname(__FILE__), 'lib')))
require 'rubygems'
begin
  require 'rakefile' # @see http://github.com/bendiken/rakefile
rescue LoadError => e
end

require 'rdf'

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

desc "Build the rdf-#{File.read('VERSION').chomp}.gem file"
task :build do
  sh "gem build .gemspec"
end

desc "Generate etc/doap.nt from etc/doap.ttl."
task :doap do
  sh "bin/rdf serialize etc/doap.ttl --output etc/doap.nt"
end

require 'linkeddata'
require 'rdf/cli/vocab-loader'

desc "Generate Vocabularies"
vocab_sources = {
  :cc     => {:prefix => "http://creativecommons.org/ns#"},
  :cert   => {:prefix => "http://www.w3.org/ns/auth/cert#", :extra => %w(hex)},
  :dc     => {:prefix => "http://purl.org/dc/terms/"},
  :dc11   => {:prefix => "http://purl.org/dc/elements/1.1/"},
  :doap   => {:prefix => "http://usefulinc.com/ns/doap#"},
  :exif   => {:prefix => "http://www.w3.org/2003/12/exif/ns#"},
  :foaf   => {:prefix => "http://xmlns.com/foaf/0.1/"},
  :geo    => {:prefix => "http://www.w3.org/2003/01/geo/wgs84_pos#"},
  :gr     => {:prefix => "http://purl.org/goodrelations/v1#", :source => "http://www.heppnetz.de/ontologies/goodrelations/v1.owl"},
  :http   => {:prefix => "http://www.w3.org/2006/http#"},
  :ical   => {:prefix => "http://www.w3.org/2002/12/cal/icaltzd#"},
  :ma     => {:prefix => "http://www.w3.org/ns/ma-ont#", :source => "http://www.w3.org/ns/ma-ont.rdf"},
  :og     => {:prefix => "http://ogp.me/ns#"},
  :owl    => {:prefix => "http://www.w3.org/2002/07/owl#"},
  :prov   => {:prefix => "http://www.w3.org/ns/prov#"},
  :rdfs   => {:prefix => "http://www.w3.org/2000/01/rdf-schema#"},
  :rsa    => {:prefix => "http://www.w3.org/ns/auth/rsa#"},
  :rss    => {:prefix => "http://purl.org/rss/1.0/", :source => "http://purl.org/rss/1.0/schema.rdf"},
  :schema => {:prefix => "http://schema.org/", :source => "http://schema.org/docs/schema_org_rdfa.html"},
  :sioc   => {:prefix => "http://rdfs.org/sioc/ns#"},
  :skos   => {:prefix => "http://www.w3.org/2004/02/skos/core#"},
  :skosxl => {:prefix => "http://www.w3.org/2008/05/skos-xl#", :source => "http://www.w3.org/TR/skos-reference/skos-xl.rdf"},
  :v      => {:prefix => "http://rdf.data-vocabulary.org/"},
  :vcard  => {:prefix => "http://www.w3.org/2006/vcard/ns#"},
  :void   => {:prefix => "http://rdfs.org/ns/void#", :source => "http://vocab.deri.ie/void.rdf"},
  :wdr    => {:prefix => "http://www.w3.org/2007/05/powder#"},
  :wdrs   => {:prefix => "http://www.w3.org/2007/05/powder-s#"},
  :wot    => {:prefix => "http://xmlns.com/wot/0.1/", :source => "http://xmlns.com/wot/0.1/index.rdf"},
  :xhtml  => {:prefix => "http://www.w3.org/1999/xhtml#"},
  :xhv    => {:prefix => "http://www.w3.org/1999/xhtml/vocab#"},
  #:xsd    => {:prefix => "http://www.w3.org/2001/XMLSchema#", :source => "http://groups.csail.mit.edu/mac/projects/tami/amord/xsd.ttl"},
}

task :gen_vocabs => vocab_sources.keys.map {|v| "lib/rdf/vocab/#{v}.rb"}

vocab_sources.each do |id, v|
  file "lib/rdf/vocab/#{id}.rb" => :do_build do
    puts "Generate lib/rdf/vocab/#{id}.rb"
    begin
      out = StringIO.new
      loader = RDF::VocabularyLoader.new(id.to_s.upcase)
      loader.prefix = v[:prefix]
      loader.source = v[:source] if v[:source]
      loader.extra = v[:extra] if v[:extra]
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