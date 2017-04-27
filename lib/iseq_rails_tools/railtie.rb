module IseqRailsTools
  class Railtie < ::Rails::Railtie
    rake_tasks do
      rake_paths = File.expand_path(File.join('..', 'tasks', '*.rake'), __dir__)
      Dir[rake_paths].each { |filepath| load filepath }
    end
  end
end
