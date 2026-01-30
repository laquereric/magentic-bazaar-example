module Admin
  class SkillServersController < BaseController
    def index
      @skill_servers = MagenticBazaar::SkillServer.order(:name)
    end

    def show
      @skill_server = MagenticBazaar::SkillServer.find(params[:id])
    end

    def new
      @skill_server = MagenticBazaar::SkillServer.new
    end

    def create
      @skill_server = MagenticBazaar::SkillServer.new(skill_server_params)
      if @skill_server.save
        redirect_to admin_skill_server_path(@skill_server), notice: "Skill Server created."
      else
        render :new, status: :unprocessable_entity
      end
    end

    def edit
      @skill_server = MagenticBazaar::SkillServer.find(params[:id])
    end

    def update
      @skill_server = MagenticBazaar::SkillServer.find(params[:id])
      if @skill_server.update(skill_server_params)
        redirect_to admin_skill_server_path(@skill_server), notice: "Skill Server updated."
      else
        render :edit, status: :unprocessable_entity
      end
    end

    def destroy
      @skill_server = MagenticBazaar::SkillServer.find(params[:id])
      @skill_server.destroy
      redirect_to admin_skill_servers_path, notice: "Skill Server deleted."
    end

    private

    def skill_server_params
      params.require(:skill_server).permit(
        :name, :description, :active, :transport_type,
        :command, :url, :version, :category, :status, :mcp_server_id
      )
    end
  end
end
