require "rails_helper"

RSpec.describe 'Vendors API endpoints' do
  describe "/api/v0/vendors/:id" do
    it "sends a list of all the vendors and their attributes" do
      vendor_id = create(:vendor).id

      get "/api/v0/vendors/#{vendor_id}"
      
      expect(response).to be_successful
      expect(response.status).to eq(200)
      
      parse = JSON.parse(response.body, symbolize_names: true)
      
      vendor = parse[:data]
    #  require 'pry';binding.pry
      expect(vendor[:attributes]).to have_key(:name)
      expect(vendor[:attributes][:name]).to be_an(String)

      expect(vendor[:attributes]).to have_key(:description)
      expect(vendor[:attributes][:description]).to be_a(String)

      expect(vendor[:attributes]).to have_key(:contact_name)
      expect(vendor[:attributes][:contact_name]).to be_a(String)

      expect(vendor[:attributes]).to have_key(:contact_phone)
      expect(vendor[:attributes][:contact_phone]).to be_a(String)

      expect(vendor[:attributes]).to have_key(:credit_accepted)
      expect(vendor[:attributes][:credit_accepted]).to eq(true).or eq(false)
    
    end

    it "returns an error when given an :id that doesn't exist" do
      get "/api/v0/vendors/123123123123"
      
      expect(response).to_not be_successful
      
      expect(response.status).to eq(404)
      
      vendor = JSON.parse(response.body, symbolize_names: true)
      
      expect(vendor).to have_key(:errors)
      # require 'pry';binding.pry
      expect(vendor[:errors]).to be_a(Hash)

      expect(vendor[:errors][:detail]).to eq("Couldn't find Vendor with 'id'=123123123123")
      expect(vendor[:errors][:detail]).to be_a(String)
    end
  end

  describe "POST /api/v0/vendors" do
    it "can create a new vendor" do
      vendor_params = ({
                      name: "Pretzel King",
                      description: "The king of pretzels, simple as.",
                      contact_name: "Petey Pretzel",
                      contact_phone: "555-505-5554",
                      credit_accepted: true
                    })
      headers = {"CONTENT_TYPE" => "application/json"}
      # We include this header to make sure that these params are passed 
      # as JSON rather than as plain text
      post "/api/v0/vendors", headers: headers, params: JSON.generate(vendor: vendor_params)
      created_vendor = Vendor.last 

      expect(response).to be_successful
      expect(response.status).to eq(201)
      expect(created_vendor.name).to eq (vendor_params[:name])
      expect(created_vendor.description).to eq (vendor_params[:description])
      expect(created_vendor.contact_phone).to eq (vendor_params[:contact_phone])
      expect(created_vendor.contact_name).to eq (vendor_params[:contact_name])
      expect(created_vendor.credit_accepted).to eq (vendor_params[:credit_accepted])
    end

    it "returns an error if vendor creation does not have all required feilds filled" do
      vendor_params = ({
                      name: "Pretzel King",
                      description: "The king of pretzels, simple as.",
                      credit_accepted: true
                    })
      headers = {"CONTENT_TYPE" => "application/json"}
      # We include this header to make sure that these params are passed 
      # as JSON rather than as plain text
      post "/api/v0/vendors", headers: headers, params: JSON.generate(vendor: vendor_params)
      created_vendor = Vendor.last 

      expect(response).to_not be_successful
      
      expect(response.status).to eq(400)
      vendor = JSON.parse(response.body, symbolize_names: true)
      
      # require 'pry';binding.pry
      expect(vendor).to have_key(:errors)
      expect(vendor[:errors]).to be_a(Array)
      
      expect(vendor[:errors][0][:detail]).to eq("Validation failed: Contact name can't be blank, Contact phone can't be blank")
      expect(vendor[:errors][0][:detail]).to be_a(String)
    end
  end

  describe "PATCH /api/v0/vendors/:id" do
    it "sends a list of all the vendors and their attributes" do
      vendor = create(:vendor,
                      name: "Pretzel King",
                      description: "The king of pretzels, simple as.",
                      contact_name: "Petey Pretzel",
                      contact_phone: "555-505-5554",
                      credit_accepted: true
                    )
      vendor_id = vendor.id

      get "/api/v0/vendors/#{vendor_id}"
      
      parse = JSON.parse(response.body, symbolize_names: true)
      
      vendor_parse = parse[:data][:attributes]
      #  require 'pry';binding.pry
      expect(vendor_parse[:name]).to eq("Pretzel King")
      expect(vendor_parse[:credit_accepted]).to eq(true)

      patch "/api/v0/vendors/#{vendor_id}", params: {vendor: {name: "Pretzel Lord", credit_accepted: false }}

      parse_update = JSON.parse(response.body, symbolize_names: true)
      vendor_update = parse_update[:data][:attributes]

      expect(vendor_update[:name]).to eq("Pretzel Lord")
      expect(vendor_update[:credit_accepted]).to eq(false)
    end

    it "can't update a vendor :id that doesn't exist" do
      patch "/api/v0/vendors/123123123123"
      
      expect(response).to_not be_successful
      
      expect(response.status).to eq(404)
      
      vendor = JSON.parse(response.body, symbolize_names: true)
      
      expect(vendor).to have_key(:errors)
      # require 'pry';binding.pry
      expect(vendor[:errors]).to be_a(Hash)

      expect(vendor[:errors][:detail]).to eq("Couldn't find Vendor with 'id'=123123123123")
      expect(vendor[:errors][:detail]).to be_a(String)
    end
  end

  describe "DELETE /api/v0/vendors/:id" do
    it "sends a list of all the vendors and their attributes" do
      vendor = create(:vendor,
                      name: "Pretzel King",
                      description: "The king of pretzels, simple as.",
                      contact_name: "Petey Pretzel",
                      contact_phone: "555-505-5554",
                      credit_accepted: true
                    )
      vendor_id = vendor.id

      get "/api/v0/vendors/#{vendor_id}"
      
      parse = JSON.parse(response.body, symbolize_names: true)
      
      vendor_parse = parse[:data][:attributes]
      #  require 'pry';binding.pry
      expect(vendor_parse[:name]).to eq("Pretzel King")
      expect(vendor_parse[:description]).to eq ("The king of pretzels, simple as.")
      expect(vendor_parse[:contact_name]).to eq ("Petey Pretzel")
      expect(vendor_parse[:contact_phone]).to eq ("555-505-5554")
      expect(vendor_parse[:credit_accepted]).to eq(true)

      delete "/api/v0/vendors/#{vendor_id}"

      expect(response).to be_successful
      expect(response.status).to eq(204)
    end

    it "can't update a vendor :id that doesn't exist" do
      delete "/api/v0/vendors/123123123123"
      
      expect(response).to_not be_successful
      
      expect(response.status).to eq(404)
      
      vendor = JSON.parse(response.body, symbolize_names: true)
      
      expect(vendor).to have_key(:errors)
      # require 'pry';binding.pry
      expect(vendor[:errors]).to be_a(Hash)

      expect(vendor[:errors][:detail]).to eq("Couldn't find Vendor with 'id'=123123123123")
      expect(vendor[:errors][:detail]).to be_a(String)
    end
  end
end