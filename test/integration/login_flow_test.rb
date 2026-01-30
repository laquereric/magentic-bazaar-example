require "test_helper"

class LoginFlowTest < ActionDispatch::IntegrationTest
  test "login with valid credentials" do
    get new_session_path
    assert_response :success

    post session_path, params: {
      email_address: "admin@example.com",
      password: "password"
    }
    assert_redirected_to root_path
    follow_redirect!
    assert_response :success
  end

  test "login with invalid credentials" do
    post session_path, params: {
      email_address: "admin@example.com",
      password: "wrong"
    }
    assert_redirected_to new_session_path
  end

  test "signup flow" do
    get new_registration_path
    assert_response :success

    post registration_path, params: {
      user: {
        name: "Test",
        email_address: "test@example.com",
        password: "password123",
        password_confirmation: "password123"
      }
    }
    assert_redirected_to root_path
    follow_redirect!
    assert_response :success
  end

  test "logout flow" do
    sign_in_as users(:admin)
    delete session_path
    assert_redirected_to new_session_path
  end
end
