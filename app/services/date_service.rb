class DateService

  def upcoming_holidays
    response = holiday_connection.get("/api/v3/NextPublicHolidays/US")
    parsed = JSON.parse(response.body, symbolize_names: true)
    holidays = []
    for h in 0..2
      info = parsed[h]
      holiday = Holiday.new(info)
      holidays << holiday
    end
    holidays
  end

  def holiday_connection
    Faraday.new(url:'https://date.nager.at')
  end
end