require 'spec_helper'

describe GroupController do

  describe "GET 'show'" do
    let(:course) { create :course }
    it "returns http success" do
      get 'course', :slug => course.group.slug
      response.should be_success
    end
  end

  describe "GET 'followers'" do
    let(:course) { create :course }
    it "returns http success" do
      get 'course', :slug => course.group.slug
      response.should be_success
    end
  end

end
