require "test_helper"

class DocumentBrowsingTest < ActionDispatch::IntegrationTest
  setup do
    sign_in_as users(:regular)
  end

  test "browse documents" do
    get documents_path
    assert_response :success
    assert_select "table"
  end

  test "view a document" do
    doc = magentic_bazaar_documents(:sample_doc)
    get document_path(doc)
    assert_response :success
    assert_select "h1", doc.title
  end

  test "browse uml diagrams" do
    get uml_diagrams_path
    assert_response :success
  end

  test "view a uml diagram" do
    uml = magentic_bazaar_uml_diagrams(:sample_uml)
    get uml_diagram_path(uml)
    assert_response :success
  end

  test "browse skills" do
    get skills_path
    assert_response :success
  end

  test "view a skill" do
    skill = magentic_bazaar_skills(:sample_skill)
    get skill_path(skill)
    assert_response :success
  end
end
