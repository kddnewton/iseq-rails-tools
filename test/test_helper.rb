# This is to indicate that we should bypass the normal check to disable the
# railtie in test mode.
module IseqRailsTools
  def self.internal?() end
end

ENV['RAILS_ENV'] = 'test'

require File.expand_path('../../test/dummy/config/environment.rb', __FILE__)
require 'rails/test_help'

Minitest.backtrace_filter = Minitest::BacktraceFilter.new
Rails::TestUnitReporter.executable = 'bin/test'
