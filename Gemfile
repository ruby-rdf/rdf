source "https://rubygems.org"

gemspec

group :develop do
  gem "rdf-spec",       git: "git://github.com/ruby-rdf/rdf-spec.git", branch: "develop"
  gem 'linkeddata',     git: "git://github.com/ruby-rdf/linkeddata.git", branch: "develop"
  gem 'rdf-n3',         git: "git://github.com/ruby-rdf/rdf-n3.git", branch: "develop"
  gem "rdf-rdfxml",     git: "git://github.com/ruby-rdf/rdf-rdfxml.git", branch: "develop"
  gem 'rdf-rdfa',       git: "git://github.com/ruby-rdf/rdf-rdfa.git", branch: "develop"
  gem 'rdf-turtle',     git: "git://github.com/ruby-rdf/rdf-turtle.git", branch: "develop"
  gem 'rdf-microdata',  git: "git://github.com/ruby-rdf/rdf-microdata.git", branch: "develop"
  gem "rdf-xsd",        git: "git://github.com/ruby-rdf/rdf-xsd.git", branch: "develop"
  gem 'json-ld',        git: "git://github.com/ruby-rdf/json-ld.git", branch: "develop"
  gem 'sparql',         git: "git://github.com/ruby-rdf/sparql.git", branch: "develop"
  gem 'sparql-client',  git: "git://github.com/ruby-rdf/sparql-client.git", branch: "develop"
  gem 'sxp',            git: "git://github.com/gkellogg/sxp-ruby.git"
  gem 'rest-client-components'
end

group :debug do
  gem "wirble"
  gem "redcarpet", :platforms => :ruby
  gem "debugger", :platforms => :mri_19
  gem "byebug", :platforms => :mri
  gem "ruby-debug", :platforms => :jruby
  gem "pry", :platforms => :rbx
  gem 'guard-rspec'
end

group :test do
  gem "rake"
  gem "equivalent-xml"
end

platforms :rbx do
  gem 'rubysl', '~> 2.0'
  gem 'rubinius', '~> 2.0'
end
