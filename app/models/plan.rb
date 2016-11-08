class Plan < ActiveRecord::Base
	belongs_to :user
	belongs_to :recipe
	validates_uniqueness_of :recipe_id, :scope => [:date]
end
