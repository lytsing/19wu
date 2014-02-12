# encoding: utf-8
require 'spec_helper'

describe EventOrderHelper do
  describe '#stats_tickets_price' do
    let(:course) { create :course }
    let!(:orders) { create_list(:order_with_items, 6, tickets_price: 0.01, course: course) }
    subject { helper.stats_tickets_price(orders) }
    it { should eql 0.06 }
    it { should_not eql 0.060000000000000005 }
  end
end
