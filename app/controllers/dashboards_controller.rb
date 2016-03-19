class DashboardsController < ApplicationController
  def index
    @books = []
    4.times do |i|
      @books[i] = Book.all.shuffle.first(25)
    end
    @pages = []
    4.times do |i|
      @pages[i] = Page.all.shuffle.first(25)
    end
  end
end
