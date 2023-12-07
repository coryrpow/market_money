require "rails_helper"

RSpec.describe 'MarketVendor API endpoints' do
  describe "POST /api/v0/market_vendors" do
    it "creates a new association between a market and vendor in the market_vendor" do
      market_id = create(:market).id
      vendor_id = create(:vendor).id

      post "/api/v0/market_vendors", params: { market_id: market_id, vendor_id: vendor_id }
      # require 'pry';binding.pry
      expect(response).to be_successful
      expect(response.status).to eq(201)
      
      get "/api/v0/markets/#{market_id}/vendors"

      expect(response).to be_successful
      expect(response.status).to eq(200)

      parse = JSON.parse(response.body, symbolize_names: true)
      vendor = parse[:data][0][:attributes]
    # need to add testing that checks specific name but this is a start at least

      expect(vendor).to have_key(:name)
      expect(vendor[:name]).to be_an(String)

      expect(vendor).to have_key(:description)
      expect(vendor[:description]).to be_a(String)

      expect(vendor).to have_key(:contact_name)
      expect(vendor[:contact_name]).to be_a(String)

      expect(vendor).to have_key(:contact_phone)
      expect(vendor[:contact_phone]).to be_a(String)

      expect(vendor).to have_key(:credit_accepted)
      expect(vendor[:credit_accepted]).to eq(true).or eq(false)
   
    end

    it "returns an error when given an :id that doesn't exist" do
      get "/api/v0/vendors/123123123123"
      
      expect(response).to_not be_successful
      
      expect(response.status).to eq(404)
      
      vendor = JSON.parse(response.body, symbolize_names: true)
      
      expect(vendor).to have_key(:errors)
      # require 'pry';binding.pry
      expect(vendor[:errors]).to be_a(Array)

      expect(vendor[:errors].first[:detail]).to eq("Couldn't find Vendor with 'id'=123123123123")
      expect(vendor[:errors].first[:detail]).to be_a(String)
    end

    xit "returns an error when given an :id that ALREADY exists" do
  #     {
  #      "market_id": 322474, 
  #      "vendor_id": 54861 
  #  }
  #  (where 322474 and 54861 are valid market and vendor id's, 
  #  but an existing MarketVendor with those values already exists.)

      vendor = create(:vendor,
                      name: "Pretzel King",
                      description: "The king of pretzels, simple as.",
                      contact_name: "Petey Pretzel",
                      contact_phone: "555-505-5554",
                      credit_accepted: true
                    )
      vendor_id = vendor.id

      market = create(:market,
                      name: "Pretzel King",
                      street: "The king of pretzels, simple as.",
                      city: "Petey Pretzel",
                      county: "555-505-5554",
                      state: true
                    )
      market_id = market.id
      get "/api/v0/vendors/123123123123"
      
      expect(response).to_not be_successful
      
      expect(response.status).to eq(422)
      
      vendor = JSON.parse(response.body, symbolize_names: true)
      
      expect(vendor).to have_key(:errors)
      # require 'pry';binding.pry
      expect(vendor[:errors]).to be_a(Hash)

      expect(vendor[:errors][:detail]).to eq("Couldn't find Vendor with 'id'=123123123123")
      expect(vendor[:errors][:detail]).to be_a(String)
    end
  end
end
