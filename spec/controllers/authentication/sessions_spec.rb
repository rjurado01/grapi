require 'spec_helper'

describe Grapi::SessionsAPI do
  include Rack::Test::Methods

  def app
    Grapi::API
  end

  before :all do
    @user = FactoryGirl.create(:user, password: '123456')
  end

  let(:result) { JSON.parse(last_response.body) }

  describe "POST #create" do
    context "when all is ok" do
      it "returns 201 http status code" do
        post "/sessions", email: @user.email, password: '123456'
        expect(last_response.status).to eq(201)
      end

      it "returns session token" do
        post "/sessions", email: @user.email, password: '123456'
        expect(result['session_token']).to eq(@user.reload.session_token)
      end
    end
  end

  describe "DELETE #destroy" do
    before do
      @user.ensure_session_token!
    end

    context "when all is ok" do
      it "returns 204 http status code" do
        delete "/sessions", session_token: @user.reload.session_token 
        expect(last_response.status).to eq(204)
      end

      it "remove session" do
        delete "/sessions", session_token: @user.reload.session_token 
        expect(@user.reload.session_token).to eq(nil)
      end
    end
  end
end
