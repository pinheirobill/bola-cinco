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

    assert_response :see_other
    assert_redirected_to root_path
    assert_equal "flamengo", @user.reload.preferred_theme

    get root_path

    assert_response :success
    assert_includes response.body, 'data-theme="flamengo"'
  end

  test "every available theme persists across admin and football pages" do
    User::THEMES.each_key do |theme|
      patch theme_preference_path, params: { theme_preference: { theme: theme } }

      assert_response :see_other
      assert_equal theme, @user.reload.preferred_theme

      [root_path, football_root_path].each do |path|
        get path

        assert_response :success
        assert_select "body[data-theme=?]", theme
      end
    end
  end
end
