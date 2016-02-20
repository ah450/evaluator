FactoryGirl.define do
  factory :project_bundle do
    project
    data do
      path = File.join(Rails.root.join('spec/fixtures/files'),
                       'submissions/bundle.tar.gz')
      File.binread path
    end
    association :user, factory: :teacher
  end
end
