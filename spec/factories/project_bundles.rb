FactoryGirl.define do
  factory :project_bundle do
    project
    file_name do
      path = File.join(Rails.root.join('spec/fixtures/files'),
                       'submissions/bundle.tar.gz')
      new_path = Rails.root.join('tmp', "#{DateTime.now.utc}.tar.gz")
      FileUtils.cp(path, new_path)
      new_path
    end
    association :user, factory: :teacher
  end
end
