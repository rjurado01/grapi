class Post
  include Mongolow::Model

  field :title
  field :text

  # relations
  field :user_id

  validate do
    presence_of :title
    presence_of :text
    presence_of :user_id
  end

  def authorize!(current_user)
    self.user_id and self.user_id == current_user.id
  end
end
