namespace :iseq do
  desc 'Clear compiled files'
  task clear: :environment do
    IseqRailsTools.clear_compiled_iseq_files
  end
end
