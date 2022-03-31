require 'rails_helper'

describe "Items endpoints" do
  it "sends a list of items" do
    merchants = create_list(:merchant, 3)

    merchants.each do |merchant|
      merchant.items.create!(name: Faker::Coffee.blend_name, description: Faker::Coffee.notes, unit_price: Faker::Number.decimal)
      merchant.items.create!(name: Faker::Coffee.blend_name, description: Faker::Coffee.notes, unit_price: Faker::Number.decimal)
    end

    get '/api/v1/items'

    expect(response).to be_successful

    items = JSON.parse(response.body, symbolize_names: true)

    expect(items[:data].count).to eq(6)

    items[:data].each do |item|
      expect(item).to have_key(:type)
      expect(item[:type]).to eq("item")

      expect(item).to have_key(:attributes)
      expect(item[:attributes]).to be_a(Hash)

      expect(item).to have_key(:id)
      expect(item[:id]).to be_a(String)

      expect(item[:attributes]).to have_key(:name)
      expect(item[:attributes][:name]).to be_a(String)

      expect(item[:attributes]).to have_key(:description)
      expect(item[:attributes][:description]).to be_a(String)

      expect(item[:attributes]).to have_key(:unit_price)
      expect(item[:attributes][:unit_price]).to be_a(Float)

      expect(item[:attributes]).to have_key(:merchant_id)
      expect(item[:attributes][:merchant_id]).to be_an(Integer)
    end
  end

  it "can create an item" do
    merchant_id = create(:merchant).id
    item_params = ({
                    name: 'new item',
                    description: 'this is a new item',
                    unit_price: 9.99,
                    merchant_id: merchant_id
      })
    headers = {"CONTENT_TYPE" => "application/json"}

    post "/api/v1/items", headers: headers, params: JSON.generate(item: item_params)
    created_item = Item.last

    expect(response).to be_successful
    expect(created_item.name).to eq(item_params[:name])
    expect(created_item.description).to eq(item_params[:description])
    expect(created_item.unit_price).to eq(item_params[:unit_price])
    expect(created_item.merchant_id).to eq(item_params[:merchant_id])
  end
end