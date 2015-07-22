require 'spec_helper'

describe Post do
  describe "Fields" do
    it "have field :title" do
      expect(Post.fields.include?('title')).to eq(true)
    end

    it "have field :text" do
      expect(Post.fields.include?('text')).to eq(true)
    end

    it "have field :user_id" do
      expect(Post.fields.include?('user_id')).to eq(true)
    end
  end

  describe "Validations" do
    it "validate presence of :title" do
      post = Post.new
      post.validate
      expect(post._errors).to be_include('title')
    end

    it "validate presence of :text" do
      post = Post.new
      post.validate
      expect(post._errors).to be_include('text')
    end

    it "validate presence of :user_id" do
      post = Post.new
      post.validate
      expect(post._errors).to be_include('user_id')
    end
  end

  describe "Methods" do
    before :all do
      @user = FactoryGirl.create(:user)
    end

    describe "authorize!" do
      context "when user_id is valid" do
        it "return true" do
          expect(Post.new({user_id: @user.id}).authorize!(@user)).to eq(true)
        end 
      end

      context "when user_id is invalid" do
        it "return false" do
          expect(Post.new({user_id: 'invalid'}).authorize!(@user)).to eq(false)
        end 
      end
    end
  end
end
