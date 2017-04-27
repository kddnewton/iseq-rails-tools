module IseqRailsTools
  class Railtie < ::Rails::Railtie
    initializer 'iseq_rails_tools.initialize' do |app|
      # Yeah, sorry about this. This was the easiest way to get all access to
      # all of the reloadable paths.
      paths = app.send(:_all_autoload_paths)
      IseqRailsTools.watcher = Watcher.new(root: "#{app.root}/", paths: paths)
    end

    rake_tasks do
      rake_paths = File.expand_path(File.join('..', 'tasks', '*.rake'), __dir__)
      Dir[rake_paths].each { |filepath| load filepath }
    end
  end
end
