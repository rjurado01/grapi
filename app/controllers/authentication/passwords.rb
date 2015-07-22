module Grapi
  class PasswordsAPI < Grape::API
    helpers do
    end

    resource :passwords do
      post do
        check_params([:email])
        user = User.find({email: params[:email]}).first
        
        if user
          url = @env['rack.url_scheme'] + "://" + @env['HTTP_HOST']
          user.send_reset_password
          status 204
        else
          error!({errors: {email: ['invalid']}}, 422)
        end
      end

      put do
        check_data [:password, :password_confirmation, :reset_password_token]
        user = User.find({reset_password_token: data['reset_password_token']}).first

        if user
          user.update(filter_data([:password, :password_confirmation]))
          status 204
        else
          error!({errors: {reset_password_token: ['invalid']}}, 422)
        end
      end
    end
  end
end
