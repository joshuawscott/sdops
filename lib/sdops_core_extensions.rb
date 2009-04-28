class Date
  # Converts a date to an Excel serialized date
  def to_xls_serial
    x = self - Date.strptime('1899-12-30')
    x.to_i
  end
end
