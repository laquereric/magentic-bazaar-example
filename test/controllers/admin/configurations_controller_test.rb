require "test_helper"

class Admin::ConfigurationsControllerTest < ActionDispatch::IntegrationTest
  setup do
    sign_in_as users(:admin)
  end

  test "redirects non-admin" do
    sign_in_as users(:regular)
    get admin_configuration_path
    assert_redirected_to root_path
  end

  test "show returns success" do
    get admin_configuration_path
    assert_response :success
  end

  test "update changes in-memory config" do
    patch admin_configuration_path, params: {
      configuration: { queue_name: "custom_queue" }
    }
    assert_redirected_to admin_configuration_path
    assert_equal :custom_queue, MagenticBazaar.configuration.queue_name
  end
end
