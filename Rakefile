#!/usr/bin/env ruby
$:.unshift(File.expand_path(File.join(File.dirname(__FILE__), 'lib')))
require 'rubygems'
begin
  require 'rakefile' # @see http://github.com/bendiken/rakefile
rescue LoadError => e
end

require 'rdf'

desc "Build the rdf-#{File.read('VERSION').chomp}.gem file"
task :build do
  sh "gem build .gemspec"
end

desc "Generate etc/doap.nt from etc/doap.ttl."
task :doap do
  sh "rapper -i turtle -o ntriples etc/doap.ttl | sort > etc/doap.nt"
end
