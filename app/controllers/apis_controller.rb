class ApisController < ApplicationController
  def index

    cabbage = RecentCabbage.all.order('id').to_json(only: [:date, :price])
    negi = RecentNegi.all.order('id').to_json(only: [:date, :price])
    hakusai = RecentHakusai.all.order('id').to_json(only: [:date, :price])
    spinache = RecentSpinach.all.order('id').to_json(only: [:date, :price])
    lettuce = RecentLettuce.all.order('id').to_json(only: [:date, :price])
    onion = RecentOnion.all.order('id').to_json(only: [:date, :price])
    broccoli = RecentBroccoli.all.order('id').to_json(only: [:date, :price])
    cucumber = RecentCucumber.all.order('id').to_json(only: [:date, :price])
    tomato = RecentTomato.all.order('id').to_json(only: [:date, :price])
    eggplant = RecentEggplant.all.order('id').to_json(only: [:date, :price])
    peeman = RecentPeeman.all.order('id').to_json(only: [:date, :price])
    daikon = RecentDaikon.all.order('id').to_json(only: [:date, :price])
    carrot = RecentCarrot.all.order('id').to_json(only: [:date, :price])
    taro = RecentTaro.all.order('id').to_json(only: [:date, :price])
    potato = RecentPotato.all.order('id').to_json(only: [:date, :price])

    vegetables = {
      cabbage: cabbage,
      negi: negi,
      hakusai: hakusai,
      spinache: spinache,
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
end
