module Grapi
  module Response
    def respond_with(target, template=nil, options=nil)
      if target.class == Mongolow::Cursor
        { data: target.all.map{|post| post.template(template, options)} }
      elsif target.respond_to? 'template'
        if target.errors?
          status 422 
          { errors: target.template(template, options) }
        else
          { data: target.template(template, options) }
        end
      end
    end
  end
end
