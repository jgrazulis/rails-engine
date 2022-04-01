require 'rails_helper'

RSpec.describe 'item merchant endpoint' do
  context 'happy path' do
    it 'has a given items merchant' do
      merchant_1 = create(:merchant)
      item1 = merchant_1.items.create!(name: Faker::Coffee.blend_name, description: Faker::Coffee.notes, unit_price: Faker::Number.decimal)
      
      get "/api/v1/items/#{item1.id}/merchant"
      expect(response).to be_successful
      
      merchant = JSON.parse(response.body, symbolize_names: true)
      
      expect(merchant[:data][:id]).to eq(merchant_1.id.to_s)
    end
  end
end