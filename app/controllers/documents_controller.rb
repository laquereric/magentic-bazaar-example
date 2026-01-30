class DocumentsController < ApplicationController
  layout "inertia", only: [:show]

  def index
    scope = MagenticBazaar::Document.order(created_at: :desc)
    scope = scope.where("title LIKE ?", "%#{params[:q]}%") if params[:q].present?
    scope = scope.where(file_type: params[:file_type]) if params[:file_type].present?
    scope = scope.where(status: params[:status]) if params[:status].present?

    @pagy, @documents = pagy(:offset, scope, limit: 20)
  end

  def show
    @document = MagenticBazaar::Document.find(params[:id])
    @skill = @document.skill
    @uml_diagram = @document.uml_diagram

    mdx_path = find_mdx_file(
      MagenticBazaar.configuration.human_dir,
      @document.uuid7
    )

    props = {
      document: serialize_document(@document),
      skill: @skill ? serialize_skill(@skill) : nil,
      uml_diagram: @uml_diagram ? serialize_uml_diagram(@uml_diagram) : nil
    }

    if mdx_path
      compiler = RailsInertiaMdx::Compiler.new
      compiled = compiler.compile_file(mdx_path)
      props[:mdx] = compiled.to_inertia_props[:mdx]
    end

    render inertia: "Documents/Show", props: props
  end

  private

  def serialize_document(doc)
    {
      id: doc.id,
      title: doc.title,
      original_filename: doc.original_filename,
      uuid7: doc.uuid7,
      git_sha: doc.git_sha,
      file_type: doc.file_type,
      content_hash: doc.content_hash,
      word_count: doc.word_count,
      source_path: doc.source_path,
      status: doc.status,
      created_at: doc.created_at.iso8601
    }
  end

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

  def serialize_uml_diagram(uml)
    {
      id: uml.id,
      diagram_type: uml.diagram_type,
      subtype: uml.subtype,
      title: uml.title,
      puml_content: uml.puml_content,
      output_path: uml.output_path
    }
  end
end
