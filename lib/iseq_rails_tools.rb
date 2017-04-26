require 'digest/sha1'
require 'fileutils'

require 'iseq_rails_tools/compiler'
require 'iseq_rails_tools/railtie'

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
  end

  self.compiler = NullCompiler.new
end

RubyVM::InstructionSequence.singleton_class.prepend(Module.new do
  def load_iseq(filepath)
    if ::IseqRailsTools.compiler.watching?(filepath)
      ::IseqRailsTools.compiler.load_iseq(filepath)
    elsif method(:load_iseq).super_method
      super
    end
  end
end)
