require 'digest/sha1'
require 'fileutils'
require 'iseq_rails_tools/compiler'

module IseqRailsTools
  class NullCompiler
    def clear_compiled_iseq_files
    end

    def watching?(filepath)
      false
    end
  end

  class << self
    attr_accessor :compiler

    def clear_compiled_iseq_files
      compiler.clear_compiled_iseq_files
    end

    def compile_all
      compiler.compile_all
    end
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
        ::IseqRailsTools.compiler.load_iseq(filepath)
      elsif method(:load_iseq).super_method
        super
      end
    end
  end)
end
