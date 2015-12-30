class Api::BasicsController < ApplicationController
  skip_authorization_check
  def create
    user_password = params[:session][:password]
    user_username = params[:session][:username]
    user = user_username.present? && User.find_by(username: user_username)
    users = User.all

    if !user.nil? && user.valid_password?(user_password)
      sign_in user, store: false
      render json: { gender: user.gender,status: 200,
                    metrics: [
                     {
                        name: "LDL",
                        features:{
                           healthyrange: [73, 104],
                           totalrange: [0, 160, user.dld],
                           boundayflags: ["false", "true"],
                           weight: 9,
                           unitlabel:"mg/dl"
                        }
                     },
                     {
                        name:"HDL",
                        features:{
                           healthyrange: [79, 106],
                           totalrange: [0, 130, user.hld],
                           boundayflags:["false", "true"],
                           weight: 4,
                           unitlabel:"mg/dl"
                        }
                     },
                     {
                        name:"Triglycerides",
                        features:{
                           healthyrange: [355,501],
                           totalrange:[0,600, user.triglycerides],
                           boundayflags:["false","true"],
                           weight:3,
                           unitlabel:"mg/dl"
                        }
                     },
                     {
                        name:"Sleep",
                        features:{
                           healthyrange: [4,6],
                           totalrange:[ 0,18, user.sleep],
                           boundayflags:["false","true"],
                           weight:5,
                           unitlabel:"hours/night"
                        }
                     },
                     {
                        name:"Exercise",
                        features:{
                           healthyrange: [37,65],
                           totalrange: [0,120,user.exercise],
                           boundayflags:["false","true"],
                           weight:5,
                           unitlabel:"hours/week"
                        }
                     },
                     {
                        name:"Happiness",
                        features:{
                           healthyrange: [6,9],
                           totalrange: [0,10,user.happiness],
                           boundayflags:["false", "true"],
                           weight:3,
                           unitlabel:"happiness scale"
                        }
                     },
                     {
                        name:"Glucose",
                        features:{
                           healthyrange: [55,95],
                           totalrange: [0,160, user.glucose],
                           boundayflags:["false","true"],
                           weight:10,
                           unitlabel:"mg/dl"
                        }
                     },
                     {
                        name:"Blood Pressure Systolic",
                        features:{
                           healthyrange: [102,151],
                           totalrange:[ 50,230,user.blood_pressure_systolic],
                           boundayflags:["false","true"],
                           weight:5,
                           unitlabel:"mm/Hg"
                        }
                     },
                     {
                        name:"Blood Pressure Diastolic",
                        features:{
                           healthyrange: [62, 92],
                           totalrange: [35, 140, user.blood_pressure_diastolic],
                           boundayflags:["false", "true"],
                           weight:5,
                           unitlabel:"mm/Hg"
                        }
                     },
                     {
                        name:"Alcohol",
                        features:{
                           healthyrange: [1, 3],
                           totalrange: [0, 20, user.alcohol],
                           boundayflags:["false", "true"],
                           weight:5,
                           unitlabel:"drinks/week"
                        }
                     },
                     {
                        name:"Smoking",
                        features:{
                           healthyrange: [0, 1],
                           totalrange: [0, 10, user.smoking],
                           boundayflags:["false", "true"],
                           weight:5,
                           unitlabel:"cigarettes/day"
                        }
                     },
                     {
                        name:"Waist Circumference",
                        features:{
                           healthyrange: [70, 79],
                           totalrange: [0, 200, user.waist_circumference],
                           boundayflags:["false", "true"],
                           weight:10,
                           unitlabel:"inches"
                        }
                     },
                     {
                        name:"Pain",
                        features:{
                           healthyrange: [0, 3],
                           totalrange: [0, 10, user.pain],
                           boundayflags:["false", "true"],
                           weight:3,
                           unitlabel:"pain scale"
                        }
                     }
                  ]
                }, status: 200, location: [:api, user]
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
