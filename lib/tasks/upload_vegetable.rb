require 'googleauth/stores/redis_token_store'
require 'google/apis/drive_v3'
class Tasks::UploadVegetable


  def upload_data(title)
    json_keys = pull_key_from_json
    @client_id = json_keys['CLIENT_ID']
    @refresh_token = json_keys['REFRESH_TOKEN']


    begin
      drive = create_drive
      # yearフォルダID取得
      recizo_folder_id = '0B1ihc5zd2b9NQ0FoZHRCV1lQVUE'
      year_folder_id = create_folder(drive,
                                     Date.today.year.to_s,
                                     recizo_folder_id)
      #　dateフォルダID取得
      date_folder_id = create_folder(drive,
                                     "#{Date.today.month}_#{Date.today.day}",
                                     year_folder_id)

      # エクセルアップロード
      file_metadata = {
        name: title,
        parents: [date_folder_id]
      }

      drive.create_file(file_metadata, upload_source: "lib/tasks/excel/#{title}")

    rescue => e
      raise "エクセルファイルのアップロードに失敗しました。(#{title}) \n #{e.message}"
    end
  end

  def upload_db_data(title)
    begin
      json_keys = pull_key_from_json
      @client_id = json_keys['CLIENT_ID']
      @refresh_token = json_keys['REFRESH_TOKEN']

      drive = create_drive
      # yearフォルダID取得
      recizo_folder_id = '0B1ihc5zd2b9NQ0FoZHRCV1lQVUE'
      year_folder_id = create_folder(drive,
                                     Date.today.year.to_s,
                                     recizo_folder_id)
      #　dateフォルダID取得
      date_folder_id = create_folder(drive,
                                     "#{Date.today.month}_#{Date.today.day}",
                                     year_folder_id)

      # エクセルアップロード
      file_metadata = {
        name: title,
        parents: [date_folder_id]
      }

      drive.create_file(file_metadata, upload_source: "lib/tasks/db_dump/#{title}")

    rescue => e
      raise "dbファイルのアップロードに失敗しました。(#{title}) \n #{e.message}"
    end
  end

  private

  def create_drive
    scope = ['https://www.googleapis.com/auth/drive']
    client_id = Google::Auth::ClientId.from_file('lib/tasks/secrets/client_secrets.json')
    token_store = Google::Auth::Stores::RedisTokenStore.new(redis: Redis.new)
    authorizer = Google::Auth::UserAuthorizer.new(client_id, scope, token_store)
    credentials = Google::Auth::UserRefreshCredentials.new(
      client_id: @client_id,
      refresh_token: @refresh_token,
      scope: scope,
      expiration_time_millis: 3600
    )
    authorizer.store_credentials('recizo', credentials)
    drive = Google::Apis::DriveV3::DriveService.new
    drive.authorization = authorizer.get_credentials('recizo')
    drive
  end

  def create_folder(drive, name, parent_name)

    # フォルダ存在判定
    folder_exist = false
    folder_id = ''
    drive.list_files.files.each do |file|
      if file.name == name
        folder_exist = true
        folder_id = file.id
      end
    end

    # フォルダ生成
    unless folder_exist
      folder_metadata = {
        name: name,
        mime_type: 'application/vnd.google-apps.folder',
        parents: [parent_name]
      }
      file_object = Google::Apis::DriveV3::File.new(folder_metadata)
      folder_id = drive.create_file(file_object).id
    end
    folder_id
  end


  def pull_key_from_json
    File.open('lib/tasks/secrets/environment.json') do |file|
      @jd = JSON.load(file)
    end
    @jd
  end

end