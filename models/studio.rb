class Studio < ActiveRecord::Base
  validates :name, presence: true
end