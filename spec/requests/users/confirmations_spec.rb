require 'rails_helper'

RSpec.describe 'User::Confirmation', type: :request do
  let!(:user) { create(:user, email: 'test@gmail.com', password: 'Test@123', password_confirmation: 'Test@123') }
  let(:json_response) { response.parsed_body.with_indifferent_access }
  let!(:headers) { { ACCEPT: 'application/json', CONTENT_TYPE: 'application/json' } }

  describe 'GET #show' do
    context 'Valid scenarios' do
      it 'confirms the email' do
        get("/users/confirmations/#{user.confirmation_token}", headers: headers)

        expect(response).to have_http_status(:ok)
        expect(user.reload.email_confirmed_at).to be_present
        expect(user.reload.confirmation_token).to be_nil
        expect(json_response['message']).to eq('Email successfully confirmed')
      end
    end

    context 'Invalid scenarios' do
      it 'returns an error response' do
        token = 'invalid_token'
        get("/users/confirmations/#{token}", headers: headers)
        expect(response).to have_http_status(:unprocessable_entity)
        expect(json_response['error']).to eq('Invalid confirmation link')
      end
    end
  end

  describe 'POST #create' do
    context 'Valid scenarios' do
      it 'resends the email confirmation' do
        params = { email: 'test@gmail.com', password: 'Test@123' }
        post('/users/confirmations', headers: headers, params: params.to_json)

        expect(response).to have_http_status(:ok)
        expect(json_response['message']).to eq('Confirmation email sent.')
      end
    end

    context 'Invalid scenarios' do
      it 'returns an error response' do
        params = { email: 'test@gmail.com', password: 'wrong password' }
        post('/users/confirmations', headers: headers, params: params.to_json)
        expect(response).to have_http_status(:not_found)
        expect(json_response['error']).to eq('Invalid email id or password')
      end
    end
  end
end
