require 'spec_helper'

describe Grapi::PasswordsAPI do
  include Rack::Test::Methods

  def app
    Grapi::API
  end

  let(:result) { JSON.parse(last_response.body) }

  describe "POST #create" do
    context "when all is ok" do
      it "sends password email" do
        user = FactoryGirl.create(:user)
        post '/passwords', email: user.email 
      end
    end

    context "when don't send email" do
      before do
        post '/passwords' 
      end

      it "returns 422 Http status code" do
        expect(last_response.status).to eq(422)
      end

      it "returns password_token error" do
        expect(result['errors']['email']).to be_include('blank')
      end
    end

    context "when send invalid email" do
      before do
        post '/passwords', email: 'invalid'
      end

      it "returns 422 Http status code" do
        expect(last_response.status).to eq(422)
      end

      it "returns password_token error" do
        expect(result['errors']['email']).to be_include('invalid')
      end
    end
  end

  describe "PUT #update" do
    before do
      @user = FactoryGirl.create(:user)
      @user.send_reset_password
    end

    context "when all is ok" do
      before do
        put '/passwords', data: {
          password: 'new_password',
          password_confirmation: 'new_password',
          reset_password_token: @user.reset_password_token }
      end

      it "returns 204 Http status code" do
        expect(last_response.status).to eq(204)
      end

      it "updates password" do
        @user.reload
        expect(@user.encrypted_password).to eq(User.encrypt_password('new_password'))
      end
    end

    context "when don't send email" do
      before do
        post '/passwords' 
      end

      it "returns 422 Http status code" do
        expect(last_response.status).to eq(422)
      end

      it "returns password_token error" do
        expect(result['errors']['email']).to be_include('blank')
      end
    end

    context "when send invalid email" do
      before do
        post '/passwords', email: 'invalid'
      end

      it "returns 422 Http status code" do
        expect(last_response.status).to eq(422)
      end

      it "returns password_token error" do
        expect(result['errors']['email']).to be_include('invalid')
      end
    end
  end
end
