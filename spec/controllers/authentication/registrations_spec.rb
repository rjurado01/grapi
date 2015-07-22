require 'spec_helper'

describe Grapi::RegistrationsAPI do
  include Rack::Test::Methods

  def app
    Grapi::API
  end

  let(:result) { JSON.parse(last_response.body) }

  describe "POST #create" do
    before do
      User.destroy_all
    end
    
    context "when all is ok" do
      before do
        post "/registrations", data: {
          email: 'user@email.com',
          password: '123456',
          password_confirmation: '123456'
        }
      end

      it "returns 201 http status code" do
        expect(last_response.status).to eq(201)
      end

      it "creates new user" do
        expect(User.count).to eq(1)
      end

      it "sends confirmations email" do
        expect(Grapi::Mail.last_email.class).to eq(ConfirmationInstructionsMail)
      end
    end
  end

  describe "UPDATE #update" do
    before do
      User.destroy_all
      @pass = '123456'
      @user = FactoryGirl.create(:user, password: @pass, password_confirmation: @pass)
      @user.ensure_session_token!
    end

    context "when update email" do
      before do
        put "/registrations/#{@user.id}", session_token: @user.session_token,
          data: { email: 'new@email.com' }
      end

      it "returns 204 Https status code" do
        expect(last_response.status).to eq(204)
      end

      it "send confirmation email" do
        expect(Grapi::Mail.last_email.class).to eq(ConfirmationInstructionsMail)
        expect(Grapi::Mail.last_email.to).to eq('new@email.com')
      end
    end

    context "when update password" do
      it "returns 204 Https status code" do
        put "/registrations/#{@user.id}", session_token: @user.session_token, data: {
          current_password: @pass,
          password: 'new_password',
          password_confirmation: 'new_password',
        }

        expect(last_response.status).to eq(204)
      end
    end
  end

  describe "DELETE #destroy" do
    before do
      @user = FactoryGirl.create(:user)
      @user.ensure_session_token!
      @user.reload
    end

    context "when all is ok" do
      it "returns 204 http status code" do
        delete "/registrations/#{@user.id}", session_token: @user.session_token 
        expect(last_response.status).to eq(204)
      end

      it "remove user" do
        expect {
          delete "/registrations/#{@user.id}", session_token: @user.session_token 
        }.to change(User, :count).by(-1)
      end
    end
  end
end
