class Api::V1::AuthenticationController < ApplicationController
    rescue_from ActionController::ParameterMissing, with: :parameter_missing
    
    def create
        user = User.find_by(username: params.require(:username))
        print params.require(:password).inspect

        # call jwt auth service and pass in user_id
        token = AuthenticationTokenService.call(user.id)

        render json: { token: token }, status: :created 
    end

    private
    def parameter_missing(e)
        render json: { error: e.message }, status: :unprocessable_entity
    end
end