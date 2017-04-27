namespace :iseq do
  desc 'Compile iseq files for all files under autoloaded paths'
  task all: :environment do
    Rails.application.eager_load!
  end

  desc 'Clear out all compiled iseq files'
  task clear: :environment do
    IseqRailsTools.watcher.clear
  end
end
