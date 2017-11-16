source "https://rubygems.org"

gemspec

group :develop do
  gem 'rdf-isomorphic', git: "https://github.com/ruby-rdf/rdf-isomorphic",  branch: "develop"
  gem "rdf-reasoner",   git: "https://github.com/ruby-rdf/rdf-reasoner",    branch: "develop"
  gem "rdf-spec",       git: "https://github.com/ruby-rdf/rdf-spec",        branch: "feature/3.0-dev"
  gem "rdf-turtle",     git: "https://github.com/ruby-rdf/rdf-turtle",      branch: "develop"
  gem "rdf-vocab",      git: "https://github.com/ruby-rdf/rdf-vocab",       branch: "develop"
  gem "rdf-xsd",        git: "https://github.com/ruby-rdf/rdf-xsd",         branch: "develop"

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
  gem 'rubinius-debugger', platform: :rbx
  gem 'ruby-debug', platform: :jruby
  gem 'guard-rspec'
end

group :test do
  gem "rake"
  gem "equivalent-xml"
  gem 'fasterer'
  gem 'simplecov',  require: false, platform: :mri
  gem 'coveralls',  require: false, platform: :mri
end

platforms :rbx do
  gem 'rubysl', '~> 2.0'
  gem 'rubinius', '~> 2.0'
end
