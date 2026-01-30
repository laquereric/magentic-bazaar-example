require "test_helper"

class Admin::IngestionsControllerTest < ActionDispatch::IntegrationTest
  setup do
    sign_in_as users(:admin)
  end

  test "redirects non-admin" do
    sign_in_as users(:regular)
    get admin_ingestions_path
    assert_redirected_to root_path
  end

  test "index returns success" do
    get admin_ingestions_path
    assert_response :success
  end

  test "show returns success" do
    ingestion = magentic_bazaar_ingestions(:completed_ingestion)
    get admin_ingestion_path(ingestion)
    assert_response :success
  end

  test "create queues ingestion job" do
    assert_enqueued_with(job: MagenticBazaar::IngestJob) do
      post admin_ingestions_path
    end
    assert_redirected_to admin_ingestions_path
  end
end
