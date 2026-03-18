class BooksController < ApplicationController
  def index
    @books = Book.includes(:authors, :subject)

    if params[:search].present?
      @books = @books.where("title LIKE ?", "%#{params[:search]}%")
    end

    if params[:subject_id].present?
      @books = @books.where(subject_id: params[:subject_id])
    end

    @books = @books.page(params[:page]).per(12)
    @subjects = Subject.all
  end

  def show
    @book = Book.includes(:authors, :reviews, :subject).find(params[:id])
  end
end