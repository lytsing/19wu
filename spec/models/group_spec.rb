require 'spec_helper'

describe Group do
  describe "#last_course_with_summary" do
    let(:user) { create(:user, :confirmed) }
    let(:course1) { create(:course, user: user, start_time: 6.day.ago, end_time: 5.day.ago) }
    let(:course2) { create(:course, user: user, start_time: 4.day.ago, end_time: 3.day.ago) }
    let(:course3) { create(:course, user: user, start_time: 2.day.ago, end_time: 1.day.ago) }

    it "should reture the last course with summary" do
      create(:course_summary, course: course1)
      create(:course_summary, course: course2)

      course1.group.last_course_with_summary.should == course2
    end

    it "should return nil if none of the courses has a summary" do
      course1.group.last_course_with_summary.should == nil
    end
  end
end
