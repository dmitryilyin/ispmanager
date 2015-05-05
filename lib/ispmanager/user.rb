class ISPManager::User < ISPManager::Base
	def all
		request 'user'
	end

	def edit params
		action 'user.edit', params
	end
end
