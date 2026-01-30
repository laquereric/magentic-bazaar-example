module Admin
  class ContainerRuntimesController < BaseController
    def index
      @container_runtimes = ContainerRuntime.order(:name)
    end

    def show
      @container_runtime = ContainerRuntime.find(params[:id])
    end

    def new
      @container_runtime = ContainerRuntime.new
    end

    def create
      @container_runtime = ContainerRuntime.new(container_runtime_params)
      if @container_runtime.save
        redirect_to admin_container_runtime_path(@container_runtime), notice: "Container runtime created."
      else
        render :new, status: :unprocessable_entity
      end
    end

    def edit
      @container_runtime = ContainerRuntime.find(params[:id])
    end

    def update
      @container_runtime = ContainerRuntime.find(params[:id])
      if @container_runtime.update(container_runtime_params)
        redirect_to admin_container_runtime_path(@container_runtime), notice: "Container runtime updated."
      else
        render :edit, status: :unprocessable_entity
      end
    end

    def test
      @container_runtime = ContainerRuntime.find(params[:id])
      containers = @container_runtime.test_connection!
      redirect_to admin_container_runtime_path(@container_runtime),
        notice: "Connection successful — #{@container_runtime.name} returned #{containers.size} containers."
    rescue => e
      redirect_to admin_container_runtime_path(@container_runtime),
        alert: "Connection failed for #{@container_runtime.name}: #{e.message}"
    end

    def destroy
      @container_runtime = ContainerRuntime.find(params[:id])
      @container_runtime.destroy
      redirect_to admin_container_runtimes_path, notice: "Container runtime deleted."
    end

    private

    def container_runtime_params
      params.require(:container_runtime).permit(
        :name, :driver, :socket_path, :connection_options, :active
      )
    end
  end
end
