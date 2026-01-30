require "test_helper"

class RegistrationsControllerTest < ActionDispatch::IntegrationTest
  test "new returns success" do
    get new_registration_path
    assert_response :success
  end

  test "create with valid params creates user and signs in" do
    assert_difference "User.count", 1 do
      post registration_path, params: {
        user: {
          name: "New User",
          email_address: "new@example.com",
          password: "password123",
          password_confirmation: "password123"
        }
      }
    end
    assert_redirected_to root_path
  end

  test "create with invalid params re-renders form" do
    assert_no_difference "User.count" do
      post registration_path, params: {
        user: {
          name: "New User",
          email_address: "",
          password: "password123",
          password_confirmation: "password123"
        }
      }
    end
    assert_response :unprocessable_entity
  end
end
