class Holiday
  attr_reader :date, :name
  def initialize(holiday_info)
    @date = holiday_info[:date]
    @name = holiday_info[:name]
  end
end