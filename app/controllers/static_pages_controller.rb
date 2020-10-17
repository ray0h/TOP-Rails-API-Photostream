require 'flickr'

class StaticPagesController < ApplicationController
  def index
    flickr = Flickr.new ENV['FLICKR_API_KEY'], ENV['FLICKR_SECRET']

    if params['user']
      if !params['user']['user_id'].empty?
        begin
          @user = flickr.people.getInfo(user_id: params[:user][:user_id])
        rescue Flickr::FailedResponse
          flash['error'] = 'No User Found'
        end
      elsif !params['user']['username'].empty?
        begin
          @user = flickr.people.findByUsername(username: params[:user][:username])
        rescue Flickr::FailedResponse
          flash.notice = 'No User Found'
        end
      else
        flash.notice = 'No User Found'
      end
    end

    return if @user.nil?

    @photos = flickr.photos.search(user_id: @user.id)
    @urls = @photos.map do |photo|
      {
        thumb: "https://live.staticflickr.com/#{photo['server']}/#{photo['id']}_#{photo['secret']}_q.jpg",
        link: "https://live.staticflickr.com/#{photo['server']}/#{photo['id']}_#{photo['secret']}_b.jpg"
      }
    end
  end
end
