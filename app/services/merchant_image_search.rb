class MerchantImageSearch

  def merch_image
    MerchantImage.new(service.merchant_image)
  end

  def service
    UnsplashService.new
  end
end