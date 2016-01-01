class User < ActiveRecord::Base
  has_secure_password
  STUDENT_EMAIL_REGEX = /\A[a-zA-Z\.\-]+@student.guc.edu.eg\z/
  TEACHER_EMAIL_REGEX = /\A[a-zA-Z\.\-]+@guc.edu.eg\z/
  GUC_EMAIL_REGEX = /\A[a-zA-Z\.\-]+@(student.)?guc.edu.eg\z/
  validates :password, length: { minimum: 2 }
  validates :name, presence: true
  validates :email, presence: true, uniqueness: { case_sensitive: false }
  validates_format_of :email, with: GUC_EMAIL_REGEX, message: 'must be a GUC email'
  validate :email_not_changed
  validate :student_fields
  before_validation :set_subtype
  scope :verified, -> { where verified: true }
  scope :students, -> { where student: true }
  scope :teachers, -> { where student: false }
  has_many :studentships, inverse_of: :student, foreign_key: :student_id
  has_many :courses, through: :studentships, dependent: :delete_all
  has_many :submissions, inverse_of: :student, foreign_key: :student_id, dependent: :destroy
  has_many :verification_tokens, dependent: :delete_all
  has_many :reset_tokens, dependent: :delete_all

  def teacher?
    not student?
  end

  def full_name
    name.split.map { |e| e.capitalize  }.join ' '
  end


  def as_json(options={})
    super(except: [:password_digest],
      methods: [:guc_id]
    )
  end

  # Generates a timed JWT
  # expiration unit is hours
  # default is 1 hour
  def token(expiration=nil)
    expiration ||= 1
    payload = {
      data: {
        id: id,
        discriminator: password_digest
        # discriminator used to detect password changes after token generation
      },
      exp: Time.now.to_i + expiration * 60 * 60
    }
    # HMAC using SHA-512 algorithm
    JWT.encode payload, User.hmac_key, 'HS512'
  end

  # Retrieve user based on token
  # Raises JWT::VerificationError if key missmatch or signature corrupted
  # Raises JWT::ExpiredSignature
  # Both subclasses of JWT::DecodeError
  # Raises ActiveRecord::RecordNotFound if user no longer exists
  # Raises AuthenticationError if incorrect authentication data supplied
  # returns User instance
  def self.find_by_token(token)
    decoded = JWT.decode token, hmac_key, true, {leeway: 60, algorithm: 'HS512'}
    data = decoded.first['data']
    user = find data['id']
    raise AuthenticationError unless Rack::Utils.secure_compare(
      user.password_digest, data['discriminator'])
    return user
  end

  def guc_id
    "#{guc_prefix}-#{guc_suffix}"
  end

  def guc_id=(value)
    guc_prefix, guc_suffix = value.split '-'
    self.guc_prefix = guc_prefix.to_i
    self.guc_suffix = guc_suffix.to_i
  end


  def gen_verification_token
    verification_token = with_lock("FOR SHARE") do
      expirationTime = User.verification_expiration.ago
      VerificationToken.where(user_id: id).where('created_at <= ?', expirationTime).delete_all
      VerificationToken.where(user_id: id).order(created_at: :desc).offset(1).each do |r|
        r.destroy
      end
      token = VerificationToken.where(user_id: id).order(created_at: :desc).first
      tokenStr = SecureRandom.urlsafe_base64 User.verification_token_str_max_length
      if !token.nil? && token.created_at <= expirationTime
        token.destroy
        token = nil
      end
      token ||= VerificationToken.create user: self, token: tokenStr
    end
    verification_token.token
  end

  def verify(token)
    if !verified?
      with_lock("FOR SHARE") do
        expirationTime = User.verification_expiration.ago
        verification_tokens = VerificationToken.where(user_id: id, token: token).where('created_at >= ?', expirationTime)
        if verification_tokens.count > 0
          self.verified = true
          self.save!
          verification_tokens.delete_all
        end
      end
    end
    verified?
  end

  def reset_password(token, newPass)
    with_lock("FOR SHARE") do
      expirationTime = User.pass_reset_expiration.ago
      reset_tokens = ResetToken.where(user_id: id, token: token).where('created_at >= ?', expirationTime)
      if reset_tokens.count > 0
        self.password = newPass
        self.save!
        reset_tokens.delete_all
        return true
      else
        return false
      end
    end
  end

  def gen_reset_token
    reset_token = with_lock("FOR SHARE") do
      expirationTime = User.pass_reset_expiration.ago
      ResetToken.where(user_id: id).where('created_at <= ?', expirationTime).delete_all
      ResetToken.where(user_id: id).order(created_at: :desc).offset(1).each do |r|
        r.destroy
      end
      token = ResetToken.where(user_id: id).order(created_at: :desc).first
      tokenStr = SecureRandom.urlsafe_base64 User.pass_reset_token_str_max_length
      if !token.nil? && token.created_at <= expirationTime
        token.destroy
        token = nil
      end
      token ||= ResetToken.create user: self, token: tokenStr
    end
    reset_token.token
  end

  private

  def email_not_changed
    if email_changed?  && persisted?
      errors.add(:email, "can not be changed")
    end
  end

  def student_fields
    if student?
      if not major.kind_of? String
        errors.add(:major, 'is required')
      end
      if not team.kind_of? String
        errors.add(:team, 'is required')
      end
      if not guc_prefix.is_a?(Integer) && guc_suffix.is_a?(Integer)
        errors.add('GUC id', 'is required')
      end
    end
  end

  def self.hmac_key
    Rails.application.config.jwt_key
  end

  def self.verification_expiration
    Rails.application.config.configurations[:verification_expiration]
  end

  def self.pass_reset_expiration
    Rails.application.config.configurations[:pass_reset_expiration]
  end

  def self.pass_reset_token_str_max_length
    Rails.application.config.pass_reset_token_str_max_length
  end

  def self.verification_token_str_max_length
    Rails.application.config.verification_token_str_max_length
  end


  def set_subtype
    self.student = "#{STUDENT_EMAIL_REGEX === email}"
  end

end
