require "test_helper"

class UploadsControllerTest < ActionDispatch::IntegrationTest
  setup do
    sign_in_as users(:regular)
  end

  test "redirects to login when unauthenticated" do
    sign_out
    get new_upload_path
    assert_redirected_to new_session_path
  end

  test "new returns success" do
    get new_upload_path
    assert_response :success
  end

  test "create with no files redirects with alert" do
    post uploads_path
    assert_redirected_to new_upload_path
    follow_redirect!
    assert_response :success
  end
end
