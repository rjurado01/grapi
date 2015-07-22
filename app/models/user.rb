class User 
  include Mongolow::Model
  include Grapi::Model::Authenticable
  include Templates::User

  field :name

  def posts
    Post.find({user_id: self.id})
  end
end
