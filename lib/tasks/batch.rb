class Tasks::Batch

  def self.execute
    # TODO Driveフォルダ分け
    begin
      #更新行数
      change = 0
      #フォルダ生成
      FileUtils.mkdir_p('lib/tasks/excel')

      VEGETABLES.each do |vegs_name, up_vegname|

        # ダウンロード
        file_name = Tasks::DownloadVegetable.take_excel(vegs_name)

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
        ut = Tasks::UploadVegetable.new
        ut.upload_data(file_name)
      end

      # dbアップロード
      FileUtils.mkdir_p('lib/tasks/db_dump')
      file_name = "#{Date.today}_yasai.dump"
      # system("pg_dump -h localhost -U oliver -c recizo-server_development > #{Rails.root}/lib/tasks/db_dump/#{file_name}")
      system("pg_dump -h localhost -U recizo -c recizo-server_production > #{Rails.root}/lib/tasks/db_dump/#{file_name}")
      ut = Tasks::UploadVegetable.new
      ut.upload_db_data(file_name)


      # 削除
      FileUtils.rm_rf('lib/tasks/db_dump')
      FileUtils.rm_rf('lib/tasks/excel')

      if change > 0
        Slack.chat_postMessage text: "本日（#{Date.today}）の更新は正常に終了しました。(#{change}行更新)",
                               username: 'recizo-api',
                               channel: '#recizo-message'
      else
        Slack.chat_postMessage text:"本日（#{Date.today}）の更新はありませんでした。",
                               username: 'recizo-api',
                               channel: '#recizo-message'
      end
    rescue => e
      msg = ''
      e.backtrace.each do |m|
        msg += "#{m}\n"
        p m
      end
      p e.message
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