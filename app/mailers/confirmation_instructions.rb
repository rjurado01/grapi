class ConfirmationInstructionsMail < Grapi::Mail
  def initialize(user)
    super()
    @template = 'confirmation_instructions.html.erb'
    @subject = 'Confirmation instructions' # I18n.t('confirmation_instructions.subject')
    @to = user.email
    @email = user.email
    @link = "#{ENV['PROTOCOL'] || 'http'}://#{ENV['MAIL_HOST']}/confirmations?confirmation_token=#{user.confirmation_token}"
  end
end
