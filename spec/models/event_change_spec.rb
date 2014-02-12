# encoding: utf-8
require 'spec_helper'

describe CourseChange do
  describe 'send change to participants' do
    let(:user) { create(:user, :confirmed) }
    let(:course) { create(:course, user: user, title: '深圳Rubyist课程') }
    let!(:order1) { create(:order_with_items, course: course) }
    let!(:order2) { create(:order_with_items, course: course) }
    let(:change) { create(:course_change, course: course) }
    describe 'by email' do
      subject { ActionMailer::Base.deliveries.last }
      before do
        ChinaSMS.stub(:to)
        ActionMailer::Base.deliveries.clear
        change
      end
      its(:subject) { should eql '「重要」深圳Rubyist课程 变更通知' }
      its('body.decoded') { should match change.content }
    end
    describe 'by sms' do
      it 'should be success' do
        phones = [order2.user.phone, order1.user.phone].sort
        ChinaSMS.stub(:to).with(phones, I18n.t('sms.course.change', content: attributes_for(:course_change)[:content]))
        change
      end
    end
  end
end
