module Admin
  class DashboardController < BaseController
    def show
      @document_count = MagenticBazaar::Document.count
      @ingestion_count = MagenticBazaar::Ingestion.count
      @skill_count = MagenticBazaar::Skill.count
      @uml_count = MagenticBazaar::UmlDiagram.count
      @pending_files = Dir.glob(File.join(MagenticBazaar.configuration.ingest_dir, "*")).count
      @recent_ingestions = MagenticBazaar::Ingestion.order(created_at: :desc).limit(10)
      @running_ingestions = MagenticBazaar::Ingestion.where(status: "running")
    end
  end
end
