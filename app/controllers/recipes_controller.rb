class RecipesController < ApplicationController
    before_action :authorize
    rescue_from ActiveRecord::RecordInvalid, with: :invalid_entity
    def index
        recipes = Recipe.all
        render json: recipes
    end
    def create
        recipe = Recipe.create!(user_id: session[:user_id], title: params[:title], instructions: params[:instructions], minutes_to_complete: params[:minutes_to_complete])
        render json: recipe, status: :created
    end
    private
    def recipe_params
        params.permit(:title, :instructions, :minutes_to_complete, session[:user_id])
    end
    def authorize
        return render json: { errors: ["Not authorized"] }, status: :unauthorized unless session.include? :user_id
    end
    def invalid_entity(invalid)
        render json: { errors: invalid.record.errors.full_messages }, status: :unprocessable_entity
    end
end
