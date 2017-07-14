class ApisController < ApplicationController
  def index

    json_dates = pull_date_from_json

    cabbage = RecentCabbage.all.order('id')
    cabbage = sort_by_date(cabbage, json_dates['cabbage']).to_json(only: [:date, :price])

    negi = RecentNegi.all.order('id')
    negi = sort_by_date(negi, json_dates['negi']).to_json(only: [:date, :price])

    hakusai = RecentHakusai.all.order('id')
    hakusai = sort_by_date(hakusai, json_dates['hakusai']).to_json(only: [:date, :price])

    spinach = RecentSpinach.all.order('id')
    spinach = sort_by_date(spinach, json_dates['spinach']).to_json(only: [:date, :price])

    lettuce = RecentLettuce.all.order('id')
    lettuce = sort_by_date(lettuce, json_dates['lettuce']).to_json(only: [:date, :price])

    onion = RecentOnion.all.order('id')
    onion = sort_by_date(onion, json_dates['onion']).to_json(only: [:date, :price])

    broccoli = RecentBroccoli.all.order('id')
    broccoli = sort_by_date(broccoli, json_dates['broccoli']).to_json(only: [:date, :price])

    cucumber = RecentCucumber.all.order('id')
    cucumber = sort_by_date(cucumber, json_dates['cucumber']).to_json(only: [:date, :price])

    tomato = RecentTomato.all.order('id')
    tomato = sort_by_date(tomato, json_dates['tomato']).to_json(only: [:date, :price])

    eggplant = RecentEggplant.all.order('id')
    eggplant = sort_by_date(eggplant, json_dates['eggplant']).to_json(only: [:date, :price])

    peeman = RecentPeeman.all.order('id')
    peeman = sort_by_date(peeman, json_dates['peeman']).to_json(only: [:date, :price])

    daikon = RecentDaikon.all.order('id')
    daikon = sort_by_date(daikon, json_dates['daikon']).to_json(only: [:date, :price])

    carrot = RecentCarrot.all.order('id')
    carrot = sort_by_date(carrot, json_dates['carrot']).to_json(only: [:date, :price])

    taro = RecentTaro.all.order('id')
    taro = sort_by_date(taro, json_dates['taro']).to_json(only: [:date, :price])

    potato = RecentPotato.all.order('id')
    potato = sort_by_date(potato, json_dates['potato']).to_json(only: [:date, :price])

    vegetables = {
      cabbage: cabbage,
      negi: negi,
      hakusai: hakusai,
      spinach: spinach,
      lettuce: lettuce,
      onion: onion,
      broccoli: broccoli,
      cucumber: cucumber,
      tomato: tomato,
      eggplant: eggplant,
      peeman: peeman,
      daikon: daikon,
      carrot: carrot,
      taro: taro,
      potato: potato
    }

    render json: vegetables
  end

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
end
