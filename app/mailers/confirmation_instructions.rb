class ConfirmationInstructionsMail < Grapi::Mail
  def initialize(user)
    super()
    @template = 'confirmation_instructions.html.erb'
    @subject = 'Confirmation instructions'# I18n.t('confirmation_instructions.subject')
    @to = user.email
    @name = user.name
    @token = user.confirmation_token
  end
end
