class Api::UsersController < ApplicationController
  skip_authorization_check
 
  respond_to :json

  def index
    respond_with User.all
  end  

  def show
    respond_with User.find(params[:id])
  end



  private
  def user_params
    params.require(:user).permit(:name, :email, :password, :password_confirmation)
  end
end
