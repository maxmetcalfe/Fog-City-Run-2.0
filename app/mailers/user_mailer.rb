class UserMailer < ApplicationMailer

  def account_activation(user)
    @user = user
    mail to: user.email, subject: "Account Activation"
  end

  def password_reset(user)
    @user = user
    logger.info "[UserMailer] Sending password reset email to: #{user.email}" if logger
    mail to: user.email, subject: "Password reset"
  rescue => e
    logger.error "[UserMailer ERROR] #{e.class}: #{e.message}" if logger
    logger.error "[UserMailer ERROR] Backtrace: #{e.backtrace.join("\n")}" if logger && e.backtrace
    raise e
  end
end
