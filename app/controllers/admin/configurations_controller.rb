module Admin
  class ConfigurationsController < BaseController
    def show
      @config = MagenticBazaar.configuration
    end

    def update
      config = MagenticBazaar.configuration

      config_params.each do |key, value|
        if config.respond_to?("#{key}=")
          case key
          when "async", "multistore_enabled"
            config.send("#{key}=", value == "1" || value == "true")
          when "queue_name"
            config.send("#{key}=", value.to_sym)
          else
            config.send("#{key}=", value)
          end
        end
      end

      redirect_to admin_configuration_path, notice: "Configuration updated (in-memory only)."
    end

    private
      def config_params
        params.require(:configuration).permit(
          :ingest_dir, :ingested_dir, :uml_dir, :skills_dir, :human_dir,
          :tesseract_path, :async, :queue_name, :multistore_enabled
        )
      end
  end
end
