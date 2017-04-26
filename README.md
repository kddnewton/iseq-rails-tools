# IseqRailsTools

Since Ruby 2.3, we've had the ability to dump out compiled Ruby bytecode to files to alleviate that process when ruby files are required. This can significantly boost boot times, especially when running with larger Ruby projects.

This gem hooks into ActiveSupport's autoloading in development mode to bring AOT compiling to Rails. This can improve both the console and server boot times.

## Usage

1. Add `iseq_rails_tools` to your `Gemfile`.
2. Run `bundle install` to download the gem.
3. Add `.iseq/` to your `.gitignore`.

Then when running the console or the server, the compiled files will start to be generated in a new `.iseq` directory in the root of the repository.

## Tasks

IseqRailsTools adds a couple `Rake` tasks to your Rails project:

1. iseq:all - will generate compiled iseq files for all autoloaded paths.
2. iseq:clear - will clear out all compiled iseq files.

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/kddeisz/iseq-rails-tools.

## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).

## Credit

A lot of the inspiration (as well as some of the code) for this gem came from Koichi Sasada's great work on the [yomikomu](https://github.com/ko1/yomikomu) gem.
