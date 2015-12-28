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
  scope :students, -> { where student: true }
  scope :teachers, -> { where student: false }


  def teacher?
    not student?
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
    decoded = JWT.decode token, hmac_key, true, {leeway: 60}
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


  def set_subtype
    self.student = "#{STUDENT_EMAIL_REGEX === email}"
  end

end
