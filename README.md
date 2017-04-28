# IseqRailsTools

[![Build Status](https://travis-ci.org/kddeisz/iseq-rails-tools.svg?branch=master)](https://travis-ci.org/kddeisz/iseq-rails-tools)
[![Gem](https://img.shields.io/gem/v/iseq_rails_tools.svg)](https://rubygems.org/gems/iseq_rails_tools)

Since Ruby 2.3, we've had the ability to dump out compiled Ruby bytecode to files to alleviate that process when ruby files are required. This can significantly boost boot times, especially when running with larger Ruby projects. With this gem in your `Gemfile`, your app can boot up to about 30% faster.

When deploying to production, you can take advantage of the quicker boot times by adding the `iseq:all` rake task to your deploy script. A simple way to do this is to make `iseq:all` a prerequisite of `assets:precompile`, like so: `Rake::Task['assets:precompile'].enhance(['iseq:all'])`.

## Usage

1. Add `iseq_rails_tools` to your `Gemfile`.
2. Run `bundle install` to download the gem.
3. Add `.iseq/` to your `.gitignore`.

Then when running the console or the server, the compiled files will start to be generated in a new `.iseq` directory in the root of the repository.

## Tasks

`IseqRailsTools` adds a couple `Rake` tasks to your Rails project:

1. `iseq:all` - Compile iseq files for all files under autoloaded paths
2. `iseq:clear` - Clear out all compiled iseq files

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/kddeisz/iseq-rails-tools.

## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).

## Credit

A lot of the inspiration (as well as some of the code) for this gem came from Koichi Sasada's great work on the [yomikomu](https://github.com/ko1/yomikomu) gem.
