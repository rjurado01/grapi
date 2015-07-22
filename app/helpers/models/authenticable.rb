module Grapi
  module Model
    module Authenticable
      module ClassMethods
        def generate_session_token
          loop do
            token = SecureRandom.base64.gsub('+', '0')
            break token unless self.find({session_token: token}).first
          end
        end

        def generate_confirmation_token
          loop do
            token = SecureRandom.base64.gsub('+', '0')
            break token unless self.find({confirmation_token: token}).first
          end
        end

        def generate_password_token
          loop do
            token = SecureRandom.base64.gsub('+', '0')
            break token unless self.find({reset_password_token: token}).first
          end
        end

        def get_authenticated_model(email, password)
          self.find({
            email: email,
            encrypted_password: encrypt_password(password)
          }).first
        end

        def encrypt_password(password)
          Digest::SHA1.hexdigest(password) if password
        end
      end

      def self.included(base)
        base.extend(ClassMethods)

        # authentication
        base.field :email
        base.field :encrypted_password
        base.field :session_token

        # recover password
        base.field :reset_password_token

        # confirmation
        base.field :confirmed_at
        base.field :confirmation_token

        # set/update password fields
        base.send(:attr_accessor, :password)
        base.send(:attr_accessor, :password_confirmation)
        base.send(:attr_accessor, :current_password)

        # hooks actions
        base.before_save { save_password }
        base.after_save { send_confirmation }

        # validations
        base.validate { validate_authenticable }
      end

      def ensure_session_token!
        self.session_token = self.class.generate_session_token unless self.session_token
        self.set('session_token', self.session_token)
      end

      def remove_session_token!
        self.set('session_token', nil)
      end

      def authorize!(current_model)
        self.id == current_model.id
      end

      def send_confirmation
        if self.changed?('email') and self.email
          self.set(:confirmation_token, self.class.generate_confirmation_token)
          self.set(:confirmed_at, nil)
          ConfirmationInstructionsMail.new(self).send
        end
      end

      def send_reset_password
        self.set(:reset_password_token, self.class.generate_password_token)
        ResetPasswordMail.new(self).send
      end

      def confirm!
        self.confirmation_token = nil
        self.confirmed_at = Time.now
        self.save
      end

      private

      def save_password
        # encrypt password
        self.encrypted_password = User.encrypt_password(self.password) if self.password

        # clean plane passwords
        self.password = self.current_password = self.password_confirmation = nil
      end

      def validate_authenticable
        presence_of :email
        presence_of :password unless self.encrypted_password
        presence_of :password_confirmation  if self.password

        match_of :password_confirmation, self.password if self.password

        uniquenes_of :email

        if self.current_password and
           self.class.encrypt_password(self.current_password) != self.encrypted_password
          self._errors['current_password'] = ['invalid']
        end
      end
    end
  end
end
