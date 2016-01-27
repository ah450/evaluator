require 'rails_helper'

RSpec.describe SuiteCode, type: :model do
  it 'validates code existance' do
    sc = SuiteCode.new
    sc.mime_type = 'application/zip'
    sc.file_name = 'none_file'
    sc.code = ''
    expect(sc).to_not be_valid
  end
end
