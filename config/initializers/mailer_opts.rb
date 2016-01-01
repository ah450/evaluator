Rails.configuration.action_mailer.default_url_options = {
  host: 'evaluator.in'
}

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
