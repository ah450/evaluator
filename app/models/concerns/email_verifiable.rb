# Concern for User email verification
module EmailVerifiable
  extend ActiveSupport::Concern

  module ClassMethods
    def verification_expiration
      Rails.application.config.configurations[:verification_expiration]
    end

    def verification_token_str_max_length
      Rails.application.config.verification_token_str_max_length
    end

    def verification_resend_delay
      Rails.application.config.configurations[:user_verification_resend_delay]
    end
  end

  included do
    scope :verified, -> { where verified: true }
  end

  def can_resend_verify?
    expiration_time = User.verification_resend_delay.ago
    num_tokens = VerificationToken.where(user_id: id).where('created_at > ?',
                                                            expiration_time)
                                  .count
    num_tokens == 0
  end

  def verify(token)
    unless verified?
      with_lock('FOR UPDATE') do
        expiration_time = User.verification_expiration.ago
        verification_tokens = VerificationToken.where(user_id: id,
                                                      token: token).where(
                                                        'created_at >= ?',
                                                        expiration_time)
        if verification_tokens.count > 0
          self.verified = true
          save!
          verification_tokens.delete_all
        end
      end
    end
    verified?
  end

  def gen_verification_token
    verification_token = with_lock('FOR UPDATE') do
      expiration_time = User.verification_expiration.ago
      VerificationToken.where(user_id: id).where('created_at <= ?',
                                                 expiration_time).delete_all
      VerificationToken.where(user_id: id).order(
        created_at: :desc).offset(1).destroy_all
      token = VerificationToken.where(user_id: id).order(
        created_at: :desc).first
      token_str = SecureRandom.urlsafe_base64(
        User.verification_token_str_max_length)
      if !token.nil? && token.created_at <= expiration_time
        token.destroy
        token = nil
      end
      token || VerificationToken.create(user: self, token: token_str)
    end
    verification_token.token
  end
end
