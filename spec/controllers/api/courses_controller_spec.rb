require 'rails_helper'

RSpec.describe Api::CoursesController, type: :controller do
  describe "index" do
    let(:student) {FactoryGirl.create(:student)}
    let(:teacher) {FactoryGirl.create(:teacher)}
    let(:courses) {FactoryGirl.create_list(:course, 5)}
    it 'should not allow unauthorized index' do
      get :index, format: :json
      expect(response).to be_unauthorized
    end
    it 'should allow a student to index' do
      set_token student.token
      get :index, format: :json
      expect(response).to be_success
    end
    it 'should allow a teacher to index' do
      set_token teacher.token
      get :index, format: :json
      expect(response).to be_success
    end
    it 'should have pagination' do
      set_token student.token
      get :index, format: :json, page: 1, page_size: courses.length
      expect(json_response).to include(
        :courses, :page, :page_size, :total_pages
        )
    end
    it 'should not return unpublished courses to students' do
      set_token student.token
      get :index, format: :json
      expect(json_response[:page_size]).to eql 0
    end
    context 'query' do

      it 'should override published param for students' do
        set_token student.token
        get :index, format: :json, published: false
        expect(json_response[:page_size]).to eql 0
      end

      it 'should query by published' do
        course = FactoryGirl.create(:course, published: true)
        set_token teacher.token
        get :index, format: :json, published: true
        expect(json_response[:page_size]).to eql 1
        expect(json_response[:courses].first[:id]).to eql course.id
      end
      it 'should query by name' do
        course = FactoryGirl.create(:course, published: true)
        set_token student.token
        get :index, format: :json, name: course.name
        expect(json_response[:page_size]).to eql 1
        expect(json_response[:courses].first[:id]).to eql course.id
      end
    end
  end
  describe "show" do
    let(:student) {FactoryGirl.create(:student)}
    let(:teacher) {FactoryGirl.create(:teacher)}
    let(:course) {FactoryGirl.create(:course)}
    let(:published_course) {FactoryGirl.create(:course, published: true)}
    it 'should not allow unauthorized show' do
      get :show, format: :json, id: course.id
      expect(response).to be_unauthorized
    end
    it 'should allow a teacher' do
      set_token teacher.token
      get :show, format: :json, id: course.id
      expect(json_response[:id]).to eql course.id
      expect(json_response).to include(
        :id, :name, :description, :published
        )
    end
    it 'should allow a student' do
      set_token student.token
      get :show, format: :json, id: published_course.id
      expect(json_response[:id]).to eql published_course.id
      expect(json_response).to include(
        :id, :name, :description, :published
        )
    end
    it 'should not allow a student to request an unpublished course' do
      set_token student.token
      get :show, format: :json, id: course.id
      expect(response).to be_forbidden
    end
  end

  describe "create" do
    let(:course_params) {FactoryGirl.attributes_for(:course)}
    let(:teacher) {FactoryGirl.create(:teacher)}
    it 'should not allow unauthorized' do
      expect {
        post :create, format: :json, **course_params
      }.to change(Course, :count).by 0
      expect(response).to be_unauthorized
    end
    it 'should not allow students' do
      student = FactoryGirl.create(:student)
      expect {
        set_token student.token
        post :create, format: :json, **course_params
      }.to change(Course, :count).by 0
      expect(response).to be_forbidden
    end
    it 'should allow teachers' do
      expect {
        set_token teacher.token
        post :create, format: :json, **course_params
      }.to change(Course, :count).by 1
      expect(response).to be_created
    end
    it 'should be unpublished by default' do
      set_token teacher.token
      post :create, format: :json, **course_params
      expect(json_response[:published]).to be false
    end
    it 'should allow setting of published field' do
      set_token teacher.token
      course_params[:published] = true
      post :create, format: :json, **course_params
      expect(json_response[:published]).to be true
    end
  end
  describe "update" do
    let(:course) {FactoryGirl.create(:course)}
    let(:teacher) {FactoryGirl.create(:teacher)}
    it 'should not allow unauthorized' do
      course.reload
      old_json = course.as_json
      put :update, id: course.id, format: :json, name: "new course name!"
      expect(response).to be_unauthorized
      course.reload
      expect(course.as_json).to match old_json
    end
    it 'should not allow student' do
      course.reload
      old_json = course.as_json
      student = FactoryGirl.create(:student)
      set_token student.token
      put :update, id: course.id, format: :json, name: "new course name!"
      expect(response).to be_forbidden
      course.reload
      expect(course.as_json).to match old_json
    end
    it 'should allow teacher' do
      course.reload
      old_json = course.as_json
      set_token teacher.token
      put :update, id: course.id, format: :json, published: true
      expect(response).to be_success
      course.reload
      expect(course.as_json).to_not match old_json
    end
  end
  describe "destroy" do
    let(:students) {FactoryGirl.create_list(:student, 5)}
    let(:student) {FactoryGirl.create(:student)}
    let(:teacher) {FactoryGirl.create(:teacher)}
    let(:course) {FactoryGirl.create(:course)}
    it 'should not allow unauthorized' do
      course
      expect {
        delete :destroy, format: :json, id: course.id
      }.to change(Course, :count).by 0
      expect(response).to be_unauthorized
    end
    it 'should not allow a student' do
      course
      expect {
        set_token student.token
        delete :destroy, format: :json, id: course.id
      }.to change(Course, :count).by 0
      expect(response).to be_forbidden
    end
    it 'should allow a teacher' do
      course
      expect {
        set_token teacher.token
        delete :destroy, format: :json, id: course.id
      }.to change(Course, :count).by -1
    end
  end
end
