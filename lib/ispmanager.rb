require 'uri'

class ISPManager
	require 'ispmanager/base'
	require 'ispmanager/domain'
	require 'ispmanager/user'
	require 'ispmanager/usermove'
	require 'ispmanager/longtask'

	def initialize params
		unless params[:url] && params[:user] && params[:password]
			raise RequireConnectionParams
		end

		params[:uri] = URI params[:url]
		@params = params
	end

	def domains
		@domains ||= ISPManager::Domain.new @params
	end

	def users
		@users ||= ISPManager::User.new @params
	end

        def usermove
                @usermove ||= ISPManager::Usermove.new @params
        end

        def longtasks
                @longtasks ||= ISPManager::Longtask.new @params
        end

	class RequireConnectionParams < StandardError
	end

	class Request
		def self.create function, params, connection
			uri = connection[:uri]
			http = Net::HTTP.new uri.host, uri.port
			http.use_ssl = true
			http.verify_mode = OpenSSL::SSL::VERIFY_NONE

			params ||= {}
			params[:authinfo] = "#{connection[:user]}:#{connection[:password]}"
			params[:out] = :json
			params[:func] = function
			query = URI.encode_www_form(params)
			url = "#{uri}/ispmgr?#{query}"
                        puts "GET: '#{url}'"
                        puts "DATA: '#{params.inspect}'"
			request = Net::HTTP::Get.new(url)
			result = http.start {|http| http.request(request) }.body
		end
	end

	class Action
		def self.create function, params, connection
			uri = connection[:uri]
			http = Net::HTTP.new uri.host, uri.port
			http.use_ssl = true
			http.verify_mode = OpenSSL::SSL::VERIFY_NONE

			params ||= {}
			params[:authinfo] = "#{connection[:user]}:#{connection[:password]}"
			params[:out] = :json
			params[:func] = function
			query = URI.encode_www_form(params)
			url = "#{uri}/ispmgr"
                        puts "POST: '#{url}'"
                        puts "DATA: '#{params.inspect}'"
			request = Net::HTTP::Post.new(url)
                        request.set_form_data(params)
			result = http.start {|http| http.request(request) }.body
		end
	end
end
