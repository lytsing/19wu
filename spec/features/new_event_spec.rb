require 'spec_helper'

feature 'new course' do
  let(:user) { create :user }
  let(:submit) { I18n.t('helpers.submit.course.create') }
  let(:flash) { I18n.t('flash.courses.created') }
  let(:attributes) { attributes_for(:course, :markdown) }
  before { sign_in }

  scenario 'I create the course with valid attributes' do
    visit new_course_path

    fill_in 'course_title', with: attributes[:title]
    fill_in 'course_slug', with: attributes[:slug]
    fill_in 'course_compound_start_time_attributes_date', with: attributes[:start_time].strftime("%Y-%m-%d") 
    fill_in 'course_compound_start_time_attributes_time', with: attributes[:start_time].strftime("%H:%M:%S")
    fill_in 'course_compound_end_time_attributes_date', with: attributes[:end_time].strftime("%Y-%m-%d")
    fill_in 'course_compound_end_time_attributes_time', with: attributes[:end_time].strftime("%H:%M:%S")  
    fill_in 'course_location', with: attributes[:location]
    fill_in 'course_content', with: attributes[:content]

    click_button submit
    expect(page).to have_content(flash)
  end
end
