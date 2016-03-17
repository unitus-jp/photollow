require 'open-uri'
require 'nokogiri'
require 'fastimage'
require 'uri'
require 'base64'

class PagesController < ApplicationController
  before_action :set_page, only: [:show, :edit, :update, :destroy, :sort, :add, :changename, :delete_image]
  before_action :set_book

  # GET /pages
  # GET /pages.json
  def index
    @pages = @book.pages
  end

  # GET /pages/1
  # GET /pages/1.json
  def show
    @orders = @page.orders.order("number ASC")
  end

  # GET /pages/new
  def new
    @page = Page.new
  end

  # GET /pages/1/edit
  def edit
    @orders = @page.orders.order("number ASC")
  end

  # POST /pages
  # POST /pages.json
  def create
    redirect_to new_book_page_path(@book) unless valid_url?(page_params[:url])
    order = @book.pages ? @book.pages.maximum("order").to_i + 1 : 1
    params[:page][:order] = order
    @page = Page.new(page_params)
    @page.book = @book
    charset = nil

    site_url = params[:page][:url]

    if  /.*(jpg|JPG|jpeg|JPG|gif)\z/ =~ site_url
      binary = save_and_connect_image(site_url, @page, 0)
      @page.update(thumbnail: binary)
    else
      begin
        html = open(site_url) do |f|
          charset = f.charset # 文字種別を取得
          f.read # htmlを読み込んで変数htmlに渡す
        end

      rescue OpenURI::HTTPError => error
        response = error.io
        respond_to do |format|
          format.html { redirect_to book_pages_path(@book), notice: "failed loading image" and return }
        end
      end
      doc = Nokogiri::HTML.parse(html, nil, charset)
      order = 0
      doc.css("body img").each do |img|
        url = img.attributes["src"].value
        width, height = FastImage.size(url)
        width ||= 0
        height ||= 0

        if height > params[:under_height][0].to_i && width > params[:under_width][0].to_i
          binary = save_and_connect_image(url, @page, order)
          if order == 0
            @page.update(thumbnail: binary)
          end
          order += 1
        end
      end
    end

    respond_to do |format|
      if @page.save
        format.html { redirect_to book_page_path(@book, @page), notice: 'Page was successfully created.' }
        format.json { render :show, status: :created, location: @page }
      else
        format.html { render :new }
        format.json { render json: @page.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /pages/1
  # PATCH/PUT /pages/1.json
  def update
    redirect_to edit_book_pages_path(@book, @page) unless valid_url?(page_params[:url])
    site_url = page_params[:url]

    if  /.*(jpg|JPG|jpeg|JPG|gif)\z/ =~ site_url
      @page.images.delete_all
      binary = save_and_connect_image(site_url, @page, 0)
      @page.update(thumbnail: binary)
    else
      begin
        charset = nil
        html = open(params[:page][:url]) do |f|
          charset = f.charset # 文字種別を取得
          f.read # htmlを読み込んで変数htmlに渡す
        end
      rescue OpenURI::HTTPError => error
        response = error.io
        respond_to do |format|
          format.html { redirect_to book_pages_path(@book), notice: "failed loading image" and return }
        end
      end
      @page.images.delete_all
      doc = Nokogiri::HTML.parse(html, nil, charset)
      order = 0
      doc.css("body img").each do |img|
        url = img.attributes["src"].value
        width, height = FastImage.size(url)
        width ||= 0
        height ||= 0

        if height > params[:under_height][0].to_i && width > params[:under_width][0].to_i
          binary = save_and_connect_image(url, @page, order)
          if order == 0
            @page.update(thumbnail: binary)
          end
          order += 1
        end
      end
    end

    respond_to do |format|
      if @page.update(page_params)
        format.html { redirect_to book_page_path(@book, @page), notice: 'Page was successfully updated.' }
        format.json { render :show, status: :ok, location: @page }
      else
        format.html { render :edit }
        format.json { render json: @page.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /pages/1
  # DELETE /pages/1.json
  def destroy
    @page.destroy
    @pages = @page.book.pages.sort{|a,b| a.order <=> b.order}
    @pages.each_with_index do |page, index|
      page.update(order: index+1)
    end
    respond_to do |format|
      format.html { redirect_to book_pages_url(@book), notice: 'Page was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  def sort
    @page.images.delete_all
    data = params[:order]
    data.each_with_index do |id, index|
      Order.create(page_id: @page.id, image_id: id, number: index)
    end
    respond_to do |format|
      format.json { render json: {status: "success" } }
    end
  end

  def delete_image
    @order = @page.orders.find_by(image_id: params[:image_id])
    @order.destroy
    @orders = @page.orders.order("number ASC")
  end

  def add
    # begin
      site_url = params[:url]
      if  /.*(jpg|JPG|jpeg|JPG|gif)\z/ =~ site_url
        order = params[:order].to_i
        old_orders =  @page.orders.order("number ASC")
        size = old_orders.size
        append_orders = old_orders.last(size - order)
        binary = save_and_connect_image(site_url, @page, order)
        order += 1
        append_orders.each do |new_order|
          new_order.update(number: order)
          order += 1
        end
      else
        charset = nil
        begin
          html = open(site_url) do |f|
            charset = f.charset # 文字種別を取得
            f.read # htmlを読み込んで変数htmlに渡す
          end
        rescue OpenURI::HTTPError => error
          response = error.io
          respond_to do |format|
            format.html { redirect_to book_pages_path(@book), notice: "failed loading image" and return }
          end
        end
        doc = Nokogiri::HTML.parse(html, nil, charset)
        order = params[:order].to_i
        old_orders =  @page.orders.order("number ASC")
        size = old_orders.size
        append_orders = old_orders.last(size - order)


        doc.css("body img").each do |img|
          url = img.attributes["src"].value
          width, height = FastImage.size(url)
          width ||= 0
          height ||= 0
          if height > params[:under_height].to_i && width > params[:under_width].to_i
            binary = save_and_connect_image(url, @page, order)
          end
          order += 1
        end
        append_orders.each do |new_order|
          new_order.update(number: order)
          order += 1
        end

        @orders = @page.orders.order("number ASC")
      end
    # rescue
    # end
    @orders = @page.orders.order("number ASC")
  end

  def changename
    @page.update(title: params[:name])
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_page
      @page = Page.find_by!(order: params[:order])
    end

    def set_book
      @book = Book.find(params[:book_id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def page_params
      params.require(:page).permit(:url, :title, :order)
    end

    def save_and_connect_image(url, page, order)
      @order = Order.new(number: order)
      binary = Base64.encode64(open(url).read)
      hashed_data = Digest::MD5.hexdigest(binary)
      image = Image.find_or_create_by(hashed_data: hashed_data) do |i|
        i.data = binary
      end
      image.update(data: binary) if image.data != binary

      @order.page = page
      @order.image = image
      @order.save

      return binary
    end

    def valid_url?(url)
      if url =~ URI::regexp && !url.include?(" ")
        true
      else
        false
      end
    end
end
