module Grapi
  class ConfirmationsAPI < Grape::API
    helpers do
    end

    resource :confirmations do
      get do
        check_params :confirmation_token
        user = User.find({confirmation_token: params[:confirmation_token]}).first

        if user
          user.confirm!
          status 204
        else
          error!({errors: {confirmation_token: ['invalid']}}, 422)
        end
      end

      post do
        check_params ([:email])
        user = User.find({email: params[:email]}).first
        
        if user
          user.send_confirmation
          status 204
        else
          error!({errors: {email: ['invalid']}}, 422)
        end
      end
    end
  end
end
