class MerchantImage
  attr_reader :image

  def initialize(info)
    @image = info[:urls][:regular]
  end
end