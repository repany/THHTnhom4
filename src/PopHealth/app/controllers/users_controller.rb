class UsersController < ApplicationController
  before_filter :authenticate_user!
  load_and_authorize_resource

  def edit
    @user = User.find params[:id]
  end

  def update
    @user = User.find params[:id]
    if @user.update_attributes user_params
      redirect_to @user
    else
      render :edit
    end
  end

  def show
    @user = User.find params[:id]

    respond_to do |format|
      format.html
      format.json { render :json => custom_json_for(@user) }
    end
  end

  private
  def custom_json_for user
    list = {:name => user.username.to_s,
            :gender => user.gender.to_s,
            :score_data => [
               {"Weight"        => 14, "value" => user.weight.to_i},
               {"LDL"           => 1,  "value"     => user.dld.to_i},
               {"HDL"           => 2,  "value"     => user.hld.to_i},
               {"Triglycerides" => 3,  "value"     => user.triglycerides.to_i},
               {"Sleep"         => 4,  "value"     => user.sleep.to_i},
               {"Exercise"      => 5,  "value"     => user.exercise.to_i},
               {"Happiness"     => 6,  "value"     => user.happiness.to_i},
               {"Glucose"       => 7,  "value"     => user.glucose.to_i},
               {"Blood Pressure Systolic" => 8,  "value"     => user.blood_pressure_systolic.to_i},
               {"Blood Pressure Diastolic" => 9, "value"     => user.blood_pressure_diastolic.to_i},
               {"Alcohol"       => 10, "value"     => user.alcohol.to_i},
               {"Smoking"       => 11, "value"     => user.smoking.to_i},
               {"Waist Circumference" => 12,     "value"     => user.waist_circumference.to_i},
               {"Pain"          => 13, "value"     => user.pain.to_i}
            ]
           }
    list.to_json
  end

  def user_params
    params.require(:user).permit :gender, :weight, :dld, :hld, :triglycerides, 
      :sleep, :exercise, :happiness, :glucose, :blood_pressure_systolic, 
      :blood_pressure_diastolic, :alcohol, :smoking, :waist_circumference, :pain
  end
end
