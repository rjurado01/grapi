module Grapi
  module Params
    def data
      params['data'] || {}
    end

    def check_params(params_list)
      errors = {}

      if params_list.class == Array
        params_list.each do |name|
          add_error(errors, name, 'blank') unless params[name]
        end
      else
        add_error(errors, params_list, 'blank') unless params[params_list]
      end

      error!({errors: errors}, 422) unless errors.empty?
    end

    def check_data(params_list)
      errors = {}

      if params_list.class == Array
        params_list.each do |name|
          add_error(errors, name, 'blank') unless data[name]
        end
      else
        add_error(errors, params_list, 'blank') unless data[name]
      end

      error!({errors: errors}, 422) unless errors.empty?
    end

    # Filter create and update params
    def filter_data(params_list)
      filter_params = {}

      if params['data']
        params['data'].keys.each  do |key|
          if params_list.map{|x| x.to_s}.include? key
            filter_params[key] = params['data'][key]
          end
        end
      end

      filter_params
    end

    def check_and_filter_data(params_list)
      check_data(params_list)
      filter_data(params_list)
    end

    private

    def add_error(errors, name, message)
      errors = {} unless errors
      errors[name] = [] unless errors[name]
      errors[name].push message
    end
  end
end
