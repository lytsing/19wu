# encoding: utf-8
require File.expand_path('../../spec_helper', __FILE__)

feature 'user orders' do
  given(:user) { create(:user, :confirmed) }
  given(:course) { create(:course, user: user) }
  given(:order) { create(:order_with_items, items_count: 2, course: course, user: user) }

  before do
    sign_in user
  end

  context 'pending to pay' do
    before { order }

    scenario 'I can see pay link and cancel link' do
      visit user_orders_path

      expect(page).to have_content("#{I18n.t('views.my_orders.pay')} |")
      expect(page).to have_content("| #{I18n.t('views.my_orders.cancel')}")
    end

    scenario 'I can not see pay link and cancel link when course finished' do
      course.update! start_time: 7.days.ago, end_time: 6.days.ago

      visit user_orders_path

      expect(page).to have_no_content("#{I18n.t('views.my_orders.pay')} |")
      expect(page).to have_no_content("| #{I18n.t('views.my_orders.cancel')}")
    end

    scenario 'I can cancel order', js: true do
      visit user_orders_path

      stub_confirm
      find('a', text: I18n.t('views.my_orders.cancel')).click

      expect(page).to have_content(I18n.t('canceled', scope: 'activerecord.state_machines.course_order.states'))
    end
  end

  context 'has paid' do
    before { order.pay!('2013080841700373') }

    scenario 'I can refund at least 7 days before course starts', js: true do
      visit user_orders_path
      expect(page).to have_content(I18n.t('views.my_orders.request_refund'))

      stub_confirm
      find('a', text: I18n.t('views.my_orders.request_refund')).click
      expect(page).to have_content(I18n.t('refund_pending', scope: 'activerecord.state_machines.course_order.states'))
    end

    scenario 'I can not refund order when course draws near' do
      course.update! start_time: 1.days.since, end_time: 2.days.since

      visit user_orders_path

      expect(page).to have_no_content(I18n.t('views.my_orders.request_refund'))
    end
  end

  context 'has a free course' do
    given(:free_order) { create(:order_with_items, tickets_price: 0, course: course, user: user) }
    before { free_order }
    scenario 'the request_refund button has not show' do
      free_order.update! status: 'paid'
      visit user_orders_path
      expect(page).to have_no_content(I18n.t('views.my_orders.request_refund'))
    end
  end
end
