# Rakefile for RDF.rb      -*- ruby -*-
# Copyright (c) 2006-2007 Arto Bendiken <http://bendiken.net/>

require 'rake'
require 'rake/testtask'
require 'rake/rdoctask'
require 'rake/gempackagetask'
require 'rake/contrib/rubyforgepublisher'
require 'rake/clean'

PKG_NAME      = "rdfrb"
PKG_LIBS      = ["rdf"]
PKG_VERSION   = File.read('VERSION').chomp
PKG_SUMMARY   = ""
PKG_URL       = "http://rdfrb.org/"
PKG_BUILD     = ENV['PKG_BUILD'] ? '.' + ENV['PKG_BUILD'] : ''
PKG_FILE_NAME = "#{PKG_NAME}-#{PKG_VERSION}"
PKG_FILES = FileList[
  'Rakefile', '[A-Z]*', 'bin/**/*', 'lib/**/*.rb', 'test/**/*.rb'
  #'doc/**/*',
  #'html/**/*',
]

PKG_AUTHOR    = "Arto Bendiken"
PKG_EMAIL     = "arto.bendiken@gmail.com"
PKG_HOMEPAGE  = "http://bendiken.net/"

##############################################################################

Rake::TestTask.new do |t|
  t.test_files = FileList['test/test*.rb']
  t.warning = true
  t.ruby_opts = %w(-rtest/unit)
end

##############################################################################

rdoc = Rake::RDocTask.new('rdoc') do |rdoc|
  rdoc.rdoc_dir = 'doc'
  rdoc.title = "RDF.rb -- Resource Description Framework for Ruby"
  rdoc.options << '--line-numbers' << '--inline-source' << '--main' << 'README'
  rdoc.rdoc_files.include('README', 'LICENSE')
  rdoc.rdoc_files.include('lib/**/*.rb', 'doc/**/*.rdoc')
end

##############################################################################

spec = Gem::Specification.new do |s|
  s.name = PKG_NAME
  s.version = PKG_VERSION
  s.summary = PKG_SUMMARY
  s.description = ''

  #s.add_dependency('rake', '> 0.7.2')
  #s.requirements << ""

  s.files = PKG_FILES.to_a.reject { |f| f.include?('.svn') }

  s.require_path = 'lib'

  s.bindir = 'bin'
  s.executables = []
  #s.default_executable = ''

  s.has_rdoc = true
  s.extra_rdoc_files = rdoc.rdoc_files.to_a.reject { |f| f =~ /\.rb$/ }
  s.rdoc_options = rdoc.options

  s.author = PKG_AUTHOR
  s.email = PKG_EMAIL
  s.homepage = PKG_HOMEPAGE
  s.rubyforge_project = PKG_NAME
end

pkg = Rake::GemPackageTask.new(spec) do |pkg|
  pkg.need_tar = true
  pkg.need_zip = true
end

##############################################################################

desc "Update the VERSION file."
task :version do
  $:.unshift(File.expand_path(File.join(File.dirname(__FILE__), 'lib')))
  require "#{PKG_LIBS.first}/version"
  File.open('VERSION', 'w') { |f| f.puts RDF::VERSION::STRING }
end

desc "Look for TODO and FIXME tags in the code base."
task :todo do
  FileList['**/*.rb'].exclude('pkg').egrep(/#.*(FIXME|TODO)/)
end

ARCHIVE_DIR = "/tmp"
desc "Copy package products to archive directory #{ARCHIVE_DIR}."
task :archive => [:package] do
  cp FileList['pkg/*.tgz', 'pkg/*.zip', 'pkg/*.gem'], ARCHIVE_DIR
end

desc "Convert test data from RDF/XML into other formats (using Rapper)."
task :data do
  `rapper -i rdfxml -o ntriples test/data/rdfrb.rdf > test/data/rdfrb.nt`
end
