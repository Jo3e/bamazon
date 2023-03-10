class Api::V1::BooksController < ApplicationController
  # constants
  MAX_PAGINATION_LIMIT = 100

  def index
    books = Book.limit(limit).offset(params[:offset])

    render json: BooksRepresenter.new(books).as_json
  end

  def create
    # binding.irb
    author = Author.create!(author_params)
    # since i cannot merge an object to a hash on new, i will pass author_id to the hash
    @book = Book.new(book_params.merge(author_id: author.id))

    if @book.save
      render json: BookRepresenter.new(@book).as_json, status: :created
    else
      render json: @book.errors, status: :unprocessable_entity
    end
  end

  def destroy
    Book.find(params[:id]).destroy!
    head :no_content
  end

  private

    def limit
      [
        params.fetch(:limit, MAX_PAGINATION_LIMIT).to_i,
        MAX_PAGINATION_LIMIT
      ].min
    end
    
    def author_params
      params.require(:author).permit(:first_name, :last_name, :age)
    end

    def book_params
      params.require(:book).permit(:title)
    end
end
