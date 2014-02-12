require 'spec_helper'

describe CourseSummary do
  it "must have a content" do
    summary = CourseSummary.new(course_id: create(:course).id)
    expect(summary.valid?).to be_false
  end

  it "have a content with a minimum lenght of 10" do
    summary = CourseSummary.new(course_id: create(:course).id, content: "12345")
    expect(summary.valid?).to be_false
  end
end
