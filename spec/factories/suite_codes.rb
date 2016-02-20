FactoryGirl.define do
  factory :suite_code do
    code do
      path = File.join(Rails.root.join('spec/fixtures/files'),
                       'test_suites/csv_test_suite.zip')
      File.binread path
    end
    mime_type Rack::Mime.mime_type '.zip'
    file_name 'csv_test_suite.zip'
  end
end
