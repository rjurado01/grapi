class ResetPasswordMail < Grapi::Mail
  def initialize(user)
    super()
    @template = 'reset_password.html.erb'
    @subject = 'Reset password instructions' # I18n.t('reset_password_instructions.subject')
    @to = user.email
    @email = user.email
    @link = "#{ENV['PROTOCOL'] || 'http'}://#{ENV['MAIL_HOST']}/passwords?reset_password_token=#{user.reset_password_token}"
  end
end
