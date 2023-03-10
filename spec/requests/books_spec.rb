require "rails_helper"

describe "Books API", type: :request do
  let(:first_author) { FactoryBot.create(:author, first_name: "George", last_name: "Welk", age: 46) }
  let(:second_author) { FactoryBot.create(:author, first_name: "H.G", last_name: "Wells", age: 76) }
    
    describe 'GET /books' do
      before do
        FactoryBot.create(:book, title: 'The Elf', author: first_author)
        FactoryBot.create(:book, title: 'The Time Machine', author: second_author)
      end

      it "returns all books" do
          get "/api/v1/books"

          expect(response).to have_http_status(:success)
          expect(JSON.parse(response.body).size).to eq(2)
          expect(JSON.parse(response.body)).to eq(
            [
              {
                "id" => 1,
                "title" => "The Elf",
                "author_name" => "George Welk",
                "author_age" => 46
              },
              {
                "id" => 2,
                "title" => "The Time Machine",
                "author_name" => "H.G Wells",
                "author_age" => 76
              }
            ]
          )
      end

      # Pagination implementation (limit: 1 || 2 || 10 most common)
      it 'returns a subset of books based on limit' do
        get '/api/v1/books', params: { limit: 1 }
        
        expect(response).to have_http_status(:success)
        expect(JSON.parse(response.body).size).to eq(1)
        expect(JSON.parse(response.body)).to eq(
          [
            {
              "id" => 1,
              "title" => "The Elf",
              "author_name" => "George Welk",
              "author_age" => 46
            }
          ]
        )
      end

      it 'returns a subset of books based on limit and offset' do
        get '/api/v1/books', params: { limit: 1, offset: 1 }
        
        expect(response).to have_http_status(:success)
        expect(JSON.parse(response.body).size).to eq(1)
        expect(JSON.parse(response.body)).to eq(
          [
            {
              "id" => 2,
              "title" => "The Time Machine",
              "author_name" => "H.G Wells",
              "author_age" => 76
            }
          ]
        )
      end 
    end

    # Book Create test
    describe 'POST /books' do
        it 'create a new book' do
          # ensure the db records increased
            expect {
              post '/api/v1/books', params: {
                book: {title: "The Martian"},
                author: { first_name: "Andy", last_name: "Weir", age: "48" }
              }
            }.to change { Book.count }.from(0).to(1)
            expect(response).to have_http_status(:created)
            expect(Author.count).to eq(1)
            expect(JSON.parse(response.body)).to eql(
              {
                "id" => 1,
                "title" => "The Martian",
                "author_name" => "Andy Weir",
                "author_age" => 48
              }
            )
        end
        
    end

    describe 'DELETE /books/:id' do
        let!(:book) { FactoryBot.create(:book, title: 'The Elf', author: first_author) }
        
        it 'deletes a book' do
          #   assertions
          expect {
              delete "/api/v1/books/#{ book.id }"
          }.to change { Book.count }.from(1).to(0)
          expect(response).to have_http_status(:no_content)
        end
        
    end
end