require "test_helper"

class Admin::SystemStatusesControllerTest < ActionDispatch::IntegrationTest
  setup do
    sign_in_as users(:admin)
  end

  test "redirects non-admin" do
    sign_in_as users(:regular)
    get admin_system_status_path
    assert_redirected_to root_path
  end

  test "show returns success" do
    get admin_system_status_path
    assert_response :success
  end
end
