require 'spec_helper'

feature "Fallback Url" do
  given(:course) { create :course, slug: 'ruby-conf-china' }
  before do
    course.update_attributes! slug: 'rubyconfchina'
  end
  scenario "I can use origin url to visit course page" do
    visit '/ruby-conf-china'
    page.should have_content course.title
  end
end
