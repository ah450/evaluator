FactoryGirl.define do
  factory :result do
    compiled true
    compiler_stderr 'stderr'
    compiler_stdout 'stdout'
    success true
    grade 10
    max_grade 30
    project do
      FactoryGirl.create(:project,
                         published: true, course: FactoryGirl.create(:course, published: true))
    end
    after(:build) do |result|
      if result.test_suite.nil?
        result.test_suite = FactoryGirl.create(:public_suite, project: result.project)
      end
      if result.submission.nil?
        result.submission = FactoryGirl.create(:submission, project: result.project)
      end
    end
  end
end
