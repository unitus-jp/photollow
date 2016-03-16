class ImagesController < ApplicationController
  before_action :set_params

  def thumbnail
    @page.update(thumbnail: @image.data)
    respond_to do |format|
      format.json { render json: {data: @image.data } }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_params
      @book = Book.find(params[:book_id])
      @page = @book.pages.find(params[:page_id])
      @image = @page.images.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def image_params
      params.require(:image).permit(:data)
    end

end
