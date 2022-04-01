RSpec.describe 'find all items endpoint' do
  context 'happy path' do
    context '?name=' do
      it 'returns items that match a given name' do
        item_1 = create(:item, name: "blonde roast coffee")
        
        get '/api/v1/items/find_all?name=blonde roast coffee'

        results = JSON.parse(response.body, symbolize_names: true)

        expect(response).to have_http_status(200)

        expect(results).to have_key(:data)
        expect(results[:data]).to be_a(Array)
        expect(results[:data].count).to eq(1)

        results[:data].each do |item|
          expect(item).to have_key(:id)
          expect(item[:id]).to be_a(String)

          expect(item).to have_key(:type)
          expect(item[:type]).to eq("item")

          expect(item).to have_key(:attributes)
          expect(item[:attributes]).to be_a(Hash)

          attributes = item[:attributes]

          expect(attributes).to have_key(:name)
          expect(attributes[:name]).to be_a(String)

          expect(attributes).to have_key(:description)
          expect(attributes[:description]).to be_a(String)

          expect(attributes).to have_key(:unit_price)
          expect(attributes[:unit_price]).to be_a(Float)

          expect(attributes).to have_key(:merchant_id)
          expect(attributes[:merchant_id]).to be_a(Integer)
        end
      end

      it 'returns all items that resemble name' do
         item_1 = create(:item, name: "blonde roast coffee")
         item_2 = create(:item, name: "not coffee")

         get '/api/v1/items/find_all?name=coffee'

         results = JSON.parse(response.body, symbolize_names: true)

         expect(response).to have_http_status(200)

         expect(results).to have_key(:data)
         expect(results[:data]).to be_a(Array)
         expect(results[:data].count).to eq(2)

         results[:data].each do |item|
          expect(item).to have_key(:id)
          expect(item[:id]).to be_a(String)

          expect(item).to have_key(:type)
          expect(item[:type]).to eq("item")

          expect(item).to have_key(:attributes)
          expect(item[:attributes]).to be_a(Hash)

          attributes = item[:attributes]

          expect(attributes).to have_key(:name)
          expect(attributes[:name]).to be_a(String)

          expect(attributes).to have_key(:description)
          expect(attributes[:description]).to be_a(String)

          expect(attributes).to have_key(:unit_price)
          expect(attributes[:unit_price]).to be_a(Float)

          expect(attributes).to have_key(:merchant_id)
          expect(attributes[:merchant_id]).to be_a(Integer)
         end
      end

      it 'returns an empty array if no named matches found' do

        get '/api/v1/items/find_all?name=This'

        results = JSON.parse(response.body, symbolize_names: true)

        expect(response).to have_http_status(200)

        expect(results).to have_key(:data)
        expect(results[:data]).to eq([])
      end
    end

    context '?min_price & ?max_price' do
      it 'allows for searches based on a minimum dollar ammount' do
        item_1 = create(:item, unit_price: 9.99)
        item_2 = create(:item, unit_price: 9.98)
        item_3 = create(:item, unit_price: 5.98)

        get '/api/v1/items/find_all?min_price=5.99'

        results = JSON.parse(response.body, symbolize_names: true)

        expect(response).to have_http_status(200)

        expect(results).to have_key(:data)
        expect(results[:data]).to be_a(Array)
        expect(results[:data].count).to eq(2)

        results[:data].each do |item|
          expect(item).to have_key(:id)
          expect(item[:id]).to be_a(String)

          expect(item).to have_key(:type)
          expect(item[:type]).to eq("item")

          expect(item).to have_key(:attributes)
          expect(item[:attributes]).to be_a(Hash)

          attributes = item[:attributes]

          expect(attributes).to have_key(:name)
          expect(attributes[:name]).to be_a(String)

          expect(attributes).to have_key(:description)
          expect(attributes[:description]).to be_a(String)

          expect(attributes).to have_key(:unit_price)
          expect(attributes[:unit_price]).to be_a(Float)

          expect(attributes).to have_key(:merchant_id)
          expect(attributes[:merchant_id]).to be_a(Integer)
        end
      end

      it 'allows for searches based on a maximum dollar ammount' do
         item_1 = create(:item, unit_price: 9.99)
         item_2 = create(:item, unit_price: 9.98)
         item_3 = create(:item, unit_price: 5.98)
         item_4 = create(:item, unit_price: 1.00)
         item_5 = create(:item, unit_price: 50.00)
         
         get '/api/v1/items/find_all?max_price=4.99'

         results = JSON.parse(response.body, symbolize_names: true)

         expect(response).to have_http_status(200)

         expect(results).to have_key(:data)
         expect(results[:data]).to be_a(Array)
         expect(results[:data].count).to eq(1)

         results[:data].each do |item|
          expect(item).to have_key(:id)
          expect(item[:id]).to be_a(String)

          expect(item).to have_key(:type)
          expect(item[:type]).to eq("item")

          expect(item).to have_key(:attributes)
          expect(item[:attributes]).to be_a(Hash)

          attributes = item[:attributes]

          expect(attributes).to have_key(:name)
          expect(attributes[:name]).to be_a(String)

          expect(attributes).to have_key(:description)
          expect(attributes[:description]).to be_a(String)

          expect(attributes).to have_key(:unit_price)
          expect(attributes[:unit_price]).to be_a(Float)

          expect(attributes).to have_key(:merchant_id)
          expect(attributes[:merchant_id]).to be_a(Integer)
         end
      end

      it 'allows for seraches of both min and max dollar ammount' do
         item_1 = create(:item, unit_price: 9.99)
         item_2 = create(:item, unit_price: 9.98)
         item_3 = create(:item, unit_price: 5.98)
         item_4 = create(:item, unit_price: 1.00)
         item_5 = create(:item, unit_price: 50.00)
         
         get '/api/v1/items/find_all?min_price=5.99&max_price=50.00'

         results = JSON.parse(response.body, symbolize_names: true)

         expect(response).to have_http_status(200)

         expect(results).to have_key(:data)
         expect(results[:data].count).to eq(3)
         expect(results[:data]).to be_a(Array)

         item_data = results[:data].first

         expect(item_data).to have_key(:id)
         expect(item_data[:id]).to be_a(String)

         expect(item_data).to have_key(:type)
         expect(item_data[:type]).to eq("item")

         expect(item_data).to have_key(:attributes)
         expect(item_data[:attributes]).to be_a(Hash)

         item_attributes = item_data[:attributes]

         expect(item_attributes).to have_key(:name)
         expect(item_attributes[:name]).to be_a(String)

         expect(item_attributes).to have_key(:description)
         expect(item_attributes[:description]).to be_a(String)

         expect(item_attributes).to have_key(:unit_price)
         expect(item_attributes[:unit_price]).to eq(9.99)

         expect(item_attributes).to have_key(:merchant_id)
         expect(item_attributes[:merchant_id]).to be_a(Integer)
      end
    end
  end

  context 'sad path' do
    it 'has no matching fragment' do

      get '/api/v1/items/find_all?name=pop'

      results = JSON.parse(response.body, symbolize_names: true)

      expect(response).to have_http_status(200)

      expect(results).to have_key(:data)
      expect(results[:data]).to eq([])
    end
  end
end