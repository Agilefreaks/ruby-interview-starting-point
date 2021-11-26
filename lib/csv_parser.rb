require 'open-uri'
require 'csv'

class CsvParser

  attr_reader :file_url

  def initialize(url)
    @file_url = url
  end


  def get_data

    file_obj = file_url.open { |f| f.read }
    shop_data = CSV.parse(file_obj)

    shop_data.map { |col| { name: col[0],
                            shop_x: Float(col[1]),
                            shop_y: Float(col[2]) }
    }

  end

end
