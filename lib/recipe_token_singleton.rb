
class RecipeTokenSingleton
  include Singleton
  def initialize
    @client_id1 = nil
    @client_id2 = nil
    @client_id3 = nil
    @client_id4 = nil
    @client_id5 = nil
  end

  def pull_client_id
    return { num: 1, id: @client_id1 = ENV['RAKUTEN_RECIPE_APP_ID_1'] } if @client_id1.nil?
    return { num: 2, id: @client_id2 = ENV['RAKUTEN_RECIPE_APP_ID_2'] } if @client_id2.nil?
    return { num: 3, id: @client_id3 = ENV['RAKUTEN_RECIPE_APP_ID_3'] } if @client_id3.nil?
    return { num: 4, id: @client_id4 = ENV['RAKUTEN_RECIPE_APP_ID_4'] } if @client_id4.nil?
    return { num: 5, id: @client_id5 = ENV['RAKUTEN_RECIPE_APP_ID_5'] } if @client_id5.nil?
    nil
  end

  def store_nil(num)
    return @client_id1 = nil if num == 1
    return @client_id2 = nil if num == 2
    return @client_id3 = nil if num == 3
    return @client_id4 = nil if num == 4
    return @client_id5 = nil if num == 5
  end
end