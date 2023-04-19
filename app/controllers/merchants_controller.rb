class MerchantsController < ApplicationController
  def show 
    @merchant = Merchant.find(params[:id])
    @invoices = @merchant.invoices.order(created_at: :asc)
    @merchant_img = PhotoBuilder.random_img
  end
end