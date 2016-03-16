class Book < ActiveRecord::Base
  self.primary_key = "name"
  has_many :pages
end
