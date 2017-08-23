class Tasks::StoreVegetable

  def initialize(sheet, veg_eng, veg_ja)
    @sheet = sheet
    @veg_eng = veg_eng
    @veg_ja = veg_ja

    @year = 2010
    @veg_prices = []
    @veg_ave_prices = []
  end

  def store_database

    # 対象日付取得
    json_dates = pull_date_from_json

    date_array = json_dates[@veg_eng.to_s].split('/')
    date = Date.new(@year, date_array[0].to_i, date_array[1].to_i)

    # キャベツ検索
    veg_name_row = find_veg_name_row

    # 月検索(JSON記載)
    veg_date_col = find_veg_month_col(veg_name_row, date_array)

    # 月の存在判定(存在しなかったらシートの月頭に移動)
    none_date = false
    unless veg_date_col
      json_day_to_sheet_top(date_array)
      veg_date_col = find_veg_month_col(veg_name_row, date_array)
      none_date = true
    end

    # 卸売価格文字列判定(なかったら例外飛ばす)
    exist_oroshi_literal(veg_name_row)

    # date探索
    # 毎月1日目の判定が特殊
    # 右方向に進めていく
    (0..30).each do |date_col|

      # 1ヶ月先まで来たら終了
      # 例:6/4が与えられていたとき7/4まで行ったら抜ける
      unless check_month_equal?(veg_name_row, veg_date_col, date_col, date_array)
        raise "#{@veg_eng}:指定したdateセルが見つかりませんでした。(探索日：#{date_array})"
      end

      # date.txtの日のところまでnext
      # 毎月1日目の判定が特殊
      if find_veg_date_col(veg_name_row, veg_date_col + date_col, date_array)
        veg_date_col += date_col
        break
      end
    end


    # 次の列が空白になるまでループ 3は卸売価格にポインターを当てている
    #p @veg_ja
    if !none_date
      (1..62).each do |i|
        next if @sheet.cell(veg_name_row + 3, veg_date_col + i).blank?

        # 日付の加算(シートの日付にする)
        date_array = match_sheet_day(veg_name_row, veg_date_col + i, date_array)

        # 空白の日付に-1を代入する
        date = blank_time_insert(date, date_array)


        # 価格挿入
        price_insert(veg_name_row, veg_date_col + i, date_array)

      end
    else
      (0..61).each do |i|
        next if @sheet.cell(veg_name_row + 3, veg_date_col + i).blank?

        # 日付の加算(シートの日付にする)
        unless i.zero?
          date_array = match_sheet_day(veg_name_row, veg_date_col + i, date_array)
        end

        # 空白の日付に-1を代入する
        date = blank_time_insert(date, date_array)


        # 価格挿入
        price_insert(veg_name_row, veg_date_col + i, date_array)

      end
    end


    # 平均価格の-1埋める処理
    veg_past_save_before

    # 保存
    change = veg_save

    past_change = veg_past_save(change)

    # 日付更新
    json_dates[@veg_eng.to_s] = "#{date_array[0]}/#{date_array[1]}"
    File.write('lib/tasks/date/date.json', json_dates.to_json)

    past_change
  end


  private

  def cell_to_string(row, col)
    # セルの型判定
    cell_tmp = @sheet.cell(row, col)
    return cell_tmp if cell_tmp.is_a?(String)
    return cell_tmp.to_i.to_s if cell_tmp.is_a?(Float) || cell_tmp.is_a?(Integer)
    return '' if cell_tmp.blank?
    raise "#{@veg_eng}:セルの型が特殊です。(#{cell_tmp.class})"
  end

  def pull_date_from_json
    File.open('lib/tasks/date/date.json') do |file|
      @jd = JSON.load(file)
    end
    @jd
  end

  def find_veg_name_row
    @sheet.first_row.upto(@sheet.last_row) do |row|
      next if @sheet.cell(row, 1).blank? || @sheet.cell(row, 1) != @veg_ja
      return row
    end
  end

  def find_veg_month_col(row, date_array)
    (@sheet.first_column + 3).upto(@sheet.last_column).each do |col|
      # 目的の月までnext
      next if cell_to_string(row, col).gsub(%r{/\d+}, '/') != "#{date_array[0]}/"
      return col
    end
    false
  end

  def exist_oroshi_literal(row)
    [3, 9, 15, 21].each do |i|
      unless @sheet.cell(row + i, 3) == '卸売価格'
        raise "#{@veg_eng}:ファイルの形式が変わっているかもしれません。"
      end
    end
  end

  def check_month_equal?(row, col, date_col, date_array)
    begin
      if cell_to_string(row, col + date_col).include?('/')
        now_month = cell_to_string(row, col + date_col).gsub(%r{/\d+}, '')
        return false if now_month != date_array[0]
        return true
      else
        return true
      end
    rescue
      raise "#{@veg_eng}:include?('/')が実行できません。日付が存在してない可能性があります。\n jsonファイル内の日付とエクセルファイルを確認してみてください。"
    end
  end

  def json_day_to_sheet_top(date_array)
    date_array[0] = (Date.new(@year, date_array[0].to_i, 1) + 1.month).month.to_s
    if cell_to_string(1, 4).gsub(%r{/\d+}, '') == date_array[0]
      @year += 1 if cell_to_string(1, 4).gsub(%r{/\d+}, '') == '1'
    else
      raise "#{@veg_eng}:来月頭のセルが見つかりませんでした。(探索日：#{date_array})"
    end
    date_array[1] = cell_to_string(1, 4).gsub(%r{\d+/}, '')
  end

  def find_veg_date_col(row, col, date_array)

    return true if cell_to_string(row, col) == date_array[1]
    return true if cell_to_string(row, col) == "#{date_array[0]}/#{date_array[1]}"
    false
  end

  def match_sheet_day(row, col, date_array)
    if cell_to_string(row, col).include?('/')
      # 12月だったら1月に戻す
      if date_array[0] == '12'
        date_array[0] = '1'
        @year += 1
      else
        date_array[0] = (date_array[0].to_i + 1).to_s
      end
      date_array[1] = cell_to_string(row, col).gsub(%r{\d+/}, '')
    else
      date_array[1] = cell_to_string(row, col)
    end
    date_array
  end

  def blank_time_insert(date, date_array)
    date += 1
    if date_array != "#{date.month}/#{date.day}"
      diff_date = (Date.new(@year, date_array[0].to_i, date_array[1].to_i) - date).to_i
      diff_date.times{
        @veg_prices.push({"#{date.month}/#{date.day}" => -1})
        @veg_ave_prices.push({"#{date.month}/#{date.day}" => -1})
        date += 1
      }
    end
    date
  end

  def price_insert(row, col, date_array)
    oroshi = 0
    oroshi_count = 0
    ave = 0
    [3, 9, 15, 21].each do |num|
      if @sheet.cell(row + num, 3) == '卸売価格'
        if @sheet.cell(row + num, col).present? && @sheet.cell(row + num, col).round != 0
          oroshi += @sheet.cell(row + num, col).round
          oroshi_count += 1
        end
        ave += @sheet.cell(row + num + 1, col).round
      else
        # 例外投げて終了
        raise "#{@veg_eng}:ファイルの形式が変わっているかもしれません。"
      end
    end

    # 卸市場カウントが0以上
    if oroshi_count == 4
      @veg_prices.push({"#{date_array[0]}/#{date_array[1]}" => (oroshi / oroshi_count.to_f).round})
    else
      @veg_prices.push({"#{date_array[0]}/#{date_array[1]}" => -1})
    end
    @veg_ave_prices.push({"#{date_array[0]}/#{date_array[1]}" => (ave / 4).round})
  end


  def veg_past_save_before
    @veg_ave_prices.each_with_index do |veg, idx|
      # エクセルに存在しなかった場合
      if veg.values[0] == -1

        date_array = veg.keys[0].split('/')
        if date_array[1].to_i == 30 || date_array[1].to_i == 31
          exist_ave = veg_past_ave_insert_down(idx)
        elsif date_array[1].to_i % 10 >= 0 && date_array[1].to_i % 10 < 6
          exist_ave = veg_past_ave_insert_up(idx)
        elsif date_array[1].to_i % 10 >= 6 && date_array[1].to_i % 10 < 10
          exist_ave = veg_past_ave_insert_down(idx)
        end

        # TODO exist_aveの例外は無視
        # raise "#{@veg_eng}:平均値の探索ができませんでした。"

      end
    end
  end

  def veg_past_ave_insert_down(idx)

    exist_ave = false

    #周りからとってくる
    (idx - 1).downto(idx - 9) do |i|
      break if i == -1
      if @veg_ave_prices[i].values[0] != -1
        @veg_ave_prices[idx] = {@veg_ave_prices[idx].keys[0] => @veg_ave_prices[i].values[0]}
        exist_ave = true
        break
      end
    end

    unless exist_ave
      exist_ave = veg_past_get_from_db_down( @veg_ave_prices[idx], idx)
    end

    exist_ave
  end

  def veg_past_ave_insert_up(idx)

    exist_ave = false

    #周りからとってくる
    (idx + 1).upto(idx + 6) do |i|
      break if i == -1
      if @veg_ave_prices[i].values[0] != -1
        @veg_ave_prices[idx] = {@veg_ave_prices[idx].keys[0] => @veg_ave_prices[i].values[0]}
        exist_ave = true
        break
      end
    end

    exist_ave
  end

  def veg_past_get_from_db_down(veg_ave_price, idx)
    # DBからとってくる
    date_array = veg_ave_price.keys[0].split('/')
    ave_use_date = Date.new(@year, date_array[0].to_i, date_array[1].to_i)
    past_veg = nil
    # 10日間遡り
    10.times do |i|
      eval "past_veg = Past#{@veg_eng.to_s.camelize}.find_by(date: '#{(ave_use_date - 1).month}/#{(ave_use_date - 1).day}')"
      if past_veg.price != -1
        @veg_ave_prices[idx] = {@veg_ave_prices[idx].keys[0] => past_veg.price}
        return true
      end
      return false if i == 9
    end
  end



  def veg_save
    change = 0
    @veg_prices.each do |veg|
      recent_veg = nil
      eval "recent_veg = Recent#{@veg_eng.to_s.camelize}.find_by(date: '#{veg.keys[0]}')"
      recent_veg.price = veg.values[0]
      recent_veg.save
      change += 1
    end
    change
  end

  def veg_past_save(change)
    @veg_ave_prices.each do |veg|
      # 保存
      past_veg = nil
      eval "past_veg = Past#{@veg_eng.to_s.camelize}.find_by(date: '#{veg.keys[0]}')"
      past_veg.price = veg.values[0]
      past_veg.save
      change += 1
    end
    change
  end
end