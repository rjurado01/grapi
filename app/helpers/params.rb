module Grapi
  module Params
    def check_params(params_list)
      errors = {}
      params_list.each do |name|
        errors[name] = 'blank' unless params[name]
      end

      error!({errors: errors}, 422) unless errors.empty?
    end

    def filter_params(params_list)
      filter_params = {}
      params.keys.each  do |key|
        filter_params[key] = params[key] if params_list.include? key
      end

      filter_params
    end

    def check_and_filter_params(params_list)
      check_params(params_list)
      filter_params(params_list)
    end
  end
end
