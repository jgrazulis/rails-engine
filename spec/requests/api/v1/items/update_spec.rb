require 'rails_helper'

RSpec.describe 'the item update endpoints' do
  context 'happy path' do
    it 'allows for an item to be edited' do
      merchant_1 = create(:merchant, name: Faker::FunnyName.name)
      item = create(:item, merchant: merchant_1)

      item_name = Item.last.name

      item_params = {name: Faker::Coffee.blend_name}
      headers = {'CONTENT_TYPE' => 'application/json'}

      patch api_v1_item_path(item.id), headers: headers, params: JSON.generate(item: item_params)

      result = Item.find_by(id: item.id)

      expect(response).to have_http_status(200)
      expect(result.name).to_not eq(item_name)
    end
  end

  context 'sad path' do
    it 'gives 400 error if update is invalid' do
      merchant_1 = create(:merchant, name: Faker::FunnyName.name)
      item = create(:item, merchant: merchant_1)

      item_name = Item.last.name

      item_params = {name: 30}
      headers = {'CONTENT_TYPE' => 'application/json'}

      patch api_v1_item_path(item.id), headers: headers, params: JSON.generate(item: item_params)

      result = Item.find_by(id: item.id)

      expect(response).to have_http_status(404)
      expect(result.name).to eq(item_name)
    end
  end
end