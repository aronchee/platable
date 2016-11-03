module Filterable
	extend ActiveSupport::Concern

	class_methods do
		def filter(filtering_params)
			results = self.where(nil)
			filtering_params.each do |k, v|
				results = results.public_send(k, v) if v.present?
			end
			results
		end
	end
end