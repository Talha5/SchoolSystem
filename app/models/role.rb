class Role < ActiveRecord::Base
  has_many :users
  has_many :rights
end
