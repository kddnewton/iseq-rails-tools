namespace :iseq do
  desc 'Compile iseq files for all files under autoloaded paths'
  task all: :environment do
    IseqRailsTools.compile_all
  end

  desc 'Clear out all compiled iseq files'
  task clear: :environment do
    IseqRailsTools.clear_compiled_iseq_files
  end
end
