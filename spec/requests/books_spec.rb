require "rails_helper"

describe "Books API", type: :request do

    describe 'GET /books' do
      before do
        FactoryBot.create(:book, title: 'The Elf', author: 'George Welk')
        FactoryBot.create(:book, title: 'The Time Machine', author: 'H.G Wells')
      end

      it "returns all books" do
          get "/api/v1/books"

          expect(response).to have_http_status(:success)
          expect(JSON.parse(response.body).size).to eq(2)
      end
    end

    describe 'POST /books' do
        it 'create a new book' do
          # ensure the db records increased
            expect {
              post "/api/v1/books", params: { book: { title: 'A Man Called Ove', author: 'Fredrik Backman' } }
            }.to change { Book.count }.from(0).to(1)
          # confirm that the book is created
            expect(response).to have_http_status(:created)
        end
        
    end

    describe 'DELETE /books/:id' do
        let!(:book) { FactoryBot.create(:book, title: 'The Elf', author: 'George Welk') }
        
        it 'deletes a book' do
          #   assertions
          expect {
              delete "/api/v1/books/#{ book.id }"
          }.to change { Book.count }.from(1).to(0)
          expect(response).to have_http_status(:no_content)
        end
        
    end
end