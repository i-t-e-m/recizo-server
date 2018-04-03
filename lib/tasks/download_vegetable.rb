class Tasks::DownloadVegetable
  def self.take_excel(vegs_name)
    @path = "https://vegetan.alic.go.jp/kakakugurafu/#{vegs_name}.xlsx"

    begin
      open(@path)
    rescue
      @path = "https://vegetan.alic.go.jp/kakakugurafu/#{vegs_name}.xls"
    end

    begin
      file_name = "#{Date.today}_#{File.basename(@path)}"

      open("lib/tasks/excel/#{file_name}", 'wb') do |output|
        open(@path) do |data|
          output.write(data.read)
        end
      end
    rescue
      raise "ファイルのダウンロードに失敗しました。#{@path}"
    end
    file_name
  end


  def self.self_excel(vegs_name)
    begin

      @path = if File.exist?("lib/tasks/excel/#{vegs_name}.xlsx")
                "lib/tasks/excel/#{vegs_name}.xlsx"
              else
                "lib/tasks/excel/#{vegs_name}.xls"
              end

      file_name = "#{Date.today}_#{File.basename(@path)}"

      open("lib/tasks/excel/#{file_name}", 'wb') do |output|
        open(@path) do |data|
          output.write(data.read)
        end
      end

    rescue
      raise "ファイルの探索に失敗しました。#{@path}"
    end
    file_name
  end

end
