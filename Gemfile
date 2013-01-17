source "http://rubygems.org"

gemspec :name => ""

gem "rdf-spec", :git => "git://github.com/ruby-rdf/rdf-spec.git"

group :development do
  gem "wirble"
end

group :test do
  gem "rake"
end

if RUBY_VERSION =~ /1.9/
  Encoding.default_external = Encoding::UTF_8
  Encoding.default_internal = Encoding::UTF_8
end
