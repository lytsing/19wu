# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :course_order do
    course
    user
    price 1.5

    factory :order_with_items do
      ignore do
        items_count 1
        quantity 1
        tickets_price 299
        require_invoice false
        paid false
      end
      after(:build) do |order, evaluator|
        FactoryGirl.create_list(:ticket, evaluator.items_count, price: evaluator.tickets_price, require_invoice: evaluator.require_invoice, course: order.course).each do |ticket|
          order.items.build ticket: ticket, quantity: evaluator.quantity, price: ticket.price
        end
        if order.require_invoice
          order.shipping_address_attributes = attributes_for(:shipping_address)
        end
      end
      after(:create) do |order, evaluator|
        order.pay!('2013080841700373') if evaluator.paid
      end
    end
  end

  factory :order, parent: :course_order do
  end
end
