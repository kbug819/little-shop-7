class Merchants::HolidayDiscountsController < ApplicationController
  def new
    @merchant = Merchant.find(params[:merchant_id])
  end

end