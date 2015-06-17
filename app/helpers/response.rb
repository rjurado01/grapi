module Grapi
  module Response
    def respond_with(target, template=nil, options=nil)
      if target.class == Mongolow::Cursor
        target.all.map{|post| post.template(template, options)}
      elsif target.respond_to? 'template'
        status 422 if target.errors?
        target.template(template, options)
      end
    end
  end
end
