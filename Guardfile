guard 'rspec', :all_after_pass => true, :all_on_start => true do
  watch(%r{^spec/.+_spec\.rb$})
  watch(%r{^lib/(.+)\.rb$})     { |m| "spec/lib/#{m[1]}/" }
  watch('spec/spec_helper.rb')  { "spec" }
  watch('lib/rdf.rb')           { "spec" }
end
