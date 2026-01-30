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

    render inertia: "UmlDiagrams/Show", props: {
      uml_diagram: serialize_uml_diagram(@uml_diagram),
      document: @document ? serialize_document(@document) : nil
    }
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
