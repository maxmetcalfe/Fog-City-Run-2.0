class UserMailer < ApplicationMailer

  def account_activation(user)
    @user = user
    mail to: user.email, subject: "Account Activation"
  end

  def password_reset(user)
    puts "[UserMailer] Starting password_reset for user: #{user.email}"
    logger.info "[UserMailer] Starting password_reset for user: #{user.email}" if logger
    
    @user = user
    
    # Log reset token (first 8 chars for debugging)
    token_preview = user.reset_token ? user.reset_token[0..7] + '...' : 'nil'
    puts "[UserMailer] Reset token preview: #{token_preview}"
    logger.info "[UserMailer] Reset token preview: #{token_preview}" if logger
    
    logger.info "[UserMailer] Sending password reset email to: #{user.email}" if logger
    
    email = mail(to: user.email, subject: "Password reset")
    
    puts "[UserMailer] Email constructed: from=#{email.from}, to=#{email.to}, subject=#{email.subject}"
    logger.info "[UserMailer] Email constructed: from=#{email.from}, to=#{email.to}, subject=#{email.subject}" if logger
    
    email.deliver_now
    
    puts "[UserMailer] Email delivered successfully to: #{user.email}"
    logger.info "[UserMailer] Email delivered successfully to: #{user.email}" if logger
    
    email
  rescue => e
    puts "[UserMailer ERROR] #{e.class}: #{e.message}"
    logger.error "[UserMailer ERROR] #{e.class}: #{e.message}" if logger
    logger.error "[UserMailer ERROR] Backtrace: #{e.backtrace.join("\n")}" if logger && e.backtrace
    raise e
  end
end
