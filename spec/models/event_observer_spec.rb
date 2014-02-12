# encoding: utf-8
require 'spec_helper'

describe CourseObserver do
  context 'create' do
    let(:user) { create :user }
    let(:course) { create :course, user: user }
    let(:participant) { create :user }
    let(:new_course) { create :course, user: user, title: 'SH Ruby' }
    subject { ActionMailer::Base.deliveries.last }
    before do
      participant.follow course.group
      ActionMailer::Base.deliveries.clear
      new_course
    end
    it 'should notify all followers' do
      subject.subject.should eql '课程盒子新课程 - SH Ruby'
      subject.body.decoded.should match /http:\/\/localhost:3000\/rubyconf/
    end
  end
  context 'save' do
    subject { create :course }
    its(:group) { should_not be_nil }
  end
  context 'update' do
    subject { create :course }
    describe 'orgin group' do
      context 'has not courses' do
        it 'should be destroy' do
          subject
          expect do
            subject.update_attributes! :slug => 'rubyconf'
          end.not_to change{Group.count}
        end
      end
      context 'still has courses' do
        before { create :course, user: subject.user }
        it 'should not be destroy' do
          expect do
            subject.update_attributes! :slug => 'rubyconf'
          end.to change{Group.count}.by(1)
        end
      end
    end
  end
end
