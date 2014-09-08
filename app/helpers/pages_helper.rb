module PagesHelper

  def to_date(unix)
     Time.at(unix).strftime "%d/%m/%Y %H:%M:%S"
  end

end
