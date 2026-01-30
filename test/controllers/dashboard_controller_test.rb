require "test_helper"

class DashboardControllerTest < ActionDispatch::IntegrationTest
  test "redirects to login when unauthenticated" do
    get root_path
    assert_redirected_to new_session_path
  end

  test "shows dashboard when authenticated" do
    sign_in_as users(:regular)
    get root_path
    assert_response :success
  end
end
