class SubjectTaggerEmailInterceptor
  def self.delivering_email(message)
    message.subject = '[EVALUATOR] ' + message.subject
  end
  def self.previewing_email(message)
    SubjectTaggerEmailInterceptor.delivering_email message
  end
end

ActionMailer::Base.register_interceptor SubjectTaggerEmailInterceptor
ActionMailer::Base.register_preview_interceptor SubjectTaggerEmailInterceptor

if !Rails.env.test?
  Rails.application.config.action_mailer.delivery_method = :smtp
  Rails.application.config.action_mailer.smtp_settings = {
    address: "localhost",
    port: 25,
  }
end