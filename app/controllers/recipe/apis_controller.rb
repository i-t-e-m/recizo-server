class Recipe::ApisController < ApplicationController

  include ActionController::HttpAuthentication::Token::ControllerMethods

  before_action :authenticate

  def index
    categories = Category.where('name LIKE ?', params[:category])

    client_id_map = RecipeTokenSingleton.instance.pull_client_id

    client_id = ''

    if client_id_map
      p client_id_map
      client_id = client_id_map[:id]
    end

    recipes = []
    if categories.exists? && client_id
      client_id_map[:num]
      recipe_url = "https://app.rakuten.co.jp/services/api/Recipe/CategoryRanking/20170426?format=json&categoryId=#{categories[0].category_id}&applicationId=#{client_id}"
      begin
        response = open(recipe_url) {|f| f.read}
        hash = JSON.parse(response)
        recipes = hash['result'].map{|item|
          item.slice('recipeTitle', 'recipeUrl', 'foodImageUrl', 'nickname', 'recipeDescription')
        }
      rescue
        sleep(1.1)
        token_to_nil(client_id, client_id_map)
        render json: { result: false }
        return
      end
      sleep(1.1)
    else
      token_to_nil(client_id, client_id_map)
      render json: { result: false }
      return
    end
    token_to_nil(client_id, client_id_map)
    render json: { result: recipes }
  end

  protected

  def authenticate
    authenticate_or_request_with_http_token do |token|
      token == ENV['RECIZO_API_TOKEN']
    end
  end

  private

  def token_to_nil(client_id, client_id_map)
    unless client_id.blank?
      RecipeTokenSingleton.instance.store_nil(client_id_map[:num])
    end
  end
end
