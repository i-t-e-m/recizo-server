class Tasks::Batch

  def self.execute
    Tasks::Batch.batch(0)
  end

  def self.manual_execute
    Tasks::Batch.batch(1)
  end

  def self.batch(type)
    begin
      #更新行数
      change = 0
      #フォルダ生成
      FileUtils.mkdir_p('lib/tasks/excel')

      VEGETABLES.each do |vegs_name, up_vegname|


        file_name = if type.zero?
                      # ダウンロード
                      Tasks::DownloadVegetable.take_excel(vegs_name)
                    else
                      # 手動配置
                      Tasks::DownloadVegetable.self_excel(vegs_name)
                    end

        #オープン
        if file_name.include?('.xlsx')
          s = Roo::Spreadsheet.open("lib/tasks/excel/#{file_name}")
        elsif file_name.include?('.xls')
          s = Tasks::ExtendsExcel.new("lib/tasks/excel/#{file_name}")
        else
          raise "ファイル形式が変更されたかもしれません(#{file_name})"
        end

        s.default_sheet = '集計表'
        # Excel処理
        up_vegname.each do |veg_eng, veg_ja|
          store_vegetabler = Tasks::StoreVegetable.new(s, veg_eng, veg_ja)
          change += store_vegetabler.store_database
        end

        #アップロード
        if Rails.env.production?
          ut = Tasks::UploadVegetable.new
          ut.upload_data(file_name)
        end

      end

      # dbアップロード
      FileUtils.mkdir_p('lib/tasks/db_dump')
      file_name = "#{Date.today}_yasai.dump"
      if Rails.env.production?
        system("pg_dump -h localhost -U recizo -c recizo-server_production > #{Rails.root}/lib/tasks/db_dump/#{file_name}")
      else
        #system("pg_dump -h localhost -U oliver -c recizo-server_development > #{Rails.root}/lib/tasks/db_dump/#{file_name}")
      end

      if Rails.env.production?
        ut = Tasks::UploadVegetable.new
        ut.upload_db_data(file_name)
      end


      # 削除
      FileUtils.rm_rf('lib/tasks/db_dump')
      FileUtils.rm_rf('lib/tasks/excel')

      if change > 0 && Rails.env.production?
        Slack.chat_postMessage text: "本日（#{Date.today}）の更新は正常に終了しました。(#{change}行更新)",
                               username: 'recizo-api',
                               channel: '#recizo-message'
      elsif Rails.env.production?
        Slack.chat_postMessage text:"本日（#{Date.today}）の更新はありませんでした。",
                               username: 'recizo-api',
                               channel: '#recizo-message'
      else
        puts '正常に終了しました。'
      end
    rescue => e
      msg = ''
      e.backtrace.each do |m|
        msg += "#{m}\n"
        p m
      end
      p e.message

      if Rails.env.production?
        Slack.chat_postMessage text: "エラー報告:（#{Date.today}）\n #{e.message}",
                               username: 'recizo-bot',
                               channel: '#recizo-message'

        Slack.chat_postMessage text: "更新行数:（#{Date.today}）\n #{change}行",
                               username: 'recizo-bot',
                               channel: '#recizo-message'

        Slack.chat_postMessage text: "backtrace:（#{Date.today}）\n #{msg}",
                               username: 'recizo-bot',
                               channel: '#recizo-message'
      end
    end
  end

end