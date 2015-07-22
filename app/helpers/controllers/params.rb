module Grapi
  module Params
    def data
      params['data'] || {}
    end

    def check_params(params_list)
      errors = {}

      if params_list.class == Array
        params_list.each do |name|
          errors[name] = 'blank' unless params[name]
        end
      else
        errors[params_list] = 'blank' unless params[params_list]
      end

      error!({errors: errors}, 422) unless errors.empty?
    end

    def check_data(params_list)
      errors = {}

      if params_list.class == Array
        params_list.each do |name|
          errors[name] = 'blank' unless params['data'][name]
        end
      else
        errors[params_list] = 'blank' unless params['data'][params_list]
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
  end
end
