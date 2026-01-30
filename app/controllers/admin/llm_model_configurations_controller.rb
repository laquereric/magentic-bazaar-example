module Admin
  class LlmModelConfigurationsController < BaseController
    def new
      @provider = LlmEngine::LlmProvider.find(params[:llm_provider_id])
      @configuration = @provider.llm_model_configurations.build
      @available_models = available_models_for(@provider)
    end

    def create
      @provider = LlmEngine::LlmProvider.find(params[:llm_provider_id])
      @configuration = @provider.llm_model_configurations.build(
        llm_model_id: params.dig(:llm_model_configuration, :llm_model_id),
        active: params.dig(:llm_model_configuration, :active) == "1"
      )
      apply_credentials(@configuration)

      if @configuration.save
        redirect_to admin_llm_provider_path(@provider), notice: "Model configuration added."
      else
        @available_models = available_models_for(@provider)
        render :new, status: :unprocessable_entity
      end
    end

    def edit
      @configuration = LlmEngine::LlmModelConfiguration.find(params[:id])
      @provider = @configuration.llm_provider
    end

    def update
      @configuration = LlmEngine::LlmModelConfiguration.find(params[:id])
      @provider = @configuration.llm_provider

      @configuration.active = params.dig(:llm_model_configuration, :active) == "1"
      apply_credentials(@configuration)

      if @configuration.save
        redirect_to admin_llm_provider_path(@provider), notice: "Configuration updated."
      else
        render :edit, status: :unprocessable_entity
      end
    end

    def destroy
      @configuration = LlmEngine::LlmModelConfiguration.find(params[:id])
      provider = @configuration.llm_provider
      @configuration.destroy
      redirect_to admin_llm_provider_path(provider), notice: "Configuration removed."
    end

    private

    def apply_credentials(config)
      creds = config.credentials || {}

      api_key = params.dig(:llm_model_configuration, :api_key)
      creds[:api_key] = api_key if api_key.present?

      base_url = params.dig(:llm_model_configuration, :base_url)
      if base_url.present?
        creds[:base_url] = base_url
      else
        creds.delete(:base_url)
      end

      config.credentials = creds
    end

    def available_models_for(provider)
      LlmEngine::LlmModel.active
        .where.not(id: provider.llm_model_configurations.select(:llm_model_id))
        .includes(:llm_vendor)
        .order("llm_engine_llm_vendors.name, llm_engine_llm_models.display_name")
    end
  end
end
