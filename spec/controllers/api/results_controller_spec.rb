require 'rails_helper'

RSpec.describe Api::ResultsController, type: :controller do
  before :each do
    @project = FactoryGirl.create(:project, published: true,
      course: FactoryGirl.create(:course, published: true))
    @create_result = lambda do |team_name|
      submitter = FactoryGirl.create(:student, verified: true, team: team_name)
      submission = FactoryGirl.create(:submission, submitter: submitter,
        project: @project)
      FactoryGirl.create(:result, project: @project, submission: submission)
    end
    @default_team = 'Default__Results_Controller_SPEC_TEAM'
  end
  describe 'index' do
    let(:teacher) {FactoryGirl.create(:teacher)}
    before :each do
      2.times {@create_result.call @default_team}
    end
    it 'does not allow unauthorized' do
      get :index, format: :json, project_id: @project.id
      expect(response).to be_unauthorized
    end
    it '404s on unknown parent' do
      set_token teacher.token
      get :index, format: :json, project_id: 'unknown'
      expect(response).to be_not_found
    end
    it 'allows a teacher' do
      set_token teacher.token
      get :index, format: :json, project_id: @project.id
      expect(response).to be_success
    end
    it 'allows submitter' do
      student = FactoryGirl.create(:student, verified: true, team: @default_team)
      set_token student.token
      get :index, format: :json, project_id: @project.id
      expect(response).to be_success
      expect(json_response[:results].size).to eql 2
    end

  end
end
