require File.expand_path('../../spec_helper', __FILE__)

feature 'follower page' do
  describe 'create course with participant info' do   
    let(:course) { create(:course, :user => create(:user)) }
    let(:participant) { login_user }
    subject { course.group }

    before do
      Course.stub(:find).with(course.id.to_s).and_return(course)
      participant.follow(subject) 
    end

    describe 'init show' do
      it "has user information" do
        visit course_path(course)+'/followers'
        page.should have_selector('a', text: course.title)
        page.find("li#group_course_#{participant.id} span.follower-login-name").should have_content(participant.login)
      end
    end

  end
end
