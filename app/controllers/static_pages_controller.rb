require 'flickr'

class StaticPagesController < ApplicationController
  def index
    flickr = Flickr.new ENV['FLICKR_API_KEY'], ENV['FLICKR_SECRET']

    if params[:user_id]
      @photos = flickr.photos.search(user_id: params[:user_id])
      @urls = @photos.map do |photo|
        {
          thumb: "https://live.staticflickr.com/#{photo['server']}/#{photo['id']}_#{photo['secret']}_q.jpg",
          link: "https://live.staticflickr.com/#{photo['server']}/#{photo['id']}_#{photo['secret']}.jpg"
        }
      end
    end
  
  end
end
