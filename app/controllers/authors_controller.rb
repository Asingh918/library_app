class AuthorsController < ApplicationController
  def index
    @authors = Author.all.page(params[:page]).per(20)
  end

  def show
    @author = Author.includes(:books).find(params[:id])
  end
end