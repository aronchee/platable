module ApplicationHelper
	def current_path
		array = request.fullpath.split('/')
		if array.size > 3
			return array[3]
		elsif array.size > 1
			return array[1]
		else
			return ""
		end
	end
end
