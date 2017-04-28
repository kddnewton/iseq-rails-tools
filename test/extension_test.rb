require 'test_helper'

class ExtensionTest < ActiveSupport::TestCase
  test 'works properly' do
    actual = IseqRailsTools.iseq_path_for('abc/DEF/ghi_jkl-012.foo.bar')
    assert_equal 'abc2fDEF2fghi_jkl-012.foo.bar.yarb', actual
  end
end
