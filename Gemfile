source "https://rubygems.org"

gemspec :name => ""

gem "rdf-spec", :git => "git://github.com/ruby-rdf/rdf-spec.git", :branch => "develop"
gem "rdf-xsd", :git => "git://github.com/ruby-rdf/rdf-xsd.git", :branch => "develop"
gem "rdf-rdfxml", :git => "git://github.com/ruby-rdf/rdf-rdfxml.git", :branch => "develop"

group :debug do
  gem "wirble"
  gem "redcarpet", :platforms => :ruby
  gem "debugger", :platforms => :mri_19
  gem "ruby-debug", :platforms => :jruby
end

group :test do
  gem "rake"
  gem "equivalent-xml"
end
