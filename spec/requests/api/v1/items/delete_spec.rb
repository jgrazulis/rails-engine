require 'rails_helper' 

RSpec.describe 'delete item endpoint' do
  it 'deletes an item' do
    merchant = create(:merchant)
    item = merchant.items.create(name: Faker::Coffee.blend_name, description: Faker::Coffee.notes, unit_price: Faker::Number.decimal)

    expect(Item.count).to eq(1)
    delete "/api/v1/items/#{item.id}"

    expect(response).to be_successful
    expect(Item.count).to eq(0)
    expect{Item.find(item.id)}.to raise_error(ActiveRecord::RecordNotFound)
  end
end