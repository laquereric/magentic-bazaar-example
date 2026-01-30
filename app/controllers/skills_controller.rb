class SkillsController < ApplicationController
  def index
    scope = MagenticBazaar::Skill.includes(:document).order(created_at: :desc)
    scope = scope.where(category: params[:category]) if params[:category].present?
    scope = scope.where(uml_type: params[:uml_type]) if params[:uml_type].present?

    @categories = MagenticBazaar::Skill.distinct.pluck(:category).compact
    @uml_types = MagenticBazaar::Skill.distinct.pluck(:uml_type).compact
    @pagy, @skills = pagy(:offset, scope, limit: 12)
  end

  def show
    @skill = MagenticBazaar::Skill.find(params[:id])
    @document = @skill.document
  end
end
