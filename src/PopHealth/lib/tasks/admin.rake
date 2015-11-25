require ::File.expand_path('../../../config/environment',  __FILE__)

namespace :admin do
  task :create_admin_account do
    admin_account = User.new(
                      :first_name =>     "Administrator",
                      :last_name =>      "Administrator",
                      :username =>       "pophealth",
                      :password =>       "pophealth",
                      :email =>          "provideadmin@providemycompanyname.com",
                      :agree_license =>  true,
                      :gender =>         "male",
                      :weight =>         112,
                      :dld => 110,
                      :hld => 55,
                      :triglycerides => 128,
                      :sleep => 6,
                      :exercise => 3,
                      :happiness => 8, 
                      :glucose => 99,
                      :blood_pressure_systolic => 122,
                      :blood_pressure_diastolic => 85,
                      :alcohol => 1,
                      :smoking => 0,
                      :waist_circumference => 26,
                      :pain => 2)
    admin_account.save!
    admin_account.grant_admin
  end
end
