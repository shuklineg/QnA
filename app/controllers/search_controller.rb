class SearchController < ApplicationController
  def find
    authorize! :read, Search
    @search = search_params.empty? ? Search.new : Search.find(search_params)
  end

  private

  def search_params
    params[:search] ? params.require(:search).permit(:query, indices: []) : {}
  end
end
