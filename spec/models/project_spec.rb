require 'rails_helper'

RSpec.describe Project, type: :model do
  describe 'validations' do
    let(:project) {FactoryGirl.build(:project)}
    it 'has a valid factory' do
      expect(project).to be_valid
    end
    context 'name is nil' do
      it 'should not be valid' do
        project.name = nil
        expect(project).to_not be_valid
      end
    end
    context 'due_date is nil' do
      it 'should not be valid' do
        project.due_date = nil
        expect(project).to_not be_valid
      end
    end

    context 'course is nil' do
      it 'should not be valid' do
        project.course = nil
        expect(project).to_not be_valid
      end
    end

    context 'unique name per course' do
      it 'should not be valid' do
        project.save!
        other = FactoryGirl.build(:project, name: project.name)
        other.course = project.course
        expect(other).to_not be_valid
      end
      it 'should be valid' do
        other = FactoryGirl.build(:project, name: project.name)
        expect(other).to be_valid
      end
    end

    context 'query by due date' do
      it 'should select due only' do
        FactoryGirl.create_list(:project, 5)
        FactoryGirl.create_list(:project, 3, due_date: 5.days.ago)
        projects = Project.due
        expect(projects.count).to eql 3
      end
      it 'should select non due only' do
        FactoryGirl.create_list(:project, 5)
        FactoryGirl.create_list(:project, 3, due_date: 5.days.ago)
        projects = Project.not_due
        expect(projects.count).to eql 5
      end
    end

    context 'query by published' do
      it 'should select published only' do
        FactoryGirl.create_list(:project, 5)
        FactoryGirl.create_list(:project, 3, published: true)
        projects = Project.published
        expect(projects.count).to eql 3
      end
      it 'should select non published only' do
        FactoryGirl.create_list(:project, 5)
        FactoryGirl.create_list(:project, 3, published: true)
        projects = Project.not_published
        expect(projects.count).to eql 5
      end
    end

  end
end
