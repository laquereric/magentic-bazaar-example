module Admin
  class McpServersController < BaseController
    def index
      @mcp_servers = MagenticBazaar::McpServer.order(:name)
    end

    def show
      @mcp_server = MagenticBazaar::McpServer.find(params[:id])
    end

    def new
      @mcp_server = MagenticBazaar::McpServer.new
    end

    def create
      @mcp_server = MagenticBazaar::McpServer.new(mcp_server_params)
      if @mcp_server.save
        redirect_to admin_mcp_server_path(@mcp_server), notice: "MCP Server created."
      else
        render :new, status: :unprocessable_entity
      end
    end

    def edit
      @mcp_server = MagenticBazaar::McpServer.find(params[:id])
    end

    def update
      @mcp_server = MagenticBazaar::McpServer.find(params[:id])
      if @mcp_server.update(mcp_server_params)
        redirect_to admin_mcp_server_path(@mcp_server), notice: "MCP Server updated."
      else
        render :edit, status: :unprocessable_entity
      end
    end

    def destroy
      @mcp_server = MagenticBazaar::McpServer.find(params[:id])
      @mcp_server.destroy
      redirect_to admin_mcp_servers_path, notice: "MCP Server deleted."
    end

    private

    def mcp_server_params
      params.require(:mcp_server).permit(
        :name, :description, :active, :transport_type,
        :command, :url, :version, :category, :status
      )
    end
  end
end
