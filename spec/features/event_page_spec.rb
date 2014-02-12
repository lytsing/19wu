require File.expand_path('../../spec_helper', __FILE__)

feature 'course page' do
  given(:content) {
    <<-MD
# title #

-   list
    MD
  }

  given(:course) { FactoryGirl.create(:course, :content => content, :user => login_user) }

  scenario 'I see the markdown formatted course content' do
    visit course_path(course)

    page.should have_selector('.course-body h1', :text => 'title')
    page.should have_selector('.course-body li', :text => 'list')
  end

  context 'with orders' do
    let(:orders) { create_list(:order_with_items, 5, course: course) }
    before { orders }
    scenario 'I see list of participants', js: true do
      visit course_path(course)
      page.should have_selector('.course-participants img.gravatar', :count => 5)
    end
  end
end
