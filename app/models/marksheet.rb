class Marksheet < ActiveRecord::Base
	belongs_to :bridge
	belongs_to :student
	belongs_to :exam
end
