class MainsController < ApplicationController
  def index
    @data_users = JSON.parse(ApiController.request_api("get_home_stats"))["response"]["data"]
    @data_users.each do |item|
      if item["stat_id"] == "top_movies"
        @top_movies = item["rows"]
      end

      if item["stat_id"] == "popular_movies"
        @popular_movies = item["rows"]
      end

      if item["stat_id"] == "top_tv"
        @top_tv = item["rows"]
      end

      if item["stat_id"] == "popular_tv"
        @popular_tv = item["rows"]
      end

      if item["stat_id"] == "top_music"
        @top_music = item["rows"]
      end

      if item["stat_id"] == "popular_music"
        @popular_music = item["rows"]
      end
    end
  end
end
