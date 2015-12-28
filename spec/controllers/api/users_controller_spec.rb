require 'rails_helper'

RSpec.describe Api::UsersController, type: :controller do

  describe 'index' do
    let(:students) {FactoryGirl.create_list(:student, 10)}
    let(:teachers) {FactoryGirl.create_list(:teacher, 10)}
    let(:user) {FactoryGirl.create(:student)}
    it 'should not allow unauthoried index' do
      get :index, format: :json
      expect(response).to be_unauthorized
    end
    it 'should respond to index action' do
      request.headers['Authorization'] = "Bearer #{user.token}"
      get :index, format: :json
      expect(response).to be_success
    end
    it 'should have pagination' do
      request.headers['Authorization'] = "Bearer #{user.token}"
      get :index, format: :json, page: 1, page_size: students.length
      expect(json_response).to include(
        :users, :page, :page_size, :total_pages
        )
      expect(json_response[:users].length).to be students.length
      expected_total_pages = (students.length + teachers.length) % students.length + 2
      expect(json_response[:total_pages]).to eql expected_total_pages
    end
    it 'should return all records' do
      request.headers['Authorization'] = "Bearer #{user.token}"
      get :index, format: :json, page: 1, page_size: students.length + teachers.length
      expect(json_response).to include(
        :users, :page, :page_size, :total_pages
        )
      expect(json_response[:total_pages]).to eql 2 # extra user for authentication
      expect(json_response[:page_size]).to eql students.length + teachers.length
      are_equal = json_response[:users].reduce do |memo, user|
        check = lambda {|other| other.id == user[:id]}
        memo && (students.any?(&check) || teachers.any?(&check))
      end
      expect(are_equal).to be true
    end
  end


  describe 'show' do
    let(:student) {FactoryGirl.create(:student)}
    it 'should not allow unauthorized requests' do
      get :show, format: :json, id: student.id
      expect(response).to be_unauthorized
    end
    it 'should show the correct user' do
      request.headers['Authorization'] = "Bearer #{student.token}"
      get :show, format: :json, id: student.id
      expect(json_response[:id]).to eql student.id
      expect(json_response).to include(
        :id, :email, :student, :major, :guc_suffix, :guc_prefix, :team, :name,
        :verified, :guc_id
        )
      expect(json_response).to_not include(
        :password_digest, :password
        )
    end
  end

  describe 'update' do
    let(:student_one) {FactoryGirl.create(:student)}
    let(:student_two) {FactoryGirl.create(:student)}
    let(:teacher_one) {FactoryGirl.create(:teacher)}
    let(:teacher_two) {FactoryGirl.create(:teacher)}

    it 'should not allow unauthorized updates' do
      old_digest = student_one.password_digest
      put :update, id: student_one.id, format: :json, password: 'new password!'
      expect(response).to be_unauthorized
      student_one.reload
      expect(student_one.password_digest).to eql old_digest
    end

    it 'should not allow a user to change another user' do
      old_digest = teacher_one.password_digest
      request.headers['Authorization'] = "Bearer #{student_two.token}"
      put :update, id: teacher_one.id, format: :json, password: 'new password!'
      expect(response).to be_forbidden
      teacher_one.reload
      expect(teacher_one.password_digest).to eql old_digest
    end

    it 'should allow a user to modify its fields' do
      old_digest = teacher_one.password_digest
      request.headers['Authorization'] = "Bearer #{teacher_one.token}"
      put :update, id: teacher_one.id, format: :json, password: 'new password!'
      expect(response).to be_success
      teacher_one.reload
      expect(teacher_one.password_digest).to_not eql old_digest
    end

    it 'should not allow a user to modify its email' do
      teacher_one.reload
      old_json = teacher_one.as_json
      request.headers['Authorization'] = "Bearer #{teacher_one.token}"
      put :update, id: teacher_one.id, format: :json, email: 'newteach@guc.edu.eg'
      expect(response).to be_unprocessable
      teacher_one.reload
      expect(teacher_one.as_json).to match old_json
    end

    it 'should allow a user to modify more than one field' do
      student_two.reload
      old_json = student_two.as_json
      request.headers['Authorization'] = "Bearer #{student_two.token}"
      put :update, id: student_two.id, format: :json, password: 'new password!', name: 'new name!'
      expect(response).to be_success
      student_two.reload
      expect(student_two.as_json).to_not match old_json
    end

    it 'should not allow a user to change its type' do
      request.headers['Authorization'] = "Bearer #{student_two.token}"
      put :update, id: student_two.id, format: :json, student: false
      expect(response).to be_unprocessable
      student_two.reload
      expect(student_two.student?).to be true
    end

    it 'should not allow a user to make its self verified' do
      request.headers['Authorization'] = "Bearer #{teacher_two.token}"
      put :update, id: teacher_two.id, format: :json, verified: true
      expect(response).to be_unprocessable
      teacher_two.reload
      expect(student_two.verified?).to be false
    end

  end

  describe 'create' do
    context 'with valid params' do
      context 'for student' do
        let(:student_params) {FactoryGirl.attributes_for(:student)}
        let(:teacher_params) {FactoryGirl.attributes_for(:teacher)}
        it 'should create a new student' do
          expect {
            post :create, format: :json, **student_params
          }.to change(User, :count).by 1
          expect(response).to be_created
        end
        it 'should create a new teacher' do
          expect {
            post :create, format: :json, **teacher_params
          }.to change(User, :count).by 1
          expect(response).to be_created
        end
        it 'should set new users to unverified' do
          post :create, format: :json, **teacher_params
          user = User.find json_response[:id]
          expect(user.verified?).to be false
        end
      end
    end
    context 'with invalid params' do
      let(:student_params) {FactoryGirl.attributes_for(:student)}
      let(:teacher_params) {FactoryGirl.attributes_for(:teacher)}
      it 'should not allow a user to set type' do
        student_params[:student] = false
        post :create, format: :json, **student_params
        expect(json_response[:student]).to be true
        expect(response).to be_created
      end
      it 'should not allow users to set verified' do
        teacher_params[:verified] = true
        post :create, format: :json, **teacher_params
        expect(json_response[:verified]).to be false
        expect(response).to be_created
      end
      it 'should not allow invalid params' do
        teacher_params.delete :email
        expect {
          post :create, format: :json, **teacher_params
        }.to change(User, :count).by 0
        expect(response).to be_unprocessable
      end
    end
  end

  describe 'destroy' do
    it 'should not be routable' do
      expect( delete: 'api/users/1').to_not be_routable
    end
  end

end
