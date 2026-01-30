module Authorization
  extend ActiveSupport::Concern

  private
    def require_admin
      unless Current.user&.admin?
        redirect_to root_path, alert: "You are not authorized to perform this action."
      end
    end
end
