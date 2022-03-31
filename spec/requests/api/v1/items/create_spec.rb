require 'rails_helper'

RSpec.describe 'the create item endpoint' do
  context 'happy path' do
    it 'can create an item' do
      merchant1 = create(:merchant, name: Faker::FunnyName.name)
      merchant2 = create(:merchant, name: Faker::FunnyName.name)
      item_params = ({
        name: Faker::Coffee.blend_name,
        description: Faker::Coffee.notes,
        unit_price: Faker::Number.decimal,
        merchant_id: merchant1.id
      })
      headers = {"CONTENT_TYPE" => "application/json"}

      expect(merchant1.items.count).to eq(0)
      expect(merchant2.items.count).to eq(0)

      post api_v1_items_path, headers: headers, params: JSON.generate(item: item_params)

      new_item = JSON.parse(response.body, symbolize_names: true)

      expect(response).to have_http_status(201)

      expect(merchant1.items.count).to eq(1)
      expect(merchant2.items.count).to eq(0)

      expect(new_item).to have_key(:data)
      expect(new_item[:data]).to be_a(Hash)

      new_item_data = new_item[:data]

      expect(new_item_data).to have_key(:id)
      expect(new_item_data[:id]).to be_a(String)

      expect(new_item_data).to have_key(:type)
      expect(new_item_data[:type]).to eq('item')

      expect(new_item_data).to have_key(:attributes)
      expect(new_item_data[:attributes]).to be_a(Hash)

      new_item_attributes = new_item_data[:attributes]

      expect(new_item_attributes).to have_key(:name)
      expect(new_item_attributes[:name]).to be_a(String)

      expect(new_item_attributes).to have_key(:description)
      expect(new_item_attributes[:description]).to be_a(String)

      expect(new_item_attributes).to have_key(:unit_price)
      expect(new_item_attributes[:unit_price]).to be_a(Float)

      expect(new_item_attributes).to have_key(:merchant_id)
      expect(new_item_attributes[:merchant_id]).to eq(merchant1.id)
    end
  end

  context 'sad path' do
    it 'gives a 404 error if datatypes incorrect' do
      merchant_id = create(:merchant).id
      item_params = ({
                    name: 99,
                    description: 98,
                    unit_price: 'one',
                    merchant_id: merchant_id.to_s
      })
      headers = {"CONTENT_TYPE" => "application/json"}

      post "/api/v1/items", headers: headers, params: JSON.generate(item: item_params)

      expect(response.status).to eq(404)
    end
  end 
end