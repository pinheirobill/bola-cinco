require "test_helper"

class PublicRegistrationSecurityTest < ActionDispatch::IntegrationTest
  test "public signup creates a non-admin account even with a forged administrator role" do
    post user_registration_path, params: {
      user: {
        email: "new-security-user@example.com",
        password: "valid-password-123",
        password_confirmation: "valid-password-123",
        role: "adm_master"
      }
    }

    user = User.find_by!(email: "new-security-user@example.com")
    assert_equal "jogador_do_time", user.role
    assert_not user.admin?
    assert_not user.can_manage_championship?(Championship.create!(
      source_id: "registration-security-championship",
      name: "Privado",
      season: 2026
    ))
  end
end
