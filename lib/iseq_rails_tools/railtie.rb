module IseqRailsTools
  class Railtie < ::Rails::Railtie
    config.iseq_compile_paths = []

    initializer 'iseq_rails_tools.initialize' do |app|
      # Yeah, sorry about this. This was the easiest way to get all access to
      # all of the reloadable paths.
      paths = app.send(:_all_autoload_paths)

      IseqRailsTools.watcher =
        PathsWatcher.new(root: "#{app.root}/", paths: paths)

      files = paths.flat_map { |path| Dir.glob(File.join(path, '**/*.rb')) }
      directories = paths.map { |path| [path.to_s, 'rb'] }.to_h

      reloader =
        app.config.file_watcher.new(files, directories) do
          Rails.logger.debug('[IseqRailsTools] Compiling files')
          IseqRailsTools.watcher.recompile_modified
        end

      app.reloaders.unshift(reloader)
      reloader.execute
    end

    rake_tasks do
      rake_paths = File.expand_path(File.join('..', 'tasks', '*.rake'), __dir__)
      Dir[rake_paths].each { |filepath| load filepath }
    end
  end
end
