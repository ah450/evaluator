require 'rails_helper'

RSpec.describe Result, type: :model do
  it 'has a valid factory' do
    result = FactoryGirl.build(:result)
    expect(result).to be_valid
  end
  it 'validates submission' do
    result = FactoryGirl.build(:result)
    result.submission = nil
    expect(result).to_not be_valid
  end
  it 'validates project' do
    result = FactoryGirl.build(:result)
    result.project = nil
    expect(result).to_not be_valid
  end
  it 'validates test_suite' do
    result = FactoryGirl.build(:result, test_suite: nil)
    expect(result).to_not be_valid
  end
  it 'validates success' do
    result = FactoryGirl.build(:result, success: nil)
    expect(result).to_not be_valid
  end
  it 'validates compiler_stderr' do
    result = FactoryGirl.build(:result, compiler_stderr: nil)
    expect(result).to_not be_valid
  end
  it 'validates compiler_stdout' do
    result = FactoryGirl.build(:result, compiler_stdout: nil)
    expect(result).to_not be_valid
  end
  it 'validates compiled' do
    result = FactoryGirl.build(:result, compiled: nil)
    expect(result).to_not be_valid
  end
  it 'validates grade' do
    result = FactoryGirl.build(:result, grade: nil)
    expect(result).to_not be_valid
  end
  it 'validates max_grade' do
    result = FactoryGirl.build(:result, max_grade: nil)
    expect(result).to_not be_valid
  end
  it 'grade can not be less than zero' do
    result = FactoryGirl.build(:result, grade: -1)
    expect(result).to_not be_valid
  end
  it 'grade can not be greater than max_grade' do
    result = FactoryGirl.build(:result, grade: 30, max_grade: 10)
    expect(result).to_not be_valid
  end

  context 'hidden' do
    it 'is set to test suite value on save' do
      result = FactoryGirl.create(:result,
        test_suite: FactoryGirl.create(:public_suite))
      expect(result.hidden).to be false
      result = FactoryGirl.create(:result,
        test_suite: FactoryGirl.create(:private_suite))
      expect(result.hidden).to be true
    end
  end
end
