class SkillsController < ApplicationController
  layout "inertia", only: [:show]

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

    mdx_path = find_mdx_file(
      MagenticBazaar.configuration.skills_dir,
      @document&.uuid7
    )

    props = {
      skill: serialize_skill(@skill),
      document: @document ? serialize_document(@document) : nil
    }

    compiler = RailsInertiaMdx::Compiler.new
    if mdx_path
      compiled = compiler.compile_file(mdx_path)
      props[:mdx] = compiled.to_inertia_props[:mdx]
    elsif @skill.content.present?
      compiled = compiler.compile(@skill.content)
      props[:mdx] = compiled.to_inertia_props[:mdx]
    end

    render inertia: "Skills/Show", props: props
  end

  private

  def serialize_skill(skill)
    {
      id: skill.id,
      name: skill.name,
      category: skill.category,
      version: skill.version,
      uml_type: skill.uml_type,
      section_count: skill.section_count,
      key_point_count: skill.key_point_count,
      has_code: skill.has_code?,
      has_diagrams: skill.has_diagrams?,
      content: skill.content,
      output_path: skill.output_path
    }
  end

  def serialize_document(doc)
    {
      id: doc.id,
      title: doc.title
    }
  end
end
