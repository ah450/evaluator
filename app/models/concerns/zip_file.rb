module ZipFile
  extend ActiveSupport::Concern
  included do
    validate :code_exists
    validate :file_type
  end

  def code_exists
    if code.size == 0
      errors.add(:code, 'can not be blank')
    end
  end

  def file_type
    if File.extname(file_name) != '.zip'
      errors.add(:file_name, 'must be a zip file')
    end
  end
end