class SubjectsController < ApplicationController
  def index
    @subjects = Subject.all
  end

  def show
    @subject = Subject.find(params[:id])
    @books = @subject.books.page(params[:page]).per(12)
  end
end