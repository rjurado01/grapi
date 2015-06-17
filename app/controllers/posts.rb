module Grapi
  class PostsAPI < Grape::API
    helpers do
      def check_index
        check_params(['user_id'])
        error!('Not Found', 404) unless User.find_by_id(params[:user_id])
      end
  
      def get_resource
        @model =  Post.find_by_id(params[:id])
        error!('Not Found', 404) unless @model
      end

      def autorize_resource
        error!('Forbidden', 403) unless @model.authorize!(@current_user)
      end

      def permited_params
        filter_params(['title', 'text', 'user_id'])
      end
    end

    before do
      authenticate!
    end

    resource :posts do
      get do
        check_index
        @scope = Post.find({user_id: params[:user_id]}).limit(10)
        paginate
        respond_with @scope
      end

      post do
        @model = Post.new(permited_params)
        @model.save_post(@current_user)
        respond_with @model
      end

      get ':id' do
        get_resource
        @model.template
      end

      put ':id' do
        get_resource
        @model.update(permited_params)
        respond_with @model
      end

      delete ':id' do
        get_resource
        autorize_resource
        @model.destroy
        status 204
      end
    end
  end
end
