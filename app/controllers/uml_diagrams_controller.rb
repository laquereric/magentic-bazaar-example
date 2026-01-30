class UmlDiagramsController < ApplicationController
  def index
    scope = MagenticBazaar::UmlDiagram.includes(:document).order(created_at: :desc)
    scope = scope.where(diagram_type: params[:type]) if params[:type].present?

    @diagram_types = MagenticBazaar::UmlDiagram.distinct.pluck(:diagram_type).compact
    @pagy, @uml_diagrams = pagy(:offset, scope, limit: 12)
  end

  def show
    @uml_diagram = MagenticBazaar::UmlDiagram.find(params[:id])
    @document = @uml_diagram.document
  end
end
