class ISPManager::Longtask < ISPManager::Base
	def all
		request 'longtask'
	end
end
