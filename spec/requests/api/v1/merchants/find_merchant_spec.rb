require 'rails_helper'

RSpec.describe 'find a merchant endpoint' do
  context 'happy path' do
    it 'returns a single merchant' do
      merchant1 = create(:merchant, name: 'Bob Belcher')
      merchant2 = create(:merchant, name: 'Bob Vance')

      get '/api/v1/merchants/find?name=Bob Belcher'

      results = JSON.parse(response.body, symbolize_names: true)

      expect(response).to have_http_status(200)

      expect(results).to have_key(:data)
      expect(results[:data].count).to eq(3)

      results_data = results[:data]

      expect(results_data).to have_key(:id)
      expect(results_data[:id]).to be_a(String)

      expect(results_data).to have_key(:type)
      expect(results_data[:type]).to eq('merchant')

      expect(results_data).to have_key(:attributes)
      expect(results_data[:attributes]).to be_a(Hash)

      merchant = results_data[:attributes]

      expect(merchant).to have_key(:name)
      expect(merchant[:name]).to eq('Bob Belcher')
    end

    it 'returns the alphabetically first object in the database if multiple matches found' do
      merchant1 = create(:merchant, name: 'Bob Belcher')
      merchant2 = create(:merchant, name: 'Bob Vance')

      get '/api/v1/merchants/find?name=Bob'

      results = JSON.parse(response.body, symbolize_names: true)

      expect(response).to have_http_status(200)

      expect(results).to have_key(:data)
      expect(results[:data].count).to eq(3)

      results_data = results[:data]

      expect(results_data).to have_key(:id)
      expect(results_data[:id]).to be_a(String)

      expect(results_data).to have_key(:type)
      expect(results_data[:type]).to eq('merchant')

      expect(results_data).to have_key(:attributes)
      expect(results_data[:attributes]).to be_a(Hash)

      merchant = results_data[:attributes]

      expect(merchant).to have_key(:name)
      expect(merchant[:name]).to eq('Bob Belcher')
    end

  end

  context 'sad path' do
    it 'returns successful but w/o results if nothing matches' do

      get '/api/v1/merchants/find?name=nada'

      results = JSON.parse(response.body, symbolize_names: true)

      expect(response).to have_http_status(200)

      expect(results).to have_key(:data)
      expect(results[:data]).to eq({})
    end
  end
end