class BooksController < ApplicationController
  before_action :authenticate_user!
  before_action :ensure_correct_user, only: [:edit, :update, :destroy]

  def show
    @book = Book.find(params[:id])
    @book_comment = BookComment.new
  end

  def index

    if params[:latest]
      @books = Book.latest
    elsif params[:old]
      @books = Book.old  
    elsif params[:score_count]
      @books = Book.score_count
    else  
      @books = Book.all
    end
    
    @book = Book.new
  end

  def create
    @book = Book.new(book_params)
    @book.user_id = current_user.id
    if @book.save
      redirect_to book_path(@book), notice: "You have created book successfully."
    else
      @books = Book.all
      render 'index'
    end
  end

  def edit
  end

  def update
    if @book.update(book_params)
      redirect_to book_path(@book), notice: "You have updated book successfully."
    else
      render "edit"
    end
  end

  def destroy
    @book.destroy
    redirect_to books_path
  end

  def test
  end


  def scope
    if params[:new]
      @books = Book.latest.page(params[:page]).per(PER_PAGE)
    elsif params[:old]
      @books = Book.old.page(params[:page]).per(PER_PAGE)
    # elsif params[:score]
      # books = Book.score_count
      # @books =  Kaminari.paginate_array(events).page(params[:page]).per(PER_PAGE)
    end
  end



  private

  def book_params
    params.require(:book).permit(:title, :body, :score)
  end

  def ensure_correct_user
    @book = Book.find(params[:id])
    unless @book.user == current_user
      redirect_to books_path
    end
  end
end
