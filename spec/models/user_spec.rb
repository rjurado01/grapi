require 'spec_helper'

describe User do
  describe "Fields" do
    it "have field :name" do
      expect(User.fields.include?('name')).to eq(true)
    end

    it "have field :email" do
      expect(User.fields.include?('email')).to eq(true)
    end

    it "have field :password" do
      expect(User.fields.include?('password')).to eq(true)
    end

    it "have field :session_token" do
      expect(User.fields.include?('session_token')).to eq(true)
    end
  end

  describe "Validations" do
    it "validate presence of :name" do
      post = User.new
      post.validate
      expect(post._errors).to be_include('name')
    end

    it "validate presence of :email" do
      post = User.new
      post.validate
      expect(post._errors).to be_include('email')
    end

    it "validate presence of :password" do
      post = User.new
      post.validate
      expect(post._errors).to be_include('password')
    end
  end

  describe "Class methods" do
    describe "generate_token" do
      it "returns valid session token" do
        allow(SecureRandom).to receive(:base64).and_return('2+')
        expect(User.generate_token).to eq('20')
      end
    end

    describe "get_authenticated_user" do
      it "returns authenticated user" do
        user = FactoryGirl.create(:user, password: '123456')
        expect(User.get_authenticated_user(user.email, '123456').email).to eq(user.email)
      end
    end
  end

  describe "Methods" do
    describe "posts" do
      it "returns user posts" do
        user = FactoryGirl.create(:user)
        post1 = FactoryGirl.create(:post, user_id: user.id)
        post2 = FactoryGirl.create(:post, user_id: user.id)
        expect(user.posts.all.map(&:id)).to eq([post1.id, post2.id])
      end
    end

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
  end
end
