require 'rails_helper'

RSpec.describe "Merchant Items endpoints" do
  it "sends a list of items for a given merchant id" do
    merchant1 = create(:merchant)
    merchant1.items.create!(name: Faker::Coffee.blend_name, description: Faker::Coffee.notes, unit_price: Faker::Number.decimal)
    merchant1.items.create!(name: Faker::Coffee.blend_name, description: Faker::Coffee.notes, unit_price: Faker::Number.decimal)
    merchant1.items.create!(name: Faker::Coffee.blend_name, description: Faker::Coffee.notes, unit_price: Faker::Number.decimal)

    merchant2 = create(:merchant)
    merchant2.items.create!(name: Faker::Esport.game, description: Faker::Esport.event, unit_price: Faker::Number.decimal)

    get "/api/v1/merchants/#{merchant1.id}/items"

    expect(response).to be_successful

    items = JSON.parse(response.body, symbolize_names: true)

    expect(items[:data].count).to eq(3)

      items[:data].each do |item|
        expect(item).to have_key(:id)
        expect(item[:id]).to be_a(String)

        expect(item[:attributes]).to have_key(:name)
        expect(item[:attributes][:name]).to be_a(String)

        expect(item[:attributes]).to have_key(:description)
        expect(item[:attributes][:description]).to be_a(String)

        expect(item[:attributes]).to have_key(:unit_price)
        expect(item[:attributes][:unit_price]).to be_a(Float)

        expect(item[:attributes]).to have_key(:merchant_id)
        expect(item[:attributes][:merchant_id]).to be_a(Integer)
        expect(item[:attributes][:merchant_id]).to eq(merchant1.id)
      end
  end
end