require_relative 'boot'

require 'active_model/railtie'
require 'active_record/railtie'
require 'action_controller/railtie'
require 'rails/test_unit/railtie'

Bundler.require(*Rails.groups)
require 'iseq_rails_tools'

module Dummy
  class Application < Rails::Application
  end
end
