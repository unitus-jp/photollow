class Image < ActiveRecord::Base
  has_many :orders
  has_many :pages, through: :orders
end
