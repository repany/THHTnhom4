class SessionsController < Devise::SessionsController
  skip_before_filter :authenticate_user!
  wrap_parameters :user, format: [:json]
  respond_to :json, :html
end
