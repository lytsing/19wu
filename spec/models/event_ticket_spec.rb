require 'spec_helper'

describe CourseTicket do
  let(:course) { create :course }
  describe '#tickets_quantity' do
    let(:ticket) { build(:course_ticket, course: Course.find(course.id), tickets_quantity: 400) }
    describe '#create' do
      subject { ticket.tap(&:save) }
      its(:tickets_quantity) { should eql 400 }
    end

    context 'exists' do
      before { ticket.save }
      subject { course.reload }
      describe '#update' do
        before { ticket.update_attribute :tickets_quantity, 500 }
        its(:tickets_quantity) { should eql 500 }
      end

      describe '#destroy' do
        context 'with other ticket' do
          before do
            create(:course_ticket, course: Course.find(course.id), name: 'other', tickets_quantity: 500)
            ticket.destroy
          end
          its(:tickets_quantity) { should eql 500 }
        end
        context 'without other ticket' do
          before { course.tickets.destroy_all }
          its(:tickets_quantity) { should eql nil }
        end
      end
    end
  end
end
