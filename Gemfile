source "https://rubygems.org"

gemspec

group :develop do
  gem 'rdf-isomorphic', github: "ruby-rdf/rdf-isomorphic",  branch: "develop"
  gem "rdf-reasoner",   github: "ruby-rdf/rdf-reasoner",    branch: "develop"
  gem "rdf-spec",       github: "ruby-rdf/rdf-spec",        branch: "develop"
  gem "rdf-vocab",      github: "ruby-rdf/rdf-vocab",       branch: "develop"
  gem "rdf-xsd",        github: "ruby-rdf/rdf-xsd",         branch: "develop"

  gem 'rest-client-components'
  gem 'benchmark-ips'
end

group :debug do
  gem 'psych', platforms: [:mri, :rbx]
  gem "wirble"
  gem "redcarpet", platforms: :ruby
  gem "byebug", platforms: :mri
  gem 'guard-rspec'
end

group :test do
  gem "rake"
  gem "equivalent-xml"
  gem 'fasterer'
  gem 'simplecov',  require: false, platform: :mri
  gem 'coveralls',  require: false, platform: :mri
  gem "codeclimate-test-reporter", require: false
end

platforms :rbx do
  gem 'rubysl', '~> 2.0'
  gem 'rubinius', '~> 2.0'
end
