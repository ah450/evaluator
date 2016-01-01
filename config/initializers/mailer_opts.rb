Rails.configuration.action_mailer.default_url_options = {
  host: 'evaluator.in'
}

class EmailSubjectTag
  def self.delivering_email(mail)
    mail.subject = '[EVALUATOR] ' + mail.subject
  end
end

ActionMailer::Base.register_interceptor EmailSubjectTag
