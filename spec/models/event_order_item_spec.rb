require 'spec_helper'

describe CourseOrderItem do
  let(:course) { create(:course) }
  let(:order) { create(:order_with_items, course: course, quantity: 2) }
  let(:order_item) { order.items.first }

  describe 'create' do
    subject { order_item }
    its(:unit_price) { should eql 299.0 }
  end
end
