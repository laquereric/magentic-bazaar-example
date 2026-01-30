module Admin
  class IngestionsController < BaseController
    def index
      @ingestions = MagenticBazaar::Ingestion.order(created_at: :desc)
    end

    def show
      @ingestion = MagenticBazaar::Ingestion.find(params[:id])
      @documents = @ingestion.documents
    end

    def create
      MagenticBazaar::IngestJob.perform_later(direction: "forward")
      redirect_to admin_ingestions_path, notice: "Ingestion job has been queued."
    end

    def undo
      ingestion = MagenticBazaar::Ingestion.find(params[:id])
      MagenticBazaar::IngestJob.perform_later(direction: "undo")
      redirect_to admin_ingestion_path(ingestion), notice: "Undo job has been queued."
    end
  end
end
