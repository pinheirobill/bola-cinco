require "test_helper"

class UiHelperTest < ActionView::TestCase
  include UiHelper

  test "tranca_group_key_label normalizes legacy and numeric keys to letters" do
    assert_equal "A", tranca_group_key_label("1")
    assert_equal "A", tranca_group_key_label("Chave 1")
    assert_equal "B", tranca_group_key_label("2")
    assert_equal "A", tranca_group_key_label("A")
  end
end
