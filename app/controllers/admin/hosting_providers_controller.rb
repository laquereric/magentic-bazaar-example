module Admin
  class HostingProvidersController < BaseController
    def index
      @hosting_providers = HostingProvider.order(:name)
    end

    def show
      @hosting_provider = HostingProvider.find(params[:id])
    end

    def new
      @hosting_provider = HostingProvider.new
    end

    def create
      @hosting_provider = HostingProvider.new(hosting_provider_params)
      if @hosting_provider.save
        redirect_to admin_hosting_provider_path(@hosting_provider), notice: "Hosting provider created."
      else
        render :new, status: :unprocessable_entity
      end
    end

    def edit
      @hosting_provider = HostingProvider.find(params[:id])
    end

    def update
      @hosting_provider = HostingProvider.find(params[:id])
      if @hosting_provider.update(hosting_provider_params)
        redirect_to admin_hosting_provider_path(@hosting_provider), notice: "Hosting provider updated."
      else
        render :edit, status: :unprocessable_entity
      end
    end

    def test
      @hosting_provider = HostingProvider.find(params[:id])
      @hosting_provider.test_connection!
      redirect_to admin_hosting_provider_path(@hosting_provider),
        notice: "Connection successful — #{@hosting_provider.name} is reachable."
    rescue => e
      redirect_to admin_hosting_provider_path(@hosting_provider),
        alert: "Connection failed for #{@hosting_provider.name}: #{e.message}"
    end

    def destroy
      @hosting_provider = HostingProvider.find(params[:id])
      @hosting_provider.destroy
      redirect_to admin_hosting_providers_path, notice: "Hosting provider deleted."
    end

    private

    def hosting_provider_params
      params.require(:hosting_provider).permit(
        :name, :provider_type, :api_token, :base_url,
        :timeout, :per_page, :active
      )
    end
  end
end
