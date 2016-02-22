course = FactoryGirl.create(:course, published: true)
project = FactoryGirl.create(:project, course: course, published: true)
submissions = FactoryGirl.create_list(:submission_with_code, 10, project: project)