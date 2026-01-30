class UmlDiagramsController < ApplicationController
  layout "inertia", only: [:show]

  def index
    scope = MagenticBazaar::UmlDiagram.includes(:document).order(created_at: :desc)
    scope = scope.where(diagram_type: params[:type]) if params[:type].present?

    @diagram_types = MagenticBazaar::UmlDiagram.distinct.pluck(:diagram_type).compact
    @pagy, @uml_diagrams = pagy(:offset, scope, limit: 12)
  end

  def show
    @uml_diagram = MagenticBazaar::UmlDiagram.find(params[:id])
    @document = @uml_diagram.document

    mdx_path = find_mdx_file(
      MagenticBazaar.configuration.uml_dir,
      @document&.uuid7
    )

    props = {
      uml_diagram: serialize_uml_diagram(@uml_diagram),
      document: @document ? serialize_document(@document) : nil
    }

    compiler = RailsInertiaMdx::Compiler.new
    if mdx_path
      compiled = compiler.compile_file(mdx_path)
      props[:mdx] = compiled.to_inertia_props[:mdx]
    elsif @uml_diagram.puml_content.present?
      md = "# #{@uml_diagram.title || 'UML Diagram'}\n\n" \
           "**Type:** #{@uml_diagram.diagram_type}" \
           "#{@uml_diagram.subtype.present? ? " (#{@uml_diagram.subtype})" : ""}\n\n" \
           "```plantuml\n#{@uml_diagram.puml_content}\n```\n"
      compiled = compiler.compile(md)
      props[:mdx] = compiled.to_inertia_props[:mdx]
    end

    render inertia: "UmlDiagrams/Show", props: props
  end

  private

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

  def serialize_document(doc)
    {
      id: doc.id,
      title: doc.title
    }
  end
end
