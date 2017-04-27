$:.push File.expand_path('../lib', __FILE__)
require 'iseq_rails_tools/version'

Gem::Specification.new do |s|
  s.name        = 'iseq_rails_tools'
  s.version     = IseqRailsTools::VERSION
  s.authors     = ['Kevin Deisz']
  s.email       = ['kevin.deisz@gmail.com']

  s.homepage    = 'https://github.com/kddeisz/iseq-rails-tools'
  s.summary     = 'Use AOT compilation within Rails'
  s.description = <<-DESC
    Allows you to take advantage of ruby's AOT bytecode generation
    within a Rails project.
  DESC

  s.license     = 'MIT'
  s.files = Dir['{app,config,db,lib}/**/*', 'MIT-LICENSE', 'Rakefile', 'README.md']

  s.required_ruby_version = '>= 2.3.0'
  s.add_dependency 'rails', '>= 5.0.0'
  s.add_development_dependency 'rake-compiler', '~> 0.9'
end
