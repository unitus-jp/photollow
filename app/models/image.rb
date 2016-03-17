class Image < ActiveRecord::Base
  self.primary_key = "hashed_data"
  has_many :orders
  has_many :pages, through: :orders
end
