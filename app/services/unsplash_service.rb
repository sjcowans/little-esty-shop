require 'httparty'

class UnsplashService

  def merchant_image
    get_url("https://api.unsplash.com/photos/random?client_id=9tapV157LqlvFJ5xllsTp_GSEwG_jt6uvbc2zmVRG_8") 
  end

  def get_url(url)
    response = HTTParty.get(url)
    JSON.parse(response.body, symbolize_names: true)
  end
end