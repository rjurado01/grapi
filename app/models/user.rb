class User 
  include Mongolow::Model
  include UserTemplates 

  field :name
  field :email
  field :password

  field :session_token

  field :confirmed_at
  field :confirmation_token

  validate do
    self._errors = {}
    self._errors['name'] = 'blank' unless self.name
    self._errors['email'] = 'blank' unless self.email
    self._errors['password'] = 'blank' unless self.password

    if self.changed?('email') and
      User.find({email: self.email, _id: {'$ne' => self._id}}).first
      self._errors['email'] = 'taken'
    end
  end

  before_save do
    if self.changed?('password') and not self._old_values['password']
      self.password = Digest::SHA1.hexdigest(self.password)
    end
  end

  after_save do
    self.send_confirmation
  end

  def self.generate_token
    loop do
      token = SecureRandom.base64.gsub('+', '0')
      break token unless User.find({session_token: token}).first
    end
  end

  def self.get_authenticated_user(email, password)
    User.find({email: email, password: Digest::SHA1.hexdigest(password)}).first
  end

  def ensure_session_token!
    self.session_token = User.generate_token unless self.session_token
    self.set('session_token', self.session_token)
  end

  def remove_session_token!
    self.set('session_token', nil)
  end

  def posts
    Post.find({user_id: self.id})
  end

  def send_confirmation
    unless self.confirmed_at or self.confirmation_token
      ConfirmationInstructionsMail.new(self).send
    end
  end
end
