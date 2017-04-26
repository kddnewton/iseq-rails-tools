namespace :iseq do
  desc 'Clear compiled files'
  task :clear do
    IseqRailsTools.clear_iseq_files
  end
end
