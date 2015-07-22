require 'spec_helper'

describe Grapi::ConfirmationsAPI do
  include Rack::Test::Methods

  def app
    Grapi::API
  end

  let(:result) { JSON.parse(last_response.body) }

  describe "GET #show" do
    context "when send valid confirmation token" do
      it "confirms user" do
        user = FactoryGirl.create(:user_unconfirmed)
        get '/confirmations', confirmation_token: user.confirmation_token 
        expect(user.reload.confirmed_at).not_to eq(nil)
      end
    end

    context "when don't send confirmation token" do
      before do
        get '/confirmations' 
      end

      it "returns 422 Http status code" do
        expect(last_response.status).to eq(422)
      end

      it "returns confirmation_token error" do
        expect(result['errors']['confirmation_token']).to be_include('blank')
      end
    end

    context "when send invalid confirmation token" do
      before do
        get '/confirmations', confirmation_token: 'invalid'
      end

      it "returns 422 Http status code" do
        expect(last_response.status).to eq(422)
      end

      it "returns confirmation_token error" do
        expect(result['errors']['confirmation_token']).to be_include('invalid')
      end
    end
  end

  describe "POST #create" do
    context "when all is ok" do
      it "sends confirmation email" do
        user = FactoryGirl.create(:user)
        post '/confirmations', email: user.email 
        expect(Grapi::Mail.last_email.class).to eq(ConfirmationInstructionsMail)
      end
    end

    context "when don't send email" do
      before do
        post '/confirmations' 
      end

      it "returns 422 Http status code" do
        expect(last_response.status).to eq(422)
      end

      it "returns confirmation_token error" do
        expect(result['errors']['email']).to be_include('blank')
      end
    end

    context "when send invalid email" do
      before do
        post '/confirmations', email: 'invalid'
      end

      it "returns 422 Http status code" do
        expect(last_response.status).to eq(422)
      end

      it "returns confirmation_token error" do
        expect(result['errors']['email']).to be_include('invalid')
      end
    end
  end
end
