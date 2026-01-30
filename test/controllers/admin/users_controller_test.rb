require "test_helper"

class Admin::UsersControllerTest < ActionDispatch::IntegrationTest
  setup do
    sign_in_as users(:admin)
  end

  test "redirects non-admin" do
    sign_in_as users(:regular)
    get admin_users_path
    assert_redirected_to root_path
  end

  test "index returns success" do
    get admin_users_path
    assert_response :success
  end

  test "update toggles admin status" do
    user = users(:regular)
    assert_not user.admin?

    patch admin_user_path(user), params: { user: { admin: true } }
    assert_redirected_to admin_users_path
    assert user.reload.admin?
  end
end
