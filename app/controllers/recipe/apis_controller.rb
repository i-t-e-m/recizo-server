class Recipe::ApisController < ApplicationController

  include ActionController::HttpAuthentication::Token::ControllerMethods

  #before_action :authenticate

  def index
    categories = Category.where('name LIKE ?', "%#{params[:category]}%")


    client_id_map = TestSingleton.instance.pull_client_id

    client_id = client_id_map[:id]

    recipes = []

    if categories.exists? && client_id
      # categories.each do |category|
      #   recipe_url = "https://app.rakuten.co.jp/services/api/Recipe/CategoryRanking/20170426?format=json&categoryId=#{category.category_id}&applicationId=#{client_id}"
      #   response = open(recipe_url) {|f| f.read}
      #   hash = JSON.parse(response)
      #   recipes = hash['result'].map{|item|
      #     item.slice('recipeTitle', 'recipeUrl', 'foodImageUrl','nickname', 'recipeDescription')
      #   }
      #   recipes_list.push(recipes)
      # end

      recipe_url = "https://app.rakuten.co.jp/services/api/Recipe/CategoryRanking/20170426?format=json&categoryId=#{categories[0].category_id}&applicationId=#{client_id}"
      response = open(recipe_url) {|f| f.read}
      hash = JSON.parse(response)
      recipes = hash['result'].map{|item|
        item.slice('recipeTitle', 'recipeUrl', 'foodImageUrl','nickname', 'recipeDescription')
      }
      sleep(0.8)
      TestSingleton.instance.store_nil(client_id_map[:num])
    end

    render json: {result: recipes}
  end

  protected

  def authenticate
    authenticate_or_request_with_http_token do |token|
      token == ENV['RECIZO_API_TOKEN']
    end
  end

end
