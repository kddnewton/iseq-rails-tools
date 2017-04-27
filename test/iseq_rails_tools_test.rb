require 'test_helper'

class IseqRailsTools::Test < ActionDispatch::IntegrationTest
  EXPECTED = %w{
    app2fcontrollers2fapplication_controller.rb.yarb
    app2fcontrollers2ffoos_controller.rb.yarb
    app2fmodels2ffoo.rb.yarb
  }

  teardown { IseqRailsTools.clear }

  test 'generates compiled versions for autoloaded files' do
    get root_path
    assert_equal '0', response.body

    EXPECTED.each do |expected|
      refute_nil compiled_files.detect { |compiled_file| compiled_file.include?(expected) }
    end
  end

  test 'recompiles the foo.rb file when it changes' do
    get root_path
    assert_equal '0', response.body

    # Why? Why do we need sleep here? I'm not entirely sure, but I think it has
    # to do with waiting for Rails to unload the Foo class. Definitely something
    # weird going on here.
    sleep 1

    filepath = Rails.root.join('app', 'models', 'foo.rb').to_s
    content  = File.read(filepath)
    File.write(filepath, content.gsub('0', '1'))

    sleep 1

    begin
      get root_path
      assert_equal '1', response.body
    ensure
      File.write(filepath, content)
    end
  end

  private

  def compiled_files
    glob = Rails.root.join(IseqRailsTools::DIRECTORY_NAME, '*')
    Dir.glob(glob).sort.map { |filepath| File.basename(filepath) }
  end
end
