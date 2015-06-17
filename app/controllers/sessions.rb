module Grapi
  class SessionsAPI < Grape::API
    resource :sessions do
      post do
        check_params(['email', 'password'])

        # get user from database
        user = User.get_authenticated_user(params['email'], params['password'])

        if user
          user.ensure_session_token!
          user.template('session_tmpl')
        else
          error!({errors: {user: 'invalid'} }, 422)
        end
      end

      delete do
        authenticate!
        @current_user.remove_session_token!
        status 204
      end
    end
  end
end
