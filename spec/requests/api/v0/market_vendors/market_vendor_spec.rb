require "rails_helper"

RSpec.describe 'MarketVendor API endpoints' do
  describe "POST /api/v0/market_vendors" do
    it "creates a new association between an existing market and vendor in the market_vendor and
    can show the vendor in the specific market's vendors get request" do
      market_id = create(:market).id
      vendor_id = create(:vendor).id

      post "/api/v0/market_vendors", params: { market_id: market_id, vendor_id: vendor_id }
      # require 'pry';binding.pry
      expect(response).to be_successful
      expect(response.status).to eq(201)
      
      get "/api/v0/markets/#{market_id}/vendors"

      expect(response).to be_successful
      expect(response.status).to eq(200)

      single_vendor = Vendor.last

      expect(single_vendor[:name]).to eq("#{single_vendor.name}")
      expect(single_vendor[:description]).to eq ("#{single_vendor.description}")
      expect(single_vendor[:contact_name]).to eq ("#{single_vendor.contact_name}")
      expect(single_vendor[:contact_phone]).to eq ("#{single_vendor.contact_phone}")
      expect(single_vendor[:credit_accepted]).to eq(single_vendor.credit_accepted)

      parse = JSON.parse(response.body, symbolize_names: true)
      vendor = parse[:data][0][:attributes]

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
      vendor_id = create(:vendor).id

      post "/api/v0/market_vendors", params: { market_id: 987654321, vendor_id: vendor_id }
      
      expect(response).to_not be_successful
      expect(response.status).to eq(404)
      
      vendor = JSON.parse(response.body, symbolize_names: true)
      
      expect(vendor).to have_key(:errors)
      expect(vendor[:errors]).to be_a(Array)

      expect(vendor[:errors].first[:status]).to eq("404")
      expect(vendor[:errors].first[:detail]).to eq("Validation failed: Market must exist")
      expect(vendor[:errors].first[:detail]).to be_a(String)
    end

    it "returns an error when given an :id for a vendor_market relationship that ALREADY exists" do
       market = create(:market,
                      name: "Bread Lord",
                      street: "Bread Lane",
                      city: "Breadsville",
                      county: "Dough",
                      state: "BO",
                      zip: "86753",
                      lat: "50",
                      lon: "50"
                    )
      market_id = market.id

      vendor = create(:vendor,
                      name: "Pretzel King",
                      description: "The king of pretzels, simple as.",
                      contact_name: "Petey Pretzel",
                      contact_phone: "555-505-5554",
                      credit_accepted: true
                    )
      vendor_id = vendor.id

      market_vendor = create(:market_vendor, market_id: market_id, vendor_id: vendor_id)

      post "/api/v0/market_vendors", params: { market_id: market_id, vendor_id: vendor_id }
  
      expect(response).to_not be_successful
      
      expect(response.status).to eq(422)
      
      vendor = JSON.parse(response.body, symbolize_names: true)
      
      expect(vendor).to have_key(:errors)
      expect(vendor[:errors]).to be_a(Array)

      expect(vendor[:errors].first[:status]).to eq("422")
      expect(vendor[:errors].first[:detail]).to eq("Validation failed: Market vendor association between market with market_id=#{market_id} and vendor_id=#{vendor_id} already exists")
      expect(vendor[:errors].first[:detail]).to be_a(String)
    end
  end
end
