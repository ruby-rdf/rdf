require 'rake'
require 'rake/testtask'
require 'rake/rdoctask'
require 'rake/gempackagetask'
require 'rake/contrib/rubyforgepublisher'
require 'rake/clean'

$:.unshift(File.expand_path(File.join(File.dirname(__FILE__), 'lib')))
require 'rdf/version'

Rake::TestTask.new do |t|
  t.test_files = FileList['test/test*.rb']
  t.warning = true
  t.ruby_opts = %w(-rtest/unit)
end
