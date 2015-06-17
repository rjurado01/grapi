require 'spec_helper'

describe Grapi::PostsAPI do
  include Rack::Test::Methods

  def app
    Grapi::API
  end

  before :all do
    @user = FactoryGirl.create(:user)
    @user.ensure_session_token!
  end

  let(:result) { JSON.parse(last_response.body) }

  describe "GET #index" do
    before :all do
      @posts = create_list(:post, 2, user_id: @user.id)
    end

    context "when all is ok" do
      before do
        get "/posts", session_token: @user.session_token, user_id: @user.id
      end

      it "returns 200 http status code" do
        expect(last_response.status).to eq(200)
      end

      it "returns all posts" do
        expect(result.size).to eq(2)
      end

      it "returns correct JSON" do
        expect(result.all? {|post| post.key?('title')}).to be_truthy
      end
    end

    context "when don't send session params" do
      it "returns 422 http status code" do
        get "/posts"
        expect(last_response.status).to eq(422)
        expect(result['errors']['session_token']).to eq('blank')
      end
    end

    context "when send invalid session params" do
      it "returns 401 http status code" do
        get "/posts", session_token: 'invalid'
        expect(last_response.status).to eq(401)
      end
    end

    context "when don't send user_id parameter" do
      it "returns 422 http status code" do
        get "/posts", session_token: @user.session_token
        expect(last_response.status).to eq(422)
        expect(result['errors']['user_id']).to eq('blank')
      end
    end

    context "when send invalid user_id parameter" do
      it "returns 404 http status code" do
        get "/posts", session_token: @user.session_token, user_id: 'invalid'
        expect(last_response.status).to eq(404)
      end
    end
  end

  describe "GET #show" do
    before :all do
      @post = FactoryGirl.create(:post, user_id: @user.id)
    end

    context "when all is ok" do
      before do
        get "/posts/#{@post.id}", session_token: @user.session_token
      end

      it "returns 200 http status code" do
        expect(last_response.status).to eq(200)
      end

      it "returns post" do
        expect(result['title']).to eq(@post.title)
        expect(result['text']).to eq(@post.text)
        expect(result['user_id']).to eq(@post.user_id)
      end
    end

    context "when don't send session params" do
      it "returns 422 http status code" do
        get "/posts/#{@post.id}"
        expect(last_response.status).to eq(422)
        expect(result['errors']['session_token']).to eq('blank')
      end
    end

    context "when send invalid session params" do
      it "returns 401 http status code" do
        get "/posts/#{@post.id}", session_token: 'invalid'
        expect(last_response.status).to eq(401)
      end
    end
  end

  describe "POST #create" do
    before do
      Post.destroy_all
    end

    context "when all is ok" do
      before do
        post "/posts", session_token: @user.session_token,
          user_id: @user.id, title: 'Title', text: 'Text'
      end

      it "returns 201 http status code" do
        expect(last_response.status).to eq(201)
      end

      it "returns new post" do
        expect(result['title']).to eq('Title')
        expect(result['text']).to eq('Text')
        expect(result['user_id']).to eq(@user.id)
      end

      it "creates new post" do
        db_post = Post.first
        expect(db_post.title).to eq('Title')
        expect(db_post.text).to eq('Text')
      end
    end

    context "when don't send post params" do
      it "returns 422 http status code" do
        post "/posts", session_token: @user.session_token
        expect(last_response.status).to eq(422)
        expect(result['title']).to eq('blank')
        expect(result['text']).to eq('blank')
        expect(result['user_id']).to eq('invalid')
        expect(Post.count).to eq(0)
      end
    end

    context "when don't send session params" do
      it "returns 422 http status code" do
        post "/posts"
        expect(last_response.status).to eq(422)
        expect(result['errors']['session_token']).to eq('blank')
      end
    end

    context "when send invalid session params" do
      it "returns 401 http status code" do
        post "/posts", session_token: 'invalid'
        expect(last_response.status).to eq(401)
      end
    end
  end

  describe "PUT #update" do
    before do
      @post = FactoryGirl.create(:post, user_id: @user.id)
    end

    context "when all is ok" do
      before do
        put "/posts/#{@post.id}", session_token: @user.session_token,
          title: 'new_name', text: 'new_text'
      end

      it "return 200 http status code" do
        expect(last_response.status).to eq(200)
      end

      it "returns updated post" do
        expect(result['title']).to eq('new_name')
        expect(result['text']).to eq('new_text')
      end

      it "update post" do
        db_post = Post.find_by_id(@post.id)
        expect(db_post.title).to eq('new_name')
        expect(db_post.text).to eq('new_text')
      end
    end

    context "when don't send session params" do
      it "returns 422 http status code" do
        delete "/posts/#{@post.id}"
        expect(last_response.status).to eq(422)
        expect(result['errors']['session_token']).to eq('blank')
      end
    end

    context "when send invalid session params" do
      it "returns 401 http status code" do
        delete "/posts/#{@post.id}", session_token: 'invalid'
        expect(last_response.status).to eq(401)
      end
    end
  end

  describe "DELETE #destroy" do
    before do
      Post.destroy_all
      @post = FactoryGirl.create(:post, user_id: @user.id)
    end

    context "when all is ok" do
      before do
        delete "/posts/#{@post.id}", session_token: @user.session_token
      end

      it "returns 204 http status code" do
        expect(last_response.status).to eq(204)
      end

      it "delete post" do
        expect(Post.count).to eq(0)
      end
    end

    context "when user is unautorized" do
      it "return 403 http status code" do
        delete_post = FactoryGirl.create(:post)
        delete "/posts/#{delete_post.id}", session_token: @user.session_token
        expect(last_response.status).to eq(403)
      end
    end

    context "when don't send session params" do
      it "returns 422 http status code" do
        delete "/posts/1"
        expect(last_response.status).to eq(422)
        expect(result['errors']['session_token']).to eq('blank')
      end
    end

    context "when send invalid session params" do
      it "returns 401 http status code" do
        delete "/posts/1", session_token: 'invalid'
        expect(last_response.status).to eq(401)
      end
    end
  end
end
