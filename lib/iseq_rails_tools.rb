module IseqRailsTools
end

# Only actually hook into Rails when the environment isn't test so that tools
# like simplecov will continue to function as expected. Also people do weird
# stuff in test mode, so who knows.
if !Rails.env.test? || IseqRailsTools.respond_to?(:internal?)
  require 'iseq_rails_tools/iseq_rails_tools'
  require 'iseq_rails_tools/railtie'
  require 'iseq_rails_tools/source_file'

  module IseqRailsTools
    DIRECTORY_NAME = '.iseq'

    class << self
      attr_accessor :iseq_dir

      def clear
        Dir.glob(File.join(iseq_dir, '**/*.yarb')) { |path| File.delete(path) }
      end
    end

    root =
      caller_locations.detect do |location|
        path = location.absolute_path || location.path
        if path != __FILE__ && path !~ %r{bundler[\w.-]*/lib/bundler}
          break File.dirname(path)
        end
      end

    if !File.exist?("#{root}/config.ru") && root != File.dirname(root)
      root = File.dirname(root)
    end

    self.iseq_dir = File.join(root, DIRECTORY_NAME)
    FileUtils.mkdir_p(iseq_dir) unless File.directory?(iseq_dir)
  end

  RubyVM::InstructionSequence.singleton_class.prepend(Module.new do
    def load_iseq(filepath)
      ::IseqRailsTools::SourceFile.load(filepath)
    end
  end)
end
