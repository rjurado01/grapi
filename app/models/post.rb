class Post
  include Mongolow::Model

  field :title
  field :text

  # relations
  field :user_id

  validate do
    self._errors = {}
    self._errors['title'] = 'blank' unless self.title
    self._errors['text'] = 'blank' unless self.text
    self._errors['user_id'] = 'blank' unless self.user_id
  end

  def save_post(current_user)
    self.validate
    self._errors['user_id'] = 'invalid' unless authorize!(current_user)
    self.save unless self.errors?
  end

  def authorize!(current_user)
    self.user_id and self.user_id == current_user.id
  end
end
