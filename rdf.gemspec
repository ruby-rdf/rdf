#!/usr/bin/env ruby -rubygems
# -*- encoding: utf-8 -*-

Gem::Specification.new do |gem|
  gem.version            = File.read('VERSION').chomp
  gem.date               = File.mtime('VERSION').strftime('%Y-%m-%d')

  gem.name               = 'rdf'
  gem.homepage           = 'https://github.com/ruby-rdf/rdf'
  gem.license            = 'Unlicense'
  gem.summary            = 'A Ruby library for working with Resource Description Framework (RDF) data.'
  gem.description        = 'RDF.rb is a pure-Ruby library for working with Resource Description Framework (RDF) data.'
  gem.metadata           = {
    "documentation_uri" => "https://ruby-rdf.github.io/rdf",
    "bug_tracker_uri"   => "https://github.com/ruby-rdf/rdf/issues",
    "homepage_uri"      => "https://github.com/ruby-rdf/rdf",
    "mailing_list_uri"  => "https://lists.w3.org/Archives/Public/public-rdf-ruby/",
    "source_code_uri"   => "https://github.com/ruby-rdf/rdf",
  }

  gem.authors            = ['Arto Bendiken', 'Ben Lavender', 'Gregg Kellogg']
  gem.email              = 'public-rdf-ruby@w3.org'

  gem.platform           = Gem::Platform::RUBY
  gem.files              = %w(AUTHORS CREDITS README.md UNLICENSE VERSION bin/rdf etc/doap.nt) + Dir.glob('lib/**/*.rb')
  gem.bindir             = %q(bin)
  gem.executables        = %w(rdf)
  gem.require_paths      = %w(lib)

  gem.required_ruby_version      = '>= 2.6'
  gem.requirements               = []
  gem.add_runtime_dependency     'link_header', '~> 0.0', '>= 0.0.8'
  gem.add_development_dependency 'rdf-spec',    '~> 3.2', '< 3.3'
  gem.add_development_dependency 'rdf-turtle',  '~> 3.2', '< 3.3'
  gem.add_development_dependency 'rdf-vocab',   '~> 3.2', '< 3.3'
  gem.add_development_dependency 'rdf-xsd',     '~> 3.2', '>= 3.2.1', '< 3.3'
  gem.add_development_dependency 'rest-client', '~> 2.1'
  gem.add_development_dependency 'rspec',       '~> 3.12'
  gem.add_development_dependency 'rspec-its',   '~> 1.3'
  gem.add_development_dependency 'webmock',     '~> 3.18'
  gem.add_development_dependency 'yard',        '~> 0.9'
  gem.add_development_dependency 'faraday',     '~> 1.10'
  gem.add_development_dependency 'faraday_middleware', '~> 1.2'

  gem.post_install_message       = nil
end
