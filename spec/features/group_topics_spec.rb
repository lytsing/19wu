# encoding: utf-8
require File.expand_path('../../spec_helper', __FILE__)

feature 'group topics' do
  given(:user) { create(:user, :confirmed) }
  given(:course) { create(:course, user: user) }
  given(:topic) { build(:group_topic, group: course.group, user: user) }
  scenario 'I can create a topic' do
    sign_in user
    visit course_path(course)
    click_on I18n.t('views.courses.topics.new.button')
    fill_in 'group_topic[title]', with: topic.title
    fill_in 'group_topic[body]', with: topic.body
    click_on '新增贴子'
    page.should have_content(topic.title)
    click_on topic.title
    page.should have_content(topic.body)
  end
  context 'with a topic' do
    before { topic.save }
    scenario 'I can see topic item title' do
      visit course_path(course)
      page.should have_content(topic.title)
    end
    scenario 'I can see topic content' do
      visit course_topic_path(course, topic)
      page.should have_content(topic.title)
      page.should have_content(topic.body)
    end
    describe 'reply' do
      given(:reply) { build(:group_topic_reply, group_topic_id: topic.id, user: user) }
      scenario 'I can create a reply' do
        sign_in user
        visit course_topic_path(course, topic)
        fill_in 'group_topic_reply[body]', with: reply.body
        click_on '提交回复'
        page.should have_content(reply.body)
      end
      context 'with a reply' do
        before do
          reply.save
          topic.replies_count = 1
        end
        scenario 'I can see it' do
          visit course_topic_path(course, topic)
          page.should have_content(reply.body)
        end
        scenario 'show replies count with this topic' do
          visit course_path(course)
          find("li#group_topic_#{topic.id} div.media-body span.replies-count").should have_content(topic.replies.size)
        end
      end
    end
  end
end
