module IseqRailsTools
  class Compiler
    DIRECTORY_NAME = '.iseq'

    attr_reader :application, :directory

    def initialize(application)
      @application = application
      @directory   = application.root.join(DIRECTORY_NAME).to_s
      FileUtils.mkdir_p(directory) unless File.directory?(directory)
    end

    def clear_compiled_iseq_files
      Dir.glob(File.join(directory, '**/*.yarb')) { |path| FileUtils.rm(path) }
    end

    def compile_all
      globs.each do |glob|
        Dir.glob(glob).each do |filepath|
          iseq_key = iseq_key_name(filepath)
          compile_and_store_iseq(filepath, iseq_key)
        end
      end
    end

    def iseq_key_name(filepath)
      path = filepath.gsub("#{application.root.to_s}/", '')
                     .gsub(/[^A-Za-z0-9\._-]/) { |c| '%02x' % c.ord }
      File.join(directory, "#{path}.yarb")
    end

    def load_iseq(filepath)
      iseq_key = iseq_key_name(filepath)

      if compiled_iseq_exist?(iseq_key) && compiled_iseq_is_younger?(filepath, iseq_key)
        binary = File.binread(iseq_key)
        RubyVM::InstructionSequence.load_from_binary(binary)
      else
        compile_and_store_iseq(filepath, iseq_key)
      end
    end

    def recompile_modified
      globs.each do |glob|
        Dir.glob(glob).each do |filepath|
          iseq_key = iseq_key_name(filepath)

          if !compiled_iseq_exist?(iseq_key) || !compiled_iseq_is_younger?(filepath, iseq_key)
            compile_and_store_iseq(filepath, iseq_key)
          end
        end
      end
    end

    def watching?(filepath)
      globs.any? { |glob| Dir.glob(glob).include?(filepath) }
    end

    private

    def compile_and_store_iseq(filepath, iseq_key)
      Rails.logger.debug("[IseqRailsTools] Compiling #{filepath}")
      iseq = RubyVM::InstructionSequence.compile_file(filepath)
      binary = iseq.to_binary("SHA-1:#{::Digest::SHA1.file(filepath).digest}")
      File.binwrite(iseq_key, binary)
      iseq
    rescue SyntaxError, RuntimeError => e
      puts "#{e}: #{filepath}"
      nil
    end

    def compiled_iseq_exist?(iseq_key)
      File.exist?(iseq_key)
    end

    def compiled_iseq_is_younger?(filepath, iseq_key)
      File.mtime(iseq_key) >= File.mtime(filepath)
    end

    def globs
      @globs ||=
        application.config.iseq_compile_paths.map do |directory|
          File.join(directory, '**/*.rb')
        end
    end
  end
end
