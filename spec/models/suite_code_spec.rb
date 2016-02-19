require 'rails_helper'

RSpec.describe SuiteCode, type: :model do
  it { should belong_to :test_suite }
  it { should validate_presence_of :file_name }
  it { should validate_presence_of :mime_type }
  it { should validate_presence_of :test_suite }

  it 'validates code existance' do
    sc = SuiteCode.new
    sc.mime_type = 'application/zip'
    sc.file_name = 'none_file'
    sc.code = ''
    expect(sc).to_not be_valid
  end
end
