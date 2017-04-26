require 'test_helper'
load File.expand_path('../lib/tasks/iseq_rails_tools_tasks.rake', __dir__)

class IseqRailsTools::Test < ActionDispatch::IntegrationTest
  DIRECTORY = Rails.root.join(IseqRailsTools::Compiler::DIRECTORY_NAME)

  teardown do
    Dir.glob(DIRECTORY.join('*')).each { |filepath| File.unlink(filepath) }
  end

  test 'generates compiled versions for autoloaded files' do
    get root_path
    assert_equal '0', response.body

    expected_filepaths = %w{
      app/controllers/application_controller.rb
      app/controllers/foos_controller.rb
      app/models/foo.rb
    }.map { |filepath| IseqRailsTools.compiler.iseq_key_name(Rails.root.join(filepath).to_s) }

    assert_equal expected_filepaths.sort, compiled_iseq_files
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
    File.write(filepath, File.read(filepath).gsub('0', '1'))
    yield
  ensure
    File.write(filepath, File.read(filepath).gsub('1', '0'))
  end
end
