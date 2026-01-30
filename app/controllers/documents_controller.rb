class DocumentsController < ApplicationController
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
  end
end
