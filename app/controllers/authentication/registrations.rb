module Grapi
  class RegistrationsAPI < Grape::API
    helpers do
      def get_and_authorize_resource
        @model =  User.find_by_id(params[:id])
        error!('Not Found', 404) unless @model
        error!('Forbidden', 403) unless @model.authorize!(@current_user)
      end
    end

    resource :registrations do
      post do
        params_list = ['email', 'password', 'password_confirmation']
        @model = User.new(filter_data(params_list))
        @model.save
        respond_with @model
      end

      put ':id' do
        authenticate!
        get_and_authorize_resource
        params_list = ['email', 'password', 'password_confirmation', 'current_password']
        @model.update(filter_data(params_list))
        status 204
      end

      delete ':id' do
        authenticate!
        get_and_authorize_resource
        @model.destroy
        status 204
      end
    end
  end
end
