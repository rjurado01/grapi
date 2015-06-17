module Grapi
  module Pagination
    def paginate
      if params[:page] and @scope
        page = params[:page].to_i - 1
        page = 0 if page < 0
        @scope = @scope.skip(page * 10)
      end
    end
  end
end
