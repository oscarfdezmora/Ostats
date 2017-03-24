require 'json'
class AdminsController < ApplicationController

  def index
    @server_info = JSON.parse(ApiController.request_api("get_servers_info"))["response"]["data"][0]
    @get_activity = JSON.parse(ApiController.request_api("get_activity"))["response"]["data"]
    @get_gps_cor = get_gps(@get_activity["sessions"]).to_json
    @count_online = @get_activity["stream_count"]
    @get_activity = @get_activity.to_json
    @get_plays_by_dayofweek = MembersController.get_plays_by_dayofweek
    @get_plays_by_date = MembersController.get_plays_by_date
    @get_plays_by_hourofday = MembersController.get_plays_by_hourofday
  end

  def get_gps(data)
      result = {}
      data.each do |data|
        info = JSON.parse(ApiController.request_gps_ip(data["ip_address"]))["response"]["data"]
        if result.key?(info["country"])
          result[info["country"]] += 1
        else
          result[info["country"]] = 1
        end
      end
      result
  end

  def users
    @data_users = JSON.parse(ApiController.request_api("get_users"))["response"]["data"]
    @member_users = {}

    Member.all.each do |mem|
      @member_users[mem.user_id]={
        :access => mem.is_permit,
        :admin  => mem.is_admin
      }
    end
    render 'admins/users/index'
  end

  def set_access
    if Member.exists?(:user_id => params["user_id"])
      mem = Member.find_by(:user_id => params["user_id"])
      mem.is_permit = !mem.is_permit
      mem.save
    else
      mem = Member.new(:username => params["username"], :email => params["email"], :user_id => params["user_id"].to_i, :is_permit => true, :is_admin => false,:thumb => params["thumb"])
      mem.save
    end
    redirect_to :action => "users"
  end

  def set_admin
    mem = Member.find_by(:user_id => params["user_id"])
    mem.is_admin = !mem.is_admin
    mem.save
    redirect_to :action => "users"
  end

  def profile
    data = JSON.parse(ApiController.request_api("get_user",params["id"]))["response"]["data"]
    @user_userid = params["id"]
    @user_username = data["username"]
    @user_thumb = data["user_thumb"]
    @get_player_stats = MembersController.get_player_stats(params["id"])
    @get_plays_by_date = MembersController.get_plays_by_date(params["id"])
    @get_plays_by_hourofday = MembersController.get_plays_by_hourofday(params["id"])
    @get_plays_by_top_10_platforms_by_platform = MembersController.get_plays_by_top_10_platforms_by_platform(params["id"])
    @get_plays_by_top_10_platforms_by_category = MembersController.get_plays_by_top_10_platforms_by_category(params["id"])
    @get_plays_by_dayofweek = MembersController.get_plays_by_dayofweek(params["id"])
    render 'admins/users/profile'
  end
end
