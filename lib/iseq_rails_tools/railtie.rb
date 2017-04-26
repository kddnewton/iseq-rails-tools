module IseqRailsTools
  class Railtie < ::Rails::Railtie
    config.iseq_compile_paths = []

    initializer 'iseq_rails_tools.initialize' do |app|
      IseqRailsTools.compiler = Compiler.new(app)

      # Yeah, sorry about this. This was the easiest way to get all access to
      # all of the reloadable paths.
      app.config.iseq_compile_paths = app.send(:_all_autoload_paths)

      files =
        app.config.iseq_compile_paths.flat_map do |path|
          Dir.glob(File.join(path, '**/*.rb'))
        end

      directories =
        app.config.iseq_compile_paths.map { |path| [path, 'rb'] }.to_h

      reloader =
        app.config.file_watcher.new(files, directories) do
          Rails.logger.debug('[IseqRailsTools] Compiling files')
          IseqRailsTools.compiler.recompile_modified
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
