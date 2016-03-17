module PagesHelper
  def book_pages_path(book)
    book_custom_page_index_path book
  end

  def book_page_path(book, page)
    book_custom_page_path book, page.order
  end
end
