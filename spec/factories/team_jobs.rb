FactoryGirl.define do
  factory :team_job do
    user {FactoryGirl.create(:teacher, verified: true)}
    data do
      path = File.join(Rails.root.join('spec/fixtures/files'),
        'teams/teams_example.csv')
      File.binread path
    end
  end

end
