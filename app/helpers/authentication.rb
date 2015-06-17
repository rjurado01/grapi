# This module let you authenticate user in each controller

module Grapi
  module Authentication
    def authenticate!
      check_params(['session_token'])
      @current_user = User.find({session_token: params[:session_token]}).first
      error!("401 Unauthorized", 401) unless @current_user
    end
  end
end
