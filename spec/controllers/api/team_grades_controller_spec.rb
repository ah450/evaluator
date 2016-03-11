require 'rails_helper'

RSpec.describe Api::TeamGradesController, type: :controller do
  before :each do
    @project_one = FactoryGirl.create(:project, published: true, course: FactoryGirl.create(:course, published: true))
    @project_two = FactoryGirl.create(:project, published: true, course: FactoryGirl.create(:course, published: true))
    @create_team_grade = lambda do |team_name, project|
      submitter = FactoryGirl.create(:student, team: team_name)
      submission = FactoryGirl.create(:submission_with_code, submitter: submitter, project: project)
      result = FactoryGirl.create(:result, submission: submission, project: project)
      result.team_grade
    end
  end

  context 'show' do
    it 'does not allow unauthorized' do
      grade = @create_team_grade.call 'one', @project_one
      get :show, id: grade.id
      expect(response).to be_unauthorized
    end

    it 'allows student to view own' do
      grade = @create_team_grade.call 'one', @project_one
      set_token grade.submission.submitter.token
      get :show, id: grade.id
      expect(response).to be_success
    end

    it 'allows teacher' do
      teacher = FactoryGirl.create(:teacher)
      grade = @create_team_grade.call 'one', @project_one
      set_token teacher.token
      get :show, id: grade.id
      expect(response).to be_success
    end
    it 'does not allow student from another team' do
      grade = @create_team_grade.call 'one', @project_one
      student = FactoryGirl.create(:student, team: 'two')
      set_token student.token
      get :show, id: grade.id
      expect(response).to be_forbidden
    end
  end

  context 'latest' do
    it 'does not allow unauthorized' do
      get :latest, project_id: @project_one.id
      expect(response).to be_unauthorized
    end

    it 'does not allow teacher' do
      set_token FactoryGirl.create(:teacher).token
      get :latest, project_id: @project_one.id
      expect(response).to be_forbidden
    end

    it 'shows latest only' do
      @create_team_grade.call 'one', @project_one
      grade = @create_team_grade.call 'one', @project_one
      @create_team_grade.call 'one', @project_two
      set_token FactoryGirl.create(:student, team: 'one').token
      get :latest, project_id: @project_one.id
      expect(response).to be_success
      expect(json_response[:id]).to eql grade.id
    end

    it '404 on no team grades' do
      set_token FactoryGirl.create(:student, team: 'one').token
      get :latest, project_id: @project_one.id
      expect(response).to be_not_found
    end
  end

end
