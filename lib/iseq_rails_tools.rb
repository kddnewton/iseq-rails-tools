require 'digest/sha1'
require 'fileutils'

require 'iseq_rails_tools/compiler'
require 'iseq_rails_tools/watched_file'

module IseqRailsTools
  class NullCompiler
    def watching?(filepath)
      false
    end
  end

  class << self
    attr_accessor :compiler
  end
  self.compiler = NullCompiler.new
end

# Only actually hook into Rails when the environment isn't test so that tools
# like simplecov will continue to function as expected. Also people do weird
# stuff in test mode, so who knows.
if !Rails.env.test? || IseqRailsTools.respond_to?(:internal?)
  require 'iseq_rails_tools/railtie'

  RubyVM::InstructionSequence.singleton_class.prepend(Module.new do
    def load_iseq(filepath)
      if ::IseqRailsTools.compiler.watching?(filepath)
        ::IseqRailsTools.compiler.load(filepath)
      elsif method(:load_iseq).super_method
        super
      end
    end
  end)
end
