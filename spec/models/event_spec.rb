# coding: utf-8
require 'spec_helper'

describe Event do
  let(:course) { build :course }

  it "passes validation with all valid informations" do
    expect(course).to be_valid
  end

  context "validation" do
    it "with a blank title" do
      course.title = ''
      expect(course.save).to be_false
    end

    it "with a blank start_time" do
      course.start_time = ''
      expect(course.save).to be_false
    end

    it "with a blank location" do
      course.location = ''
      expect(course.save).to be_false
    end

    it "with start_time > end_time" do
      course.start_time = "2012-12-31 08:00:51"
      course.end_time = "2012-12-31 08:00:50"
      expect(course.save).to be_false
    end

    describe 'slug' do
      subject { course }
      context 'is blank' do
        before { course.slug = '' }
        its(:valid?) { should be_false }
      end
      context 'has not been taken' do
        before { course.slug = 'rubyconfchina' }
        its(:valid?) { should be_true }
      end
      context 'has been taken' do
        context 'by other group' do
          let(:group) { create(:group) }
          before { course.slug = group.slug }
          context 'is not a collaborator' do
            its(:valid?) { should be_false }
          end
          context 'is a collaborator' do
            let(:partner) { create(:user) }
            let(:collaborator) { create(:group_collaborator, group_id: group.id, user_id: partner.id) }
            before do
              collaborator
              course.user = partner
            end
            its(:valid?) { should be_true }
          end
        end
        context 'by other user' do
          before { course.slug = course.user.login }
          its(:valid?) { should be_false }
        end
        context 'by routes' do
          before { course.slug = 'photos' }
          its(:valid?) { should be_false }
        end
      end
    end
  end

  describe 'content_html' do
    context 'when content is "# title #"' do
      subject { build :course, :content => '# title #' }
      its(:content_html) { should include('<h1>title</h1>') }
    end
  end

  describe 'location_guide_html' do
    context 'when content is "# map #"' do
      subject { build :course, :location_guide => '# map #' }
      its(:location_guide_html) { should include('<h1>map</h1>') }
    end
  end

  describe '#ordered_users.recent' do
    let(:course) { create(:course) }
    let!(:order1) {
      Timecop.freeze('2010-11-12') do
        create(:order_with_items, course: course)
      end
    }
    let!(:order2) {
      Timecop.freeze('2010-11-13') do
        create(:order_with_items, course: course)
      end
    }
    it 'sorts users by join date' do
      course.ordered_users.recent.should == [order2.user, order1.user]
    end
    it 'can limit the number of users' do
      course.ordered_users.recent(1).should have(1).user
    end
  end

  describe '#sibling_courses' do
    it 'should return all courses under the same group except itself' do
      user   = create(:user)
      course1 = create(:course, :user => user)
      course2 = create(:course, :user => user)

      course1.sibling_courses.should == [course2]
    end
  end

  describe '#upcoming' do
    it 'returns only courses start on tomorrow' do
      create(:course, :slug => 'e1', :start_time => '2013-05-25')
      create(:course, :slug => 'e2', :start_time => '2013-05-27')
      course_tomorrow = create(:course, :slug => 'e3', :start_time => '2013-05-26')

      today = Time.zone.parse('2013-05-25')
      Event.upcoming(today).should == [course_tomorrow]
    end
  end

  describe '#remind_participants' do
    let(:user) { create(:user, :confirmed) }
    let(:course) { create(:course, start_time: 1.day.since, end_time: nil, user: user) }
    let(:order) { create(:order_with_items, course: course) }
    subject { ActionMailer::Base.deliveries.last }

    before do
      order
      ActionMailer::Base.deliveries.clear
    end

    it 'should remind all participants' do
      Event.remind_participants
      subject.subject.should eql '课程盒子课程提醒'
      subject.to.should eql [order.user.email]
    end
  end

  describe '#started?' do
    subject { course }
    context '2 days ago' do
      before { course.update_attribute :start_time, 2.day.ago }
      its(:started?) { should be_true }
    end
    context '1 day later' do
      before { course.update_attribute :start_time, 1.day.since }
      its(:started?) { should be_false }
    end
  end

  describe '#finished?' do
    subject { course }
    context '2 days ago' do
      before { course.update_attribute :end_time, 2.day.ago }
      its(:finished?) { should be_true }
    end
    context '1 day later' do
      before { course.update_attribute :end_time, 1.day.since }
      its(:finished?) { should be_false }
    end
  end

  describe '#show_summary?' do
    let(:user) { create(:user) }

    it 'should return true if it has a summary' do
      course1 = create(:course, user: user, start_time: 6.day.ago, end_time: 5.day.ago)
      course2 = create(:course, user: user, start_time: 4.day.ago, end_time: 3.day.ago)
      course3 = create(:course, user: user, start_time: 1.day.since, end_time: 2.day.since)
      create(:course_summary, course: course2)

      course2.show_summary?.should == true
    end

    it 'should return ture if it has no summary and it is not finished and its group has an course with summary' do
      course1 = create(:course, user: user, start_time: 6.day.ago, end_time: 5.day.ago)
      course2 = create(:course, user: user, start_time: 4.day.ago, end_time: 3.day.ago)
      course3 = create(:course, user: user, start_time: 1.day.since, end_time: 2.day.since)
      create(:course_summary, course: course2)

      course3.show_summary?.should == true
    end

    it 'should return false if it is finished and has not summary' do
      course1 = create(:course, user: user, start_time: 6.day.ago, end_time: 5.day.ago)
      course2 = create(:course, user: user, start_time: 4.day.ago, end_time: 3.day.ago)
      course3 = create(:course, user: user, start_time: 1.day.since, end_time: 2.day.since)
      create(:course_summary, course: course1)

      course2.show_summary?.should == false
    end

    it 'should return false if is not finished and none of its siblings has a summary' do
      course1 = create(:course, user: user, start_time: 6.day.ago, end_time: 5.day.ago)
      course2 = create(:course, user: user, start_time: 4.day.ago, end_time: 3.day.ago)
      course3 = create(:course, user: user, start_time: 1.day.since, end_time: 2.day.since)

      course3.show_summary?.should == false
    end
  end

  describe '#checkin_code' do
    it "should return the checkin code of course" do
      course = create(:course, slug: "ruby", created_at: '2013-05-05 23:12:08')
      expect(course.checkin_code).to eq '328'
    end
  end

  describe 'tickets' do
    subject { course.tap(&:save) }
    its('tickets.size') { should eql 1 }
  end
end
