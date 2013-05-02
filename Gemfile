source "https://rubygems.org"

gemspec :name => ""

gem "rdf-spec", :git => "git://github.com/ruby-rdf/rdf-spec.git", :branch => "1.1"

group :debug do
  gem "wirble"
  gem "redcarpet", :platforms => :ruby
  gem "debugger", :platforms => :mri_19
  gem "ruby-debug", :platforms => [:jruby, :mri_18]
end

group :test do
  gem "rake"
  gem "backports", :platforms => :ruby_18
  gem "equivalent-xml"
end

