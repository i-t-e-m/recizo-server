class HomeController < ApplicationController
  def index
  end
  def any
    redirect_to action: index
  end
end
