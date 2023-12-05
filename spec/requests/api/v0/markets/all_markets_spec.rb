require "rails_helper"

RSpec.describe 'All Markets API' do
  describe "All Markets API" do
      it "sends a list of all the markets" do
        create_list(:market, 3)

        get "/api/v0/markets"
      
        
        expect(response).to be_successful
        expect(response.status).to eq(200)

        markets = JSON.parse(response.body, symbolize_names: true)
        expect(markets.count).to eq(3)

        markets.each do |market|
          expect(market).to have_key(:name)
          expect(market[:name]).to be_an(String)

          expect(market).to have_key(:street)
          expect(market[:street]).to be_a(String)

          expect(market).to have_key(:city)
          expect(market[:city]).to be_a(String)

          expect(market).to have_key(:county)
          expect(market[:county]).to be_a(String)

          expect(market).to have_key(:state)
          expect(market[:state]).to be_a(String)

          expect(market).to have_key(:zip)
          expect(market[:zip]).to be_an(String)

          expect(market).to have_key(:lat)
          expect(market[:lat]).to be_an(String)

          expect(market).to have_key(:lon)
          expect(market[:lon]).to be_an(String)
        end
      end

      it 'it displays the attribute vendor_count' do
        create_list(:market, 3)

        get "/api/v0/markets"
      
        
        expect(response).to be_successful
        expect(response.status).to eq(200)

        markets = JSON.parse(response.body, symbolize_names: true)
        expect(markets.count).to eq(3)

        markets.each do |market|


        end
      end

      xit "can get one book by its id" do
        id = create(:book).id

        get "/api/v1/books/#{id}"

        book = JSON.parse(response.body, symbolize_names: true)

        expect(response).to be_successful

        expect(book).to have_key(:id)
        expect(book[:id]).to be_an(Integer)

        expect(book).to have_key(:title)
        expect(book[:title]).to be_a(String)

        expect(book).to have_key(:author)
        expect(book[:author]).to be_a(String)

        expect(book).to have_key(:genre)
        expect(book[:genre]).to be_a(String)

        expect(book).to have_key(:summary)
        expect(book[:summary]).to be_a(String)

        expect(book).to have_key(:number_sold)
        expect(book[:number_sold]).to be_an(Integer)
      end

      xit "can create a new book" do
        book_params = ({
                        title: "Murder on the Orient Express",
                        author: "Agatha Christie",
                        genre: "mystery",
                        summary: "Filled with suspense",
                        number_sold: 432
                      })
        headers = {"CONTENT_TYPE" => "application/json"}
        # We include this header to make sure that these params are passed 
        # as JSON rather than as plain text
        post "/api/v1/books", headers: headers, params: JSON.generate(book: book_params)
        created_book = Book.last 

        expect(response).to be_successful
        expect(created_book.title).to eq (book_params[:title])
        expect(created_book.author).to eq (book_params[:author])
        expect(created_book.summary).to eq (book_params[:summary])
        expect(created_book.genre).to eq (book_params[:genre])
        expect(created_book.number_sold).to eq (book_params[:number_sold])
      end

      xit "can update an existing book" do
        id = create(:book).id
        previous_name = Book.last.title 
        book_params = { title: "Charlotte's Web" }
        headers = {"CONTENT_TYPE" => "application/json"}
        # We include this header to make sure that these params are passed 
        # as JSON rather than as plain text
        patch "/api/v1/books/#{id}", headers: headers, params: JSON.generate({book: book_params})
        book = Book.find_by(id: id)

        expect(response).to be_successful
        expect(book.title).to_not eq(previous_name)
        expect(book.title).to eq("Charlotte's Web")
      end

      xit "can destroy an book" do
        
        book = create(:book)

        expect(Book.count).to eq(1)

        delete "/api/v1/books/#{book.id}"

        expect(response).to be_successful
        expect(Book.count).to eq(0)
        expect{Book.find(book.id)}.to raise_error(ActiveRecord::RecordNotFound)
      end
      #alternative method to test the same thing
      xit "can destroy an book" do
        book = create(:book)
      
        expect{ delete "/api/v1/books/#{book.id}" }.to change(Book, :count).by(-1)
      
        expect{Book.find(book.id)}.to raise_error(ActiveRecord::RecordNotFound)
      end
  end
end