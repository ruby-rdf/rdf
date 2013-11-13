source "https://rubygems.org"

gemspec :name => ""

gem "rdf-spec", :git => "git://github.com/ruby-rdf/rdf-spec.git", :branch => "develop"

group :develop do
  gem 'linkeddata'
  gem "rdf-rdfxml", :git => "git://github.com/ruby-rdf/rdf-rdfxml.git", :branch => "develop"
  gem 'rdf-rdfa', :git => "git://github.com/ruby-rdf/rdf-rdfa.git", :branch => "develop"
  gem 'rdf-turtle', :git => "git://github.com/ruby-rdf/rdf-turtle.git", :branch => "develop"
  gem 'rdf-microdata', :git => "git://github.com/ruby-rdf/rdf-microdata.git", :branch => "develop"
  gem "rdf-xsd", :git => "git://github.com/ruby-rdf/rdf-xsd.git", :branch => "develop"
end

group :debug do
  gem "wirble"
  gem "redcarpet", :platforms => :ruby
  gem "debugger", :platforms => [:mri_19, :mri_20]
  gem "ruby-debug", :platforms => :jruby
end

group :test do
  gem "rake"
  gem "equivalent-xml"
end
