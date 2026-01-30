module Admin
  class LlmController < BaseController
    def show
      @vendor_count = LlmEngine::LlmVendor.count
      @provider_gem_count = LlmEngine::LlmProviderGem.count
      @provider_count = LlmEngine::LlmProvider.count
      @model_count = LlmEngine::LlmModel.count
      @config_count = LlmEngine::LlmModelConfiguration.count
      @active_configs = LlmEngine::LlmModelConfiguration.active.count

      @vendors = LlmEngine::LlmVendor.includes(:llm_models).order(:name)
      @provider_gems = LlmEngine::LlmProviderGem.includes(:llm_vendor).order(:gem_name)
    end

    def seed
      require LlmEngine::Engine.root.join("db/seeds")
      LlmEngine::Seeder.seed!
      redirect_to admin_llm_path, notice: "LLM database seeded with vendors, provider gems, and models."
    rescue StandardError => e
      redirect_to admin_llm_path, alert: "Seed failed: #{e.message}"
    end
  end
end
