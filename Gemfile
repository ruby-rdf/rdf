source "https://rubygems.org"

gemspec

group :develop do
  gem 'rdf-isomorphic', git: "https://github.com/ruby-rdf/rdf-isomorphic",  branch: "develop"
  gem "rdf-reasoner",   git: "https://github.com/ruby-rdf/rdf-reasoner",    branch: "develop"
  gem "rdf-spec",       git: "https://github.com/ruby-rdf/rdf-spec",        branch: "develop"
  gem "rdf-turtle",     git: "https://github.com/ruby-rdf/rdf-turtle",      branch: "develop"
  gem "rdf-vocab",      git: "https://github.com/ruby-rdf/rdf-vocab",       branch: "develop"
  gem "rdf-xsd",        git: "https://github.com/ruby-rdf/rdf-xsd",         branch: "develop"

  gem "ebnf",           git: "https://github.com/dryruby/ebnf",             branch: "develop"
  gem "sxp",            git: "https://github.com/dryruby/sxp",              branch: "develop"

  gem 'rest-client-components'
  gem 'benchmark-ips'

  # Soft dependencies
  gem 'uuid'
  gem 'uuidtools'
end

group :debug do
  gem 'psych', platforms: [:mri, :rbx]
  gem "redcarpet", platforms: :ruby
  gem "byebug", platforms: :mri
  gem 'guard-rspec'
end

group :test do
  gem "rake"
  gem "equivalent-xml"
  gem 'fasterer'
  gem 'simplecov',  platforms: :mri
  gem 'coveralls',  '~> 0.8', platforms: :mri
end
