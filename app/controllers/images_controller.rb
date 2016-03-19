class ImagesController < ApplicationController
  before_action :set_params

  def thumbnail
    @page.update(thumbnail: to_thumbnail(@image.data))
    respond_to do |format|
      format.json { render json: {data: @image.data } }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_params
      @book = Book.find(params[:book_id])
      @page = @book.pages.find_by(order: params[:page_order])
      @image = @page.images.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def image_params
      params.require(:image).permit(:data)
    end
    def to_thumbnail(binary)
      raw = Base64.decode64(binary)
      original = Magick::Image.from_blob(raw).first
      image = original.resize_to_fill(500, 710)
      binary = Base64.encode64(image.to_blob)
      return binary
    end
end
