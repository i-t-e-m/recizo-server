class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception

  private
  def sort_by_date(veg, date)

    date_array = date.split('/')
    d = Date.new(2016, date_array[0].to_i, date_array[1].to_i)

    veg.sort_by { |hash|
      date_array2 = hash['date'].split('/')
      d2 = Date.new(2016, date_array2[0].to_i, date_array2[1].to_i)

      if (d2 - d) <= 0
        d2 - d + 1000
      else
        d2 - d
      end
    }
  end

  def pull_date_from_json
    File.open('lib/tasks/date/date.json') do |file|
      @jd = JSON.load(file)
    end
    @jd
  end

  def create_vegetable_json(veg, date)
    sort_by_date(veg, date).to_json(only: [:date, :price])
  end
end
