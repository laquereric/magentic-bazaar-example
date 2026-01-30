module Admin
  class SkillProvidersController < BaseController
    def index
      @skill_providers = MagenticBazaar::SkillProvider.order(:name)
    end

    def show
      @skill_provider = MagenticBazaar::SkillProvider.find(params[:id])
    end

    def new
      @skill_provider = MagenticBazaar::SkillProvider.new
    end

    def create
      @skill_provider = MagenticBazaar::SkillProvider.new(skill_provider_params)
      if @skill_provider.save
        redirect_to admin_skill_provider_path(@skill_provider), notice: "Skill Provider created."
      else
        render :new, status: :unprocessable_entity
      end
    end

    def edit
      @skill_provider = MagenticBazaar::SkillProvider.find(params[:id])
    end

    def update
      @skill_provider = MagenticBazaar::SkillProvider.find(params[:id])
      if @skill_provider.update(skill_provider_params)
        redirect_to admin_skill_provider_path(@skill_provider), notice: "Skill Provider updated."
      else
        render :edit, status: :unprocessable_entity
      end
    end

    def destroy
      @skill_provider = MagenticBazaar::SkillProvider.find(params[:id])
      @skill_provider.destroy
      redirect_to admin_skill_providers_path, notice: "Skill Provider deleted."
    end

    private

    def skill_provider_params
      params.require(:skill_provider).permit(
        :name, :description, :active, :transport_type,
        :command, :url, :version, :category, :status, :mcp_provider_id
      )
    end
  end
end
