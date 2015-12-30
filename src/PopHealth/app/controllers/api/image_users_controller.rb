class Api::ImageUsersController < ApplicationController
  skip_authorization_check
  def create
    user_password = params[:session][:password]
    user_username = params[:session][:username]
    user = user_username.present? && User.find_by(username: user_username)

    if !user.nil? && user.valid_password?(user_password)
      sign_in user, store: false
      render json: { image_info: "http://localhost:3000/#{user.image_info}" }, status: 200, location: [:api, user]
    else
      render json: { errors: "Invalid email or password" }, status: 422
    end
  end
end
