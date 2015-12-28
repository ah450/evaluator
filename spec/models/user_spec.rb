require 'rails_helper'

RSpec.describe User, type: :model do

  describe 'student' do
    
    describe 'validation' do
      let(:student) {FactoryGirl.build(:student)}
      it 'has a valid factory' do
        expect(student).to be_valid
      end
      context 'email is nil' do
        let(:student) {FactoryGirl.build(:student, email: nil)}
        it 'should not be valid' do
          expect(student).to_not be_valid
        end
      end
      context 'email is belongs to a non guc domain' do
        let(:student) {FactoryGirl.build(:student, email: 'student@example.com')}
        it 'should not be valid' do
          expect(student).to_not be_valid
        end
      end
      context 'unique email' do
        let(:first) {FactoryGirl.create(:student)}
        let(:second){FactoryGirl.build(:student)}
        it 'should not allow duplicate emails' do
          second.email = first.email.capitalize
          expect(second).to_not be_valid
        end
      end

      context 'name is nil' do
        let(:student) {FactoryGirl.build(:student, name: nil)}
        it 'should not be valid' do
          expect(student).to_not be_valid
        end
      end

      context 'password is nil' do
        let(:student) {FactoryGirl.build(:student, password: nil)}
        it 'should not be valid' do
          expect(student).to_not be_valid
        end
      end

      context 'password is less than 2 chatactes' do
        let(:student) {FactoryGirl.build(:student, password: 's')}
        it 'should not be valid' do
          expect(student).to_not be_valid
        end
      end

      context 'major is nil' do
        let(:student) {FactoryGirl.build(:student, major: nil)}
        it 'should not be valid' do
          expect(student).to_not be_valid
        end
      end

      context 'team is nil' do
        let(:student) {FactoryGirl.build(:student, team:nil)}
        it 'should not be valid' do
          expect(student).to_not be_valid
        end
      end

      context 'GUC id' do
        context 'only suffix is nil' do
          let(:student){FactoryGirl.build(:student, guc_suffix: nil)}
          it 'should not be valid' do
            expect(student).to_not be_valid
          end
        end
        context 'only prefix is nil' do
          let(:student) {FactoryGirl.build(:student, guc_prefix: nil)}
          it 'should not be valid' do
            expect(student).to_not be_valid
          end
        end
        context 'suffix and prefix' do
          let(:student){FactoryGirl.build(:student, guc_prefix: nil, guc_suffix: nil)}
          it 'should not be valid' do
            expect(student).to_not be_valid
          end
        end
      end

    end # Validations

    describe 'type detection' do
      let(:student) {FactoryGirl.build(:student)}
      it "should know it's a student" do
        student.save!
        expect(student.student?).to be true
      end
    end

    describe 'Token generation' do
      let(:student) {FactoryGirl.create(:student)}
      it 'should be able to create a token' do
        expect(student.token).to be_a_kind_of String
      end
      it 'should be able to retrive a student by its token' do
        token = student.token
        expect(User.find_by_token(token)).to eql student
      end
    end

    describe 'GUC id attribute' do
      let(:student) {FactoryGirl.create(:student)}
      it 'should be constructed correctly from prefix and suffix' do
        expect(student.guc_id).to eql "#{student.guc_prefix}-#{student.guc_suffix}"
      end
      it 'should set prefix and suffix based on it' do
        student.guc_id = "99-32"
        expect(student.guc_prefix).to eql 99
        expect(student.guc_suffix).to eql 32
      end
    end

  end # Student specs

  describe 'type scope' do
    let(:teachers) { FactoryGirl.create_list(:teacher, 10) }
    let(:students) { FactoryGirl.create_list(:student, 10) }
    it 'should query by teachers' do
      are_teachers = User.teachers.reduce { |memo, user| memo && user.teacher? }
      expect(are_teachers).to_not be true
    end
    it 'should query by students' do
      are_students = User.students.reduce { |memo, user| memo && user.student? }
      expect(are_students).to_not be true
    end
  end

  describe 'Teacher' do
    
    describe 'validation' do
      let(:teacher) {FactoryGirl.build(:teacher)}
      it 'has a valid factory' do
        expect(teacher).to be_valid
      end
      context 'email is nil' do
        let(:teacher) {FactoryGirl.build(:teacher, email: nil)}
        it 'should not be valid' do
          expect(teacher).to_not be_valid
        end
      end
      context 'email is belongs to a non guc domain' do
        let(:teacher) {FactoryGirl.build(:teacher, email: 'teacher@example.com')}
        it 'should not be valid' do
          expect(teacher).to_not be_valid
        end
      end
      context 'unique email' do
        let(:first) {FactoryGirl.create(:teacher)}
        let(:second){FactoryGirl.build(:teacher)}
        it 'should not allow duplicate emails' do
          second.email = first.email.capitalize
          expect(second).to_not be_valid
        end
      end

      context 'name is nil' do
        let(:teacher) {FactoryGirl.build(:teacher, name: nil)}
        it 'should not be valid' do
          expect(teacher).to_not be_valid
        end
      end

      context 'password is nil' do
        let(:teacher) {FactoryGirl.build(:teacher, password: nil)}
        it 'should not be valid' do
          expect(teacher).to_not be_valid
        end
      end

      context 'password is less than 2 chatactes' do
        let(:teacher) {FactoryGirl.build(:teacher, password: 's')}
        it 'should not be valid' do
          expect(teacher).to_not be_valid
        end
      end
    end # Validations
    describe 'type detection' do
      let(:teacher) {FactoryGirl.build(:teacher)}
      it "should know it's a teacher" do
        teacher.save!
        expect(teacher.teacher?).to be true
      end
    end

    describe 'Token generation' do
      let(:teacher) {FactoryGirl.create(:teacher)}
      it 'should be able to create a token' do
        expect(teacher.token).to be_a_kind_of String
      end
      it 'should be able to retrive a teacher by its token' do
        token = teacher.token
        expect(User.find_by_token(token)).to eql teacher
      end
    end

  end # Teacher specs


end
