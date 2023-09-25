class Merchants::BulkDiscountsController < ApplicationController
  def index
    @merchant = Merchant.find(params[:merchant_id])
    @discounts = @merchant.bulk_discounts
  end

  def show
    @merchant = Merchant.find(params[:merchant_id])
    @discount = BulkDiscount.find(params[:id])
  end

  def new
    @merchant = Merchant.find(params[:merchant_id])
  end

  def create
    merchant = Merchant.find(params[:merchant_id])
    discount = merchant.bulk_discounts.new(discount_params)
    discount.save
    if discount.save
      redirect_to merchant_bulk_discounts_path(merchant.id)
      flash[:success] = "Discount successfully created!"
    elsif !discount.save
      redirect_to new_merchant_bulk_discount_path(merchant.id)
      flash[:error] = "Item not created: Required information missing."
    end
  end

  def edit
    @merchant = Merchant.find(params[:merchant_id])
    @discount = BulkDiscount.find(params[:id])
    
  end
  
  def update
    @merchant = Merchant.find(params[:merchant_id])
    @discount = BulkDiscount.find(params[:id])
    @discount.update!(discount_params)
    redirect_to merchant_bulk_discount_path(@merchant.id, (params[:id]))
  end

  def destroy
    merchant = Merchant.find(params[:merchant_id])
    BulkDiscount.find(params[:id]).destroy
    redirect_to merchant_bulk_discounts_path(merchant.id)
  end

  private
  
  def discount_params
    params.permit(:percentage, :quantity)
  end
end
