require 'json'
require 'net/http'
require 'uri'

class ReposController < ActionController::Base
	def index
		if params[:search_user].present? || params[:search_org].present?
			begin
				@names = []

				@uri = if params[:commit] == 'Search User'
					   		URI.parse("https://api.github.com/users/#{params[:search_user]}/repos")
					   elsif params[:commit] == 'Search Organization'
							URI.parse("https://api.github.com/orgs/#{params[:search_org]}/repos")
					   end

				request = Net::HTTP::Get.new(@uri)
				req_options = {  use_ssl: @uri.scheme == 'https' }
				response = Net::HTTP.start(@uri.hostname, @uri.port, req_options) do |http|
				    http.request(request)
				end

				JSON.parse(response.body).map{ |res| @names << res['name'] } if response.code == '200'
				
			rescue URI::InvalidURIError
				@names = []
			end
		end
	end
end
