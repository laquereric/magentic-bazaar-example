module Admin
  class McpProvidersController < BaseController
    def index
      @mcp_providers = MagenticBazaar::McpProvider.order(:name)
    end

    def show
      @mcp_provider = MagenticBazaar::McpProvider.find(params[:id])
    end

    def new
      @mcp_provider = MagenticBazaar::McpProvider.new
    end

    def create
      @mcp_provider = MagenticBazaar::McpProvider.new(mcp_provider_params)
      if @mcp_provider.save
        redirect_to admin_mcp_provider_path(@mcp_provider), notice: "MCP Provider created."
      else
        render :new, status: :unprocessable_entity
      end
    end

    def edit
      @mcp_provider = MagenticBazaar::McpProvider.find(params[:id])
    end

    def update
      @mcp_provider = MagenticBazaar::McpProvider.find(params[:id])
      if @mcp_provider.update(mcp_provider_params)
        redirect_to admin_mcp_provider_path(@mcp_provider), notice: "MCP Provider updated."
      else
        render :edit, status: :unprocessable_entity
      end
    end

    def destroy
      @mcp_provider = MagenticBazaar::McpProvider.find(params[:id])
      @mcp_provider.destroy
      redirect_to admin_mcp_providers_path, notice: "MCP Provider deleted."
    end

    private

    def mcp_provider_params
      params.require(:mcp_provider).permit(
        :name, :description, :active, :transport_type,
        :command, :url, :version, :category, :status
      )
    end
  end
end
