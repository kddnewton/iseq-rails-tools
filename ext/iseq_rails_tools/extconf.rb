begin
  require 'mkmf'
  create_makefile 'iseq_rails_tools/iseq_rails_tools'
rescue StandardError => error
  File.open('Makefile', 'wb') do |file|
    file.puts '.PHONY: install'
    file.puts 'install:'
    file.puts "\t" + '@echo "[iseq_rails_tools] not installed, falling back to pure Ruby version."'
  end
end
