source "https://rubygems.org"

gemspec

group :develop do
  gem "rdf-reasoner",   git: "git://github.com/ruby-rdf/rdf-reasoner.git", branch: "develop"
  gem "rdf-spec",       git: "git://github.com/ruby-rdf/rdf-spec.git", branch: "develop"
  gem "rdf-vocab",      git: "git://github.com/ruby-rdf/rdf-vocab.git", branch: "develop"
  gem "rdf-xsd",        git: "git://github.com/ruby-rdf/rdf-xsd.git", branch: "develop"
  gem 'rdf-isomorphic', git: "git://github.com/ruby-rdf/rdf-isomorphic.git", branch: "develop"
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
