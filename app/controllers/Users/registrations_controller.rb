class Users::RegistrationsController < Devise::RegistrationsController
  before_action :configure_sign_up_params, only: [:create]  
    respond_to :json
  
    private
  
    def respond_with(resource, _opts = {})
      register_success && return if resource.persisted?
  
      register_failed
    end
  
    def register_success
      UserMailer.with(user: current_user ).welcome_email.deliver_later
      render json: { message: 'Signed up sucessfully.' }, status: 201
      
    end
  
    def register_failed
      render json: { message: resource.errors.messages }, status: 406 if resource
    end

    protected 
    def configure_sign_up_params
  devise_parameter_sanitizer.permit(:sign_up, keys: [:role, :name, :email, :weight, :password, :password_confirmation,:age])
      end

  end