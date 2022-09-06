class ApplicationController < ActionController::API

    rescue_from CanCan::AccessDenied do |exception|
        render json: {message: "You are not authorised to perform this action", sign_in_url: user_session_url }, status: 401
        
    end

    def generate_time(time)
        date = ''
        date += time.year.to_s
        date += '0' if time.month.to_i < 10
        date += time.month.to_s
        date += '0' if time.day.to_i < 10
        date += time.day.to_s
        date
    end

end
