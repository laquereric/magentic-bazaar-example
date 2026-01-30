module Admin
  class UsersController < BaseController
    def index
      @users = User.order(created_at: :desc)
    end

    def update
      user = User.find(params[:id])
      user.update!(admin: params[:user][:admin])
      redirect_to admin_users_path, notice: "User updated."
    end
  end
end
