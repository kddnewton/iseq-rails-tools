require 'test_helper'
load File.expand_path('../lib/tasks/iseq_rails_tools_tasks.rake', __dir__)

class IseqRailsTools::Test < ActionDispatch::IntegrationTest
  # Going with this for now because dealing with writing to the foo.rb file in
  # the tests causes all kinds of problems with reloading.
  i_suck_and_my_tests_are_order_dependent!

  DIRECTORY = Rails.root.join(IseqRailsTools::DIRECTORY_NAME)

  teardown do
    Dir.glob(DIRECTORY.join('*')).each { |filepath| File.delete(filepath) }
  end

  test 'generates compiled versions for autoloaded files' do
    get root_path
    assert_equal '0', response.body

    expected_filepaths = %w{
      app2fcontrollers2fapplication_controller.rb.yarb
      app2fcontrollers2ffoos_controller.rb.yarb
      app2fmodels2ffoo.rb.yarb
    }

    actual_filepaths =
      compiled_iseq_files.map { |filepath| File.basename(filepath) }

    assert_equal expected_filepaths.sort, actual_filepaths
  end

  test 'recompiles the foo.rb file when it changes' do
    get root_path
    assert_equal '0', response.body

    with_modified_foo do
      get root_path
      assert_equal '1', response.body
    end
  end

  test 'the iseq:clear task clears out the compiled files' do
    get root_path

    Rake::Task['iseq:clear'].execute
    assert_empty compiled_iseq_files
  end

  private

  def compiled_iseq_files
    Dir.glob(DIRECTORY.join('*')).sort
  end

  def with_modified_foo
    filepath = Rails.root.join('app', 'models', 'foo.rb').to_s
    content  = File.read(filepath)

    File.write(filepath, content.gsub('0', '1'))
    yield
  ensure
    File.write(filepath, content)
  end
end
