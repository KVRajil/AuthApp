require 'rails_helper'

RSpec.describe 'User::Registration', type: :request do
  let!(:user) { create(:user, email: 'test.existing@gmail.com', password: 'Test@123', password_confirmation: 'Test@123') }
  let(:json_response) { response.parsed_body.with_indifferent_access }
  let!(:headers) { { ACCEPT: 'application/json', CONTENT_TYPE: 'application/json' } }

  describe 'POST /users/signup' do
    context 'Valid scenarios' do
      it 'should create a new user' do
        params = { email: 'rajil@test.com', password: 'Test@123456', password_confirmation: 'Test@123456' }
        post('/users/signup', headers: headers, params: params.to_json)
        expect(response).to have_http_status(:created)
      end
    end

    context 'Invalid scenarios' do
      it 'should fail to create the user with existing mail id' do
        params = { email: 'test.existing@gmail.com', password: 'Test@123456', password_confirmation: 'Test@123456' }
        post('/users/signup', headers: headers, params: params.to_json)
        expect(response).to have_http_status(:unprocessable_entity)
        expect(json_response['error']).to eql('Email has already been taken')
      end

      it 'should fail to create the user with weak password' do
        params = { email: 'test2@gmail.com', password: 'Test123456', password_confirmation: 'Test123456' }
        post('/users/signup', headers: headers, params: params.to_json)
        expect(response).to have_http_status(:unprocessable_entity)
        expect(json_response['error']).to eql('Password must include at least 8 characters, one digit, one lowercase letter, one uppercase letter, and one special character.')
      end

      it 'should fail to create the user when password and password_confirmation does not match' do
        params = { email: 'test2@gmail.com', password: 'Test@123456', password_confirmation: 'Test@123456789' }
        post('/users/signup', headers: headers, params: params.to_json)
        expect(response).to have_http_status(:unprocessable_entity)
        expect(json_response['error']).to eql("Password confirmation doesn't match Password")
      end
    end
  end
end
