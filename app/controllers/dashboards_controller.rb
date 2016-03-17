class DashboardsController < ApplicationController
  def index
    @books = Book.all.shuffle.first(25)
    @pages = Page.all.shuffle.first(25)
  end
end
