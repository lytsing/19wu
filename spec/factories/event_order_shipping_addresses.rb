# -*- coding: utf-8 -*-
# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :course_order_shipping_address do
    order_id 1
    invoice_title "深圳市课程盒子电子商务有限公司"
    province "440000"
    city "440300"
    district "440305"
    address "科技园南区"
    name "saberma"
    phone "13928452888"
  end

  factory :shipping_address, parent: :course_order_shipping_address do
  end
end
