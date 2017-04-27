require 'fileutils'

module IseqRailsTools
  DIRECTORY_NAME = '.iseq'

  class Watcher
    attr_reader :root, :watched, :iseq_dir

    def initialize(paths:, root:)
      @root     = root
      @watched  = watched_from(paths)
      @iseq_dir = File.join(root, DIRECTORY_NAME)
      FileUtils.mkdir_p(@iseq_dir) unless File.directory?(@iseq_dir)
    end

    def clear
      Dir.glob(File.join(iseq_dir, '**/*.yarb')) { |path| File.delete(path) }
    end

    def dump_all
      watched.each do |filepath|
        watched_file_from(filepath).dump
      end
    end

    def load(filepath)
      watched_file_from(filepath).load if watching?(filepath)
    end

    private

    def watched_file_from(source_path)
      iseq_path = source_path.gsub(root, '')
                             .gsub(/[^A-Za-z0-9\._-]/) { |c| '%02x' % c.ord }
      iseq_path = File.join(iseq_dir, "#{iseq_path}.yarb")
      WatchedFile.new(source_path, iseq_path)
    end

    def watched_from(paths)
      paths.flat_map { |path| Dir.glob(File.join(path, '**', '*.rb')) }
    end

    def watching?(filepath)
      watched.include?(filepath)
    end
  end
end
