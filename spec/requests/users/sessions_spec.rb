require 'rails_helper'

RSpec.describe 'User::Session', type: :request do
  let!(:user) { create(:user, email: 'test@gmail.com', password: 'Test@123', password_confirmation: 'Test@123') }
  let(:json_response) { response.parsed_body.with_indifferent_access }
  let!(:headers) do
    { 'ACCEPT' => 'application/json', 'CONTENT_TYPE' => 'application/json' }
  end
  describe 'POST #create' do
    context 'Valid scenarios' do
      it 'resends the email confirmation' do
        params = { email: 'test@gmail.com', password: 'Test@123' }
        post('/users/login', headers: headers, params: params.to_json)

        expect(response).to have_http_status(:ok)
        expect(json_response['token']).to be_present
      end
    end

    context 'Invalid scenarios' do
      it 'returns an error response' do
        params = { email: 'test@gmail.com', password: 'wrong password' }
        post('/users/login', headers: headers, params: params.to_json)

        expect(response).to have_http_status(:unauthorized)
        expect(json_response['error']).to eq('Invalid email or password')
      end
    end
  end
end
