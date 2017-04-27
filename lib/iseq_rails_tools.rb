# Only actually hook into Rails when the environment isn't test so that tools
# like simplecov will continue to function as expected. Also people do weird
# stuff in test mode, so who knows.
if !Rails.env.test? || IseqRailsTools.respond_to?(:internal?)
  module IseqRailsTools
    class << self
      attr_accessor :watcher
    end
  end

  require 'iseq_rails_tools/railtie'
  require 'iseq_rails_tools/watcher'
  require 'iseq_rails_tools/watched_file'

  RubyVM::InstructionSequence.singleton_class.prepend(Module.new do
    def load_iseq(filepath)
      ::IseqRailsTools.watcher&.load(filepath)
    end
  end)
end
