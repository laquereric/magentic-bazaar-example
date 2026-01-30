class DashboardController < ApplicationController
  def show
    @document_count = MagenticBazaar::Document.count
    @ingested_count = MagenticBazaar::Document.where(status: "ingested").count
    @skill_count = MagenticBazaar::Skill.count
    @uml_count = MagenticBazaar::UmlDiagram.count
    @recent_ingestions = MagenticBazaar::Ingestion.order(created_at: :desc).limit(5)
    @uml_type_distribution = MagenticBazaar::UmlDiagram.group(:diagram_type).count
  end
end
