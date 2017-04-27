require 'digest/sha1'

module IseqRailsTools
  class SourceFile
    attr_reader :source_path, :iseq_path

    def initialize(source_path, iseq_path)
      @source_path = source_path
      @iseq_path   = iseq_path
    end

    def dump
      # Lonely operator necessary here because Rails.logger might not be
      # initialized yet
      Rails.logger&.debug("[IseqRailsTools] Compiling #{source_path}")

      iseq   = RubyVM::InstructionSequence.compile_file(source_path)
      digest = ::Digest::SHA1.file(source_path).digest
      File.binwrite(iseq_path, iseq.to_binary("SHA-1:#{digest}"))
      iseq
    rescue SyntaxError, RuntimeError
      Rails.logger.debug("[IseqRailsTools] Failed to compile #{source_path}")
      nil
    end

    def load
      if compiled? && !needs_recompile?
        binary = File.binread(iseq_path)
        RubyVM::InstructionSequence.load_from_binary(binary)
      else
        dump
      end
    end

    def self.load(source_path)
      iseq_path = source_path.gsub(/[^A-Za-z0-9\._-]/) { |c| '%02x' % c.ord }
      iseq_path = File.join(IseqRailsTools.iseq_dir, "#{iseq_path}.yarb")
      new(source_path, iseq_path).load
    end

    private

    def compiled?
      File.exist?(iseq_path)
    end

    def needs_recompile?
      File.mtime(source_path) > File.mtime(iseq_path)
    end
  end
end
