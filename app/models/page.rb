require "uri"

class Page < ActiveRecord::Base
  belongs_to :book
  has_many :images
  has_many :orders
  has_many :images, through: :orders

end

