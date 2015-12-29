class Api::SessionsController < ApplicationController
  skip_authorization_check
  def create
    user_password = params[:session][:password]
    user_username = params[:session][:username]
    user = user_username.present? && User.find_by(username: user_username)

    if !user.nil? && user.valid_password?(user_password)
      sign_in user, store: false
      render json: user, status: 200, location: [:api, user]
    else
      render json: { errors: "Invalid email or password" }, status: 422
    end
  end

  def destroy
    user = User.find_by(auth_token: params[:id])
    user.generate_authentication_token!
    user.save
    head 204
  end
end
