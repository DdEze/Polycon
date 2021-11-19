class ApplicationController < ActionController::Base
 before_action :authenticate_user!

 rescue_from CanCan::AccessDenied do |exception|
     flash[:error] = "Accesso denegado!"
     #redirect_to new_user_session_path
     
 end

end
