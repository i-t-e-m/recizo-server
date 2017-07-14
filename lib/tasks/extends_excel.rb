class Tasks::ExtendsExcel < Roo::Excel
  # returns the content of a cell. The upper left corner is (1,1) or ('A',1)

  def read_cells(sheet = default_sheet)
    validate_sheet!(sheet)
    return if @cells_read[sheet]

    worksheet = @workbook.worksheet(sheet_no(sheet))
    row_index = 1
    worksheet.each(0) do |row|
      (0..row.size).each do |cell_index|
        cell = row.at(cell_index)
        next if cell.nil? # skip empty cells
        next if cell.class == ::Spreadsheet::Formula && cell.value.nil? # skip empty formula cells
        #変更部分 不正なdateセルを変換しないようにする
        value_type, v = if date_or_time?(row, cell_index)
                          yyyy, mm, dd = read_cell_date_or_time(row, cell_index)[1].split('-')
                          date = Date.new(yyyy.to_i, mm.to_i, dd.to_i)
                          if date.year >= 2010
                            [:string, "#{date.month}/#{date.day}"]
                          else
                            read_cell(row, cell_index)
                          end
                        else
                          read_cell(row, cell_index)
                        end
        formula = tr = nil # TODO:???
        col_index = cell_index + 1
        font = row.format(cell_index).font
        font.extend(ExcelFontExtensions)
        set_cell_values(sheet, row_index, col_index, 0, v, value_type, formula, tr, font)
      end # row
      row_index += 1
    end # worksheet
    @cells_read[sheet] = true
  end

end