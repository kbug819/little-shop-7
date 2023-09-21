class Merchants::DiscountsController < ApplicationController
  def index
    @merchant = Merchant.find(params[:merchant_id])
    @discounts = @merchant.discounts
  end

  def show
    @merchant = Merchant.find(params[:merchant_id])
    @discount = Discount.find(params[:discount_id])
  end

  def new
    @merchant = Merchant.find(params[:merchant_id])
  end

  def create
    merchant = Merchant.find(params[:merchant_id])
    discount = merchant.discounts.new(discount_params)
    discount.save
    if discount.save
      redirect_to merchant_discounts_path(merchant.id)
      flash[:success] = "Discount successfully created!"
    elsif !discount.save
      redirect_to new_merchant_discount_path(merchant.id)
      flash[:error] = "Item not created: Required information missing."
    end
  end

  private
  
  def discount_params
    params.permit(:percentage, :quantity)
  end
end
