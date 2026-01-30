require "test_helper"

class SkillsControllerTest < ActionDispatch::IntegrationTest
  setup do
    sign_in_as users(:regular)
  end

  test "redirects to login when unauthenticated" do
    sign_out
    get skills_path
    assert_redirected_to new_session_path
  end

  test "index returns success" do
    get skills_path
    assert_response :success
  end

  test "index with category filter" do
    get skills_path, params: { category: "Documentation Analysis" }
    assert_response :success
  end

  test "show returns success" do
    skill = magentic_bazaar_skills(:sample_skill)
    get skill_path(skill)
    assert_response :success
  end
end
