require "test_helper"

class Admin::DashboardControllerTest < ActionDispatch::IntegrationTest
  test "redirects non-admin to root" do
    sign_in_as users(:regular)
    get admin_root_path
    assert_redirected_to root_path
  end

  test "redirects unauthenticated to login" do
    get admin_root_path
    assert_redirected_to new_session_path
  end

  test "shows dashboard for admin" do
    sign_in_as users(:admin)
    get admin_root_path
    assert_response :success
  end
end
