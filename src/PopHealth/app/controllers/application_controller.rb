class ApplicationController < ActionController::Base
  protect_from_forgery with: :null_session
  layout :layout_by_resource
  before_filter :set_effective_date
  before_filter :check_ssl_used

  # lock it down!
  check_authorization :unless => :devise_controller?

  def upload user
    dirname = Rails.root.join('public', 'uploads', "user_#{user.id}", 'image_info')
    FileUtils.mkdir_p(dirname)
    uploaded_io = params[:user][:image_info]
    image_path = dirname.to_s + '/' + uploaded_io.original_filename
    File.open(image_path, 'wb') do |file|
      file.write(uploaded_io.read)
    end
    user.image_info = "/uploads/user_#{user.id}/image_info/#{uploaded_io.original_filename}"
    user.save
  end

  private

  # Overwriting the sign_out redirect path method
  def after_sign_out_path_for(resource_or_scope)
    "#{Rails.configuration.relative_url_root}/logout.html"
  end

  def hash_document
    d = Digest::SHA1.new
    checksum = d.hexdigest(response.body)
    Log.create(:username => current_user.username, :event => 'document exported', :checksum => checksum)
  end

  def layout_by_resource
    if devise_controller?
      "users"
    else
      "application"
    end
  end

  rescue_from CanCan::AccessDenied do |exception|
    render "public/403", :format=>"html", :status=> 403, :alert => exception.message
  end

  def set_effective_date(effective_date=nil, persist=false)
    if (effective_date)
      @effective_date = effective_date
      current_user.update_attribute(:effective_date, effective_date) if persist
    elsif current_user && current_user.effective_date
      @effective_date = current_user.effective_date
    else
      @effective_date = User::DEFAULT_EFFECTIVE_DATE.to_i
    end
    @period_start = calc_start(@effective_date)
  end

  def calc_start(date)
    1.year.ago(Time.at(date))
  end

  def check_ssl_used
    unless APP_CONFIG['force_unsecure_communications'] or request.ssl?
      redirect_to "#{root_url}no_ssl_warning.html", :alert => "You should be using ssl"
    end
  end
end
