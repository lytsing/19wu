require File.expand_path('../../spec_helper', __FILE__)
require 'cancan/matchers'

describe Ability do
  subject { Ability.new(user) }
  context "when user has not signed in" do
    let(:user) { nil }
    context 'course' do
      it{ should_not be_able_to(:update, create(:course)) }
    end
    context 'order' do
      it{ should_not be_able_to(:confirm_pay, EventOrder) }
    end
  end

  context "when user has signed in" do
    let(:user) { create(:user) }
    context 'course' do
      context 'belongs to him' do
        let(:course) { create(:course, :user => user) }
        it{ should be_able_to(:update, course) }
        it{ should be_able_to(:update, course.group) }
      end
      context 'belongs to others' do
        let(:course) { create(:course) }
        it{ should_not be_able_to(:update, course) }
        it{ should_not be_able_to(:update, course.group) }
        context 'he is the collaborator' do
          let(:collaborator) { create(:group_collaborator, group_id: course.group.id, user_id: user.id) }
          before { collaborator }
          it{ should be_able_to(:create, Event) }
          it{ should be_able_to(:update, course) }
        end
      end
      context 'order' do
        it{ should_not be_able_to(:confirm_pay, EventOrder) }
      end
    end

    context "when admin has signed in" do
      let(:user) { create(:user, :admin) }
      context 'order' do
        it{ should be_able_to(:confirm_pay, EventOrder) }
      end
    end
  end
end
