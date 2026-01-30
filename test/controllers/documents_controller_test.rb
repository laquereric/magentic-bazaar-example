require "test_helper"

class DocumentsControllerTest < ActionDispatch::IntegrationTest
  setup do
    sign_in_as users(:regular)
  end

  test "redirects to login when unauthenticated" do
    sign_out
    get documents_path
    assert_redirected_to new_session_path
  end

  test "index returns success" do
    get documents_path
    assert_response :success
  end

  test "index with search query" do
    get documents_path, params: { q: "Sample" }
    assert_response :success
  end

  test "index with file type filter" do
    get documents_path, params: { file_type: "Markdown" }
    assert_response :success
  end

  test "index with HTML file type filter" do
    get documents_path, params: { file_type: "HTML" }
    assert_response :success
  end

  test "show returns success" do
    doc = magentic_bazaar_documents(:sample_doc)
    get document_path(doc)
    assert_response :success
  end
end
