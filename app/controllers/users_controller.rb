class UsersController < ApplicationController
    rescue_from ActiveRecord::RecordInvalid, with: :invalid_entity
    def create
        user = User.create!(user_params)
        if user
            render json: user, status: :created
            session[:user_id] = user.id
        else
            render json: { errors: user.errors.full_messages }, status: :unprocessable_entity
        end
    end
    def show
        user = User.find_by(id: session[:user_id])
        if user
            render json: user
        else
            render json: { errors: ["Not Authorized"] }, status: :unauthorized
        end
    end
    private
    def user_params
        params.permit(:username,:password,:password_confirmation,:image_url,:bio)
    end
    def invalid_entity(invalid)
        render json: { errors: invalid.record.errors.full_messages }, status: :unprocessable_entity
    end
end
