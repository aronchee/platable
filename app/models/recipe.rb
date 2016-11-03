class Recipe < ActiveRecord::Base
	has_one :nutrition_estimate
	has_many :ingredient_amounts
	has_many :ingredients, through: :ingredient_amounts

	validates :name, uniqueness: true

	include Filterable

	scope :location, ->(q) { includes(:city).where('cities.name ILIKE :query OR cities.country ILIKE :query', query: q).references(:cities) }
	scope :price, -> (ranges) { where(price: ranges) }
	scope :date, ->(dates) { where.not("'#{dates[:start]}' > ANY (unavailable_dates) AND '#{dates[:end]}' <= ANY (unavailable_dates)").where("min_stay <= ?", (Date.parse(date[:end]) - Date.parse(date[:start])).to_i) }
	scope :capacity, ->(q) { where(capacity: q)}
	scope :property_type, ->(types) { where(property_type: types) }
	scope :room_type, ->(types) { where(room_type: types) }

end
