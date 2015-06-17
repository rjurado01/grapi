module Grapi
  class PostsAPI < Grape::API
    helpers do
    end

    resource :posts do
      post do
        params_list = ['name', 'email', 'password']
        @model = User.new(check_and_filter(params_list))
        @model.save
        respond_with @model
      end
    end
  end
end
