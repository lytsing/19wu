# -*- coding: utf-8 -*-
class MoveCourseParticipantToOrderParticipant < ActiveRecord::Migration
  class CourseParticipant < ActiveRecord::Base # faux model
    belongs_to :course
    belongs_to :user
  end

  module ChinaSMS; def to(*params); end; end # don't send sms
  class OrderMailer; def self.delay; self; end; end # and don't send email
  class OrderMailer; def self.method_missing(*a); end; end

  def up
    CourseParticipant.all.each do |participant|
      course = participant.course
      ticket = course.tickets.first_or_create name: '门票', price: 0
      order = course.orders.create user: participant.user, items_attributes: [{ticket: ticket, quantity: 1}]
      order.create_participant
      if participant.joined
        order.participant.update_attribute :checkin_at, participant.updated_at
      end
    end
    drop_table :course_participants
  end

  def down
    create_table :course_participants do |t|
      t.integer :course_id
      t.integer :user_id
      t.boolean :joined, null: false, default: false

      t.timestamps
    end
    add_index :course_participants, :course_id
    add_index :course_participants, :user_id

    CourseOrderParticipant.all.each do |participant|
      CourseParticipant.create course: participant.course, user: participant.user, joined: !!participant.joined?
    end
  end
end
