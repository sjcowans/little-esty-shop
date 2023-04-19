class MerchantsController < ApplicationController
  def show 
    @merchant = Merchant.find(params[:id])
    @invoices = @merchant.invoices.order(created_at: :asc)
    @merchant_image = MerchantImageSearch.new.merch_image
  end
end