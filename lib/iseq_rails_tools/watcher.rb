module IseqRailsTools
  DIRECTORY_NAME = '.iseq'

  class NullWatcher
    def watching?(filepath)
      false
    end
  end

  class PathsWatcher
    attr_reader :dir, :paths, :root

    def initialize(paths:, root:)
      @paths = paths
      @root  = root
      @dir   = File.join(root, DIRECTORY_NAME)
      FileUtils.mkdir_p(@dir) unless File.directory?(@dir)
    end

    def clear
      Dir.glob(File.join(dir, '**/*.yarb')) { |path| File.delete(path) }
    end

    def dump_all
      each_watched do |filepath|
        watched_file_from(filepath).dump
      end
    end

    def load(filepath)
      watched_file_from(filepath).load
    end

    def recompile_modified
      each_watched do |filepath|
        watched_file_from(filepath).load
      end
    end

    def watching?(filepath)
      each_watched.detect { |watched| watched == filepath }
    end

    private

    def each_watched
      return to_enum(:each_watched) unless block_given?
      paths.each do |path|
        Dir.glob(File.join(path, '**/*.rb')).each do |watched|
          yield watched
        end
      end
    end

    def watched_file_from(filepath)
      WatchedFile.build(root, filepath, dir)
    end
  end
end
