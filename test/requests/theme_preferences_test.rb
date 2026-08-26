require "test_helper"

class ThemePreferencesTest < ActionDispatch::IntegrationTest
  setup do
    @user = users(:one)
    sign_in @user
  end

  test "updates and persists the preferred theme" do
    patch theme_preference_path, params: {
      theme_preference: {
        theme: "flamengo"
      }
    }

    assert_redirected_to root_path
    assert_equal "flamengo", @user.reload.preferred_theme

    get root_path

    assert_response :success
    assert_includes response.body, 'data-theme="flamengo"'
  end
end
