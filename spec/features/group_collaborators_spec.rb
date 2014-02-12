# encoding: utf-8
require File.expand_path('../../spec_helper', __FILE__)

feature 'group collaborators', js: true do
  given(:user) { create(:user, :confirmed) }
  given(:course) { create(:course, user: user) }
  given(:partner) { create(:user, :confirmed) }
  given(:collaborator) { create(:group_collaborator, group_id: course.group.id, user_id: partner.id) }
  context 'as a group creator sign in' do
    before { sign_in user }
    scenario 'I can see the collaborators menu' do
      visit course_path(course)
      page.should have_content(I18n.t('views.groups.collaborators'))
    end
    context 'with a collaborator' do
      before do
        collaborator
        visit course_collaborators_path(course_id: course.id)
      end
      scenario 'I see the collaborator' do
        within '.collaborators-list' do
          page.should have_content(partner.login)
        end
      end
      scenario 'I can destroy the collaborator' do
        within '.collaborators-list' do
          find('.text-error').click
          page.should_not have_content(partner.login)
        end
      end
    end
    scenario 'I can add a collaborator' do
      visit course_collaborators_path(course_id: course.id)
      within '.collaborators-list' do
        find('input').set partner.login
        find('.typeahead.dropdown-menu li').click
        click_on I18n.t('helpers.submit.add')
        within '.list' do
          page.should have_content(partner.login)
        end
      end
    end
  end
  context 'as a collaborator sign in' do
    before do
      collaborator
      sign_in partner
    end
    scenario 'I can not see the collaborators menu' do
      visit course_path(course)
      page.should_not have_content(I18n.t('views.groups.collaborators'))
    end
    scenario 'I can update course' do
      visit edit_course_path(course)
      fill_in 'course_title', with: 'new course title'
      click_on '更新课程'
      page.should have_content(I18n.t('flash.courses.updated'))
    end
  end
end
