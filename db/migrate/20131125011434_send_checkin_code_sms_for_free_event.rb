class SendCheckinCodeSmsForFreeCourse < ActiveRecord::Migration
  def change
    Course.all.reject{|e| e.finished? or e.started?}.each do |course|
      course.orders.each do |order|
        order.create_participant if order.free? # 正在进行的免费课程补发签到码
      end
    end
  end
end
