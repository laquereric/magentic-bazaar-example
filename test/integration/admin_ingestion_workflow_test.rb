require "test_helper"

class AdminIngestionWorkflowTest < ActionDispatch::IntegrationTest
  setup do
    sign_in_as users(:admin)
  end

  test "admin can view ingestions" do
    get admin_ingestions_path
    assert_response :success
  end

  test "admin can trigger ingestion" do
    assert_enqueued_with(job: MagenticBazaar::IngestJob) do
      post admin_ingestions_path
    end
    assert_redirected_to admin_ingestions_path
  end

  test "admin can view ingestion details" do
    ingestion = magentic_bazaar_ingestions(:completed_ingestion)
    get admin_ingestion_path(ingestion)
    assert_response :success
  end

  test "admin can trigger undo" do
    ingestion = magentic_bazaar_ingestions(:completed_ingestion)
    assert_enqueued_with(job: MagenticBazaar::IngestJob) do
      post undo_admin_ingestion_path(ingestion)
    end
    assert_redirected_to admin_ingestion_path(ingestion)
  end

  test "regular user cannot access admin ingestions" do
    sign_in_as users(:regular)
    get admin_ingestions_path
    assert_redirected_to root_path
  end
end
