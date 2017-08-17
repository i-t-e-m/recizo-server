class Recipe::ApisController < ApplicationController

  include ActionController::HttpAuthentication::Token::ControllerMethods

  before_action :authenticate

  def index
    #category = params[:category]
    category = 10
    client_id = ENV['RAKUTEN_RECIPE_APP_ID']
    recipe_url = "https://app.rakuten.co.jp/services/api/Recipe/CategoryRanking/20170426?format=json&categoryId=#{category}&applicationId=#{client_id}"
    response = open(recipe_url) {|f| f.read}
    hash = JSON.parse(response)
    recipes = hash['result'].map{|item|
      item.slice('recipeTitle', 'recipeUrl', 'foodImageUrl','nickname', 'recipeDescription')
    }
    render json: recipes
  end

  protected

  def authenticate
    authenticate_or_request_with_http_token do |token|
      token == ENV['RECIZO_API_TOKEN']
    end
  end

end
