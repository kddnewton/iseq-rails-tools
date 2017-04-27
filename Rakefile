require 'bundler/gem_tasks'
require 'rake/extensiontask'
require 'rake/testtask'

Rake::ExtensionTask.new('iseq_rails_tools') do |ext|
  ext.lib_dir = File.join('lib', 'iseq_rails_tools')
end

Rake::TestTask.new(:test) do |t|
  t.libs << 'test'
  t.libs << 'lib'
  t.test_files = FileList['test/**/*_test.rb']
  t.verbose = false
end

Rake::Task[:test].prerequisites << :compile

task default: :test
