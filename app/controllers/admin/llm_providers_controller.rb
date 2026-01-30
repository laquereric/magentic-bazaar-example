module Admin
  class LlmProvidersController < BaseController
    def index
      @providers = LlmEngine::LlmProvider.includes(
        llm_provider_gem: :llm_vendor,
        llm_model_configurations: :llm_model
      ).order(:name)
    end

    def show
      @provider = LlmEngine::LlmProvider.find(params[:id])
      @configurations = @provider.llm_model_configurations.includes(llm_model: :llm_vendor).order("llm_engine_llm_models.display_name")
      @available_models = LlmEngine::LlmModel.active
        .where.not(id: @provider.llm_model_configurations.select(:llm_model_id))
        .includes(:llm_vendor)
        .order("llm_engine_llm_vendors.name, llm_engine_llm_models.display_name")
    end

    def new
      @provider = LlmEngine::LlmProvider.new
      @provider_gems = LlmEngine::LlmProviderGem.includes(:llm_vendor).order(:gem_name)
    end

    def create
      @provider = LlmEngine::LlmProvider.new(provider_params)
      if @provider.save
        redirect_to admin_llm_provider_path(@provider), notice: "Provider created."
      else
        @provider_gems = LlmEngine::LlmProviderGem.includes(:llm_vendor).order(:gem_name)
        render :new, status: :unprocessable_entity
      end
    end

    def edit
      @provider = LlmEngine::LlmProvider.find(params[:id])
      @provider_gems = LlmEngine::LlmProviderGem.includes(:llm_vendor).order(:gem_name)
    end

    def update
      @provider = LlmEngine::LlmProvider.find(params[:id])
      if @provider.update(provider_params)
        redirect_to admin_llm_provider_path(@provider), notice: "Provider updated."
      else
        @provider_gems = LlmEngine::LlmProviderGem.includes(:llm_vendor).order(:gem_name)
        render :edit, status: :unprocessable_entity
      end
    end

    def test
      @provider = LlmEngine::LlmProvider.find(params[:id])
      config = @provider.llm_model_configurations.active.detect { |c| c.api_key.present? }

      if config.nil?
        redirect_to admin_llm_provider_path(@provider), alert: "Test failed: no active model configuration with an API key found."
        return
      end

      model_name = config.llm_model.display_name
      gem_name = @provider.llm_provider_gem.gem_name

      models = config.adapter.models
      @provider.update_column(:last_tested_at, Time.current)
      redirect_to admin_llm_provider_path(@provider),
        notice: "Connection successful — #{@provider.name} is reachable. Tested via #{model_name} using #{gem_name}; #{models.size} models returned."
    rescue => e
      model_name ||= config&.llm_model&.display_name || "unknown"
      gem_name ||= @provider.llm_provider_gem&.gem_name || "unknown"
      redirect_to admin_llm_provider_path(@provider),
        alert: "Connection failed for #{@provider.name}. Tested via #{model_name} using #{gem_name}. Error: #{e.message}"
    end

    def destroy
      @provider = LlmEngine::LlmProvider.find(params[:id])
      @provider.destroy
      redirect_to admin_llm_providers_path, notice: "Provider deleted."
    end

    private

    def provider_params
      params.require(:llm_provider).permit(:name, :active, :llm_provider_gem_id)
    end
  end
end
