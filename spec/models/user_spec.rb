require 'spec_helper'

describe User do
  describe "Fields" do
    it { is_expected.to have_field('name') }
    it { is_expected.to have_field('email') }
    it { is_expected.to have_field('encrypted_password') }
    it { is_expected.to have_field('session_token') }
  end

  describe "Validations" do
    it { is_expected.to validate_presence_of('email') }
    it { is_expected.to validate_presence_of('password') }

    context "when user has password" do
      it "should validate presence of password_confirmation" do
        user = User.new(password: '123456')
        user.validate
        expect(user._errors['password_confirmation']).to be_include('blank')
      end

      it "should validate match of password_confirmation" do
        user = User.new(password: '123456', password_confirmation: 'invalid')
        user.validate
        expect(user._errors['password_confirmation']).to be_include('match')
      end
    end
  end

  describe "Class methods" do
    describe "generate_session_token" do
      it "returns valid session token" do
        allow(SecureRandom).to receive(:base64).and_return('2+')
        expect(User.generate_session_token).to eq('20')
      end
    end

    describe "generate_confirmation_token" do
      it "returns valid session token" do
        allow(SecureRandom).to receive(:base64).and_return('2+')
        expect(User.generate_confirmation_token).to eq('20')
      end
    end

    describe "get_authenticated_model" do
      it "returns authenticated model" do
        user = FactoryGirl.create(:user, password: '123456')
        expect(User.get_authenticated_model(user.email, '123456').email).to eq(user.email)
      end
    end
  end

  describe "Instance methods" do
    describe "ensure_session_token!" do
      context "when user not has session token" do
        it "adds token to user" do
          user = FactoryGirl.create(:user)
          user.ensure_session_token!
          expect(user.session_token).not_to eq(nil)
        end
      end

      context "when user has session token" do
        it "does nothing" do
          user = FactoryGirl.create(:user, session_token: '123')
          user.ensure_session_token!
          expect(user.session_token).to eq('123')
        end
      end
    end

    describe "remove_session_token!" do
      it "remove session token" do
        user = FactoryGirl.create(:user, session_token: '123456')
        user.remove_session_token!
        expect(user.reload.session_token).to eq(nil)
      end
    end

    describe "send_confirmation" do
      it "send email confirmation" do
        user = FactoryGirl.create(:user_unconfirmed)
        expect(Grapi::Mail.last_email.to).to eq(user.email)
      end
    end

    describe "posts" do
      it "returns user posts" do
        user = FactoryGirl.create(:user)
        post1 = FactoryGirl.create(:post, user_id: user.id)
        post2 = FactoryGirl.create(:post, user_id: user.id)
        expect(user.posts.all.map(&:id)).to eq([post1.id, post2.id])
      end
    end
  end

  describe "Hooks" do
    context "after create" do
      it "send email confirmation" do
        allow_any_instance_of(User).to receive(:send_confirmation).and_return(true)
        user = FactoryGirl.create(:user_unconfirmed)
        expect(user).to have_received(:send_confirmation)
      end
    end
  end
end
