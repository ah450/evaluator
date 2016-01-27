FactoryGirl.define do
  factory :solution do
    code do
      path = File.join(Rails.root.join('spec/fixtures/files'),
        'submissions/csv_submission.zip')
      File.binread path
    end
    mime_type Rack::Mime.mime_type '.zip'
    file_name 'csv_submission.zip'
  end

end
