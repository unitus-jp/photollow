class Image < ActiveRecord::Base
  belongs_to :page
  has_many :orders
  has_many :pages, through: :orders
end
