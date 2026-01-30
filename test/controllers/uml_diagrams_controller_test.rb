require "test_helper"

class UmlDiagramsControllerTest < ActionDispatch::IntegrationTest
  setup do
    sign_in_as users(:regular)
  end

  test "redirects to login when unauthenticated" do
    sign_out
    get uml_diagrams_path
    assert_redirected_to new_session_path
  end

  test "index returns success" do
    get uml_diagrams_path
    assert_response :success
  end

  test "index with type filter" do
    get uml_diagrams_path, params: { type: "class" }
    assert_response :success
  end

  test "show returns success" do
    uml = magentic_bazaar_uml_diagrams(:sample_uml)
    get uml_diagram_path(uml)
    assert_response :success
  end
end
