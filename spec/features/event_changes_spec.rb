# encoding: utf-8
require File.expand_path('../../spec_helper', __FILE__)

feature 'course changes' do
  given(:user) { create(:user, :confirmed) }
  given(:course) { create(:course, user: user) }
  given(:content) { attributes_for(:course_change)[:content] }
  before { sign_in user }
  scenario 'I can create changes' do
    visit new_course_change_path(course)
    fill_in 'course_change[content]', with: content
    click_on '新增变更'
    page.should have_content(content)
  end
end
