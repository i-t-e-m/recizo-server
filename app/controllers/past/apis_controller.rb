class Past::ApisController < ApplicationController
  def index

    json_dates = pull_date_from_json

    cabbage = create_vegetable_map(PastCabbage.all.select('date, price'), json_dates['cabbage'])

    negi = create_vegetable_map(PastNegi.all.select('date, price'), json_dates['negi'])

    hakusai = create_vegetable_map(PastHakusai.all.select('date, price'), json_dates['hakusai'])

    spinach = create_vegetable_map(PastSpinach.all.select('date, price'), json_dates['spinach'])

    lettuce = create_vegetable_map(PastLettuce.all.select('date, price'), json_dates['lettuce'])

    onion = create_vegetable_map(PastOnion.all.select('date, price'), json_dates['onion'])

    broccoli = create_vegetable_map(PastBroccoli.all.select('date, price'), json_dates['broccoli'])

    cucumber = create_vegetable_map(PastCucumber.all.select('date, price'), json_dates['cucumber'])

    tomato = create_vegetable_map(PastTomato.all.select('date, price'), json_dates['tomato'])

    eggplant = create_vegetable_map(PastEggplant.all.select('date, price'), json_dates['eggplant'])

    peeman = create_vegetable_map(PastPeeman.all.select('date, price'), json_dates['peeman'])

    daikon = create_vegetable_map(PastDaikon.all.select('date, price'), json_dates['daikon'])

    carrot = create_vegetable_map(PastCarrot.all.select('date, price'), json_dates['carrot'])

    taro = create_vegetable_map(PastTaro.all.select('date, price'), json_dates['taro'])

    potato = create_vegetable_map(PastPotato.all.select('date, price'), json_dates['potato'])

    vegetables = {
      kyabetsu: cabbage,
      negi: negi,
      hakusai: hakusai,
      hourensou: spinach,
      retasu: lettuce,
      tamanegi: onion,
      burokkori: broccoli,
      kyuri: cucumber,
      tomato: tomato,
      nasu: eggplant,
      piman: peeman,
      daikon: daikon,
      ninjin: carrot,
      satoimo: taro,
      jagaimo: potato
    }

    render json: vegetables
  end


  def kyabetsu
    cabbage = create_vegetable_map(PastCabbage.all.select('date, price'), pull_date_from_json['cabbage'])
    render json: { kyabetsu: cabbage }
  end

  def negi
    negi = create_vegetable_map(PastNegi.all.select('date, price'), pull_date_from_json['negi'])
    render json: { negi: negi }
  end

  def hakusai
    hakusai = create_vegetable_map(PastHakusai.all.select('date, price'), pull_date_from_json['hakusai'])
    render json: { hakusai: hakusai }
  end

  def hourensou
    spinach = create_vegetable_map(PastSpinach.all.select('date, price'), pull_date_from_json['spinach'])
    render json: { hourensou: spinach }
  end

  def retasu
    lettuce = create_vegetable_map(PastLettuce.all.select('date, price'), pull_date_from_json['lettuce'])
    render json: { retasu: lettuce }
  end

  def tamanegi
    onion = create_vegetable_map(PastOnion.all.select('date, price'), pull_date_from_json['onion'])
    render json: { tamanegi: onion }
  end

  def burokkori
    broccoli = create_vegetable_map(PastBroccoli.all.select('date, price'), pull_date_from_json['broccoli'])
    render json: { burokkori: broccoli }
  end

  def kyuri
    cucumber = create_vegetable_map(PastCucumber.all.select('date, price'), pull_date_from_json['cucumber'])
    render json: { kyuri: cucumber }
  end

  def tomato
    tomato = create_vegetable_map(PastTomato.all.select('date, price'), pull_date_from_json['tomato'])
    render json: { tomato: tomato }
  end

  def nasu
    eggplant = create_vegetable_map(PastEggplant.all.select('date, price'), pull_date_from_json['eggplant'])
    render json: { nasu: eggplant }
  end

  def piman
    peeman = create_vegetable_map(PastPeeman.all.select('date, price'), pull_date_from_json['peeman'])
    render json: { piman: peeman }
  end

  def daikon
    daikon = create_vegetable_map(PastDaikon.all.select('date, price'), pull_date_from_json['daikon'])
    render json: { daikon: daikon }
  end

  def ninjin
    carrot = create_vegetable_map(PastCarrot.all.select('date, price'), pull_date_from_json['carrot'])
    render json: { ninjin: carrot }
  end

  def satoimo
    taro = create_vegetable_map(PastTaro.all.select('date, price'), pull_date_from_json['taro'])
    render json: { satoimo: taro }
  end

  def jagaimo
    potato = create_vegetable_map(PastPotato.all.select('date, price'), pull_date_from_json['potato'])
    render json: { jagaimo: potato }
  end
  
end
