class SearchesController < ApplicationController
  def index
    @searches = Search.select(:query).distinct
  end
end
