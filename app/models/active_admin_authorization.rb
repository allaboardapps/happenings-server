class ActiveAdminAuthorization < ActiveAdmin::AuthorizationAdapter
  def authorized?(_, _)
    user.active_admin_access?
  end
end
