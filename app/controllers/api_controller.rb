require 'uri'
require 'net/https'
require 'net/http'
require 'json'
class ApiController < ApplicationController

  def validate_web
    @data = {
        'user[login]' => params[:username],
        'user[password]' => params[:password],
    }
    uri = URI.parse("https://plex.tv/users/sign_in.json")
    https = Net::HTTP.new(uri.host,uri.port)
    https.use_ssl = true
    req = Net::HTTP::Post.new(uri.request_uri)
    req.set_form_data(@data)
    req['X-Plex-Product'] = 'Plex Web'
    req['X-Plex-Version'] = '2.1.3'
    req['X-Plex-Client-Identifier'] = params[:username]
    res = https.request(req)
    if res.code == "201"
      result = {"status" => "ok"}
      body = JSON.parse(res.body)
      puts body
      if Member.exists?(user_id: body["user"]["id"],is_permit: true)
        member = Member.find_by(user_id: body["user"]["id"])
        sign_in(:member,member)
        session[:thumb] = member.thumb = body["user"]["thumb"]
        session[:username] = member.username = body["user"]["username"]
        session[:email] = member.email = body["user"]["email"]
        member.save
        redirect_to :main
      else
        @result = {"status" => "Unauthorized", "message" => "Contact Administrator"}
        render :template => 'logins/index'
      end
    elsif res.code == "401"
      @result = {"status" => "Unauthorized", "message" => "Contact Administrator"}
      render :template => 'logins/index'
    else
      @result = {"status" => "error", "error" => res.code, "message" => "Error in Server"}
      render :template => 'logins/index'
    end
  end

  def request_server_api
    url = "http://178.63.89.75:8181/api/v2?apikey=59b31b7cd7546c870a35474925f27850&cmd=#{params["command"]}"
    if params["user_id"]
      user_id = params["user_id"]
      url = "#{url}&user_id=#{user_id}"
    end
    uri = URI.parse(url)
    req = Net::HTTP::Get.new(uri.to_s)
    res = Net::HTTP.start(uri.host, uri.port) { |http|
      http.request(req)
    }
    render json: res.body
  end

  def self.request_api(command, user_id = nil)
    url = "http://178.63.89.75:8181/api/v2?apikey=59b31b7cd7546c870a35474925f27850&cmd=#{command}"
    if user_id
      url = "#{url}&user_id=#{user_id}"
    end
    uri = URI.parse(url)
    req = Net::HTTP::Get.new(uri.to_s)
    res = Net::HTTP.start(uri.host, uri.port) { |http|
      http.request(req)
    }
    render json: res.body
  end

  def self.request_gps_ip(ip)
    url = "http://178.63.89.75:8181/api/v2?apikey=59b31b7cd7546c870a35474925f27850&cmd=get_geoip_lookup&ip_address=#{ip}"
    uri = URI.parse(url)
    req = Net::HTTP::Get.new(uri.to_s)
    res = Net::HTTP.start(uri.host, uri.port) { |http|
      http.request(req)
    }
    render json: res.body

  end
end
