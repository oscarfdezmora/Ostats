require 'json'
class MembersController < ApplicationController

  def index
    @get_player_stats = MembersController.get_player_stats(current_member.user_id)
    @get_plays_by_date = MembersController.get_plays_by_date(current_member.user_id)
    @get_plays_by_hourofday = MembersController.get_plays_by_hourofday(current_member.user_id)
    @get_plays_by_top_10_platforms_by_platform = MembersController.get_plays_by_top_10_platforms_by_platform(current_member.user_id)
    @get_plays_by_top_10_platforms_by_category = MembersController.get_plays_by_top_10_platforms_by_category(current_member.user_id)
    @get_plays_by_dayofweek = MembersController.get_plays_by_dayofweek(current_member.user_id)
  end

  def self.get_player_stats(user_id)
    data_get_user_player_stats = JSON.parse(ApiController.request_api("get_user_player_stats",user_id))["response"]["data"]
    data_get_user_player_stats.to_json
  end

  def self.get_plays_by_date(user_id=nil)
    if user_id
      data_get_plays_by_date = JSON.parse(ApiController.request_api("get_plays_by_date",user_id))["response"]["data"]
    else
      data_get_plays_by_date = JSON.parse(ApiController.request_api("get_plays_by_date"))["response"]["data"]
    end
    result = []
    (0..data_get_plays_by_date["categories"].length-1).each do |index|
        total = 0
        data_get_plays_by_date["series"].each do |series|
          total +=series["data"][index]
        end
        result.push({:date => data_get_plays_by_date["categories"][index].split("-"), :count => total})
    end
    result.to_json
  end

  def self.get_plays_by_top_10_platforms_by_category(user_id)
    data_get_plays_by_top_10_platforms = JSON.parse(ApiController.request_api("get_plays_by_top_10_platforms",user_id))["response"]["data"]
    result = [['Category','Plays']]
    data_get_plays_by_top_10_platforms["series"].each do |category|
      result.push([category["name"],category["data"].sum])
    end
    result
  end
  def self.get_plays_by_top_10_platforms_by_platform(user_id)
    data_get_plays_by_top_10_platforms = JSON.parse(ApiController.request_api("get_plays_by_top_10_platforms",user_id))["response"]["data"]
    result = [['Platform','Plays']]
    (0..data_get_plays_by_top_10_platforms["categories"].length-1).each do |index|
      array = [data_get_plays_by_top_10_platforms["categories"][index]]
      total = 0
      data_get_plays_by_top_10_platforms["series"].each do |data|
        total += data["data"][index]
      end
      array.push(total)
      result.push(array)
    end
    result
  end

  def self.get_plays_by_dayofweek(user_id=nil)
    if user_id
      data_get_plays_by_dayofweek = JSON.parse(ApiController.request_api("get_plays_by_dayofweek",user_id))["response"]["data"]
    else
      data_get_plays_by_dayofweek = JSON.parse(ApiController.request_api("get_plays_by_dayofweek"))["response"]["data"]
    end
    result = []
    categories = ['Day']
    data_get_plays_by_dayofweek["series"].each do |type|
        categories.push(type["name"])
    end
    result.push(categories)
    (0..data_get_plays_by_dayofweek["categories"].length-1).each do |index|
      data = []
      data.push(data_get_plays_by_dayofweek["categories"][index])
      data_get_plays_by_dayofweek["series"].each do |value|
        data.push(value["data"][index])
      end
      result.push(data)
    end
    result
  end

  def self.get_plays_by_hourofday(user_id=nil)
    if user_id
      data_get_plays_by_hourofday = JSON.parse(ApiController.request_api("get_plays_by_hourofday",user_id))["response"]["data"]
    else
      data_get_plays_by_hourofday = JSON.parse(ApiController.request_api("get_plays_by_hourofday"))["response"]["data"]
    end
    result = []
    categories = ['Hour']
    data_get_plays_by_hourofday["series"].each do |type|
        categories.push(type["name"])
    end
    result.push(categories)
    (0..data_get_plays_by_hourofday["categories"].length-1).each do |index|
      data = []
      data.push(data_get_plays_by_hourofday["categories"][index])
      data_get_plays_by_hourofday["series"].each do |value|
        data.push(value["data"][index])
      end
      result.push(data)
    end
    result
  end

end
