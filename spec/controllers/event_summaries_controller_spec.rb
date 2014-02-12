require 'spec_helper'

describe CourseSummariesController do

  describe "GET new" do
    let(:user) { create(:user, :confirmed) }
    let(:course) { create(:course, user: user) }

    it "should render template :new" do
      login_user user
      get :new, course_id: course.id
      expect(response).to render_template(:new)
    end

    it "should set variable @course" do
      login_user user
      get :new, course_id: course.id
      expect(assigns(:course)).to eq(course)
    end

    it "should set variable @summary to a new CourseSummary object" do
      login_user user
      get :new, course_id: course.id
      expect(assigns(:summary)).to be_a_new(CourseSummary)
    end
  end

  describe "POST create" do
    let(:user) { create(:user, :confirmed) }
    let(:course) { create(:course, user: user) }

    context "with valid input" do
      it "should save course_summary to DB" do
        login_user user
        course_summary_attributes = FactoryGirl.attributes_for(:course_summary, :course => course)
        expect {
          post :create, course_id: course.id, course_summary: course_summary_attributes
        }.to change{ CourseSummary.count }.by(1)
      end

      it "should redirect to course show page" do
        login_user user
        course_summary_attributes = FactoryGirl.attributes_for(:course_summary, :course => course)
        post :create, course_id: course.id, course_summary: course_summary_attributes
        expect(response).to redirect_to course_path(course)
      end
    end

    context "with invalid input" do
      it "should not save course_summary to DB" do
        login_user user
        expect {
          post :create, course_id: course.id, course_summary: { content: "test" }
        }.to change{ CourseSummary.count }.by(0)
      end

      it "should render new template" do
        login_user user
        post :create, course_id: course.id, course_summary: { content: "test" }
        expect(response).to render_template(:new)
      end
    end
  end

  describe "PATCH update" do
    let(:user) { create(:user, :confirmed) }
    let(:course) { create(:course, user: user) }

    context "with valid data" do
      it "should update course summary" do
        login_user user
        summary = create(:course_summary, course: course)
        patch :update, course_id: course.id, course_summary: { content: "12345678900987654321" }
        expect(summary.reload.content).to eq("12345678900987654321")
      end

      it "should redirect to course show page" do
        login_user user
        summary = create(:course_summary, course: course)
        patch :update, course_id: course.id, course_summary: { content: "12345678900987654321" }
        expect(response).to redirect_to course_path(course)
      end
    end

    context "with invalid data" do
      it "should not update course summary" do
        login_user user
        summary = create(:course_summary, course: course)
        patch :update, course_id: course.id, course_summary: { content: "abc" }
        expect(summary.reload.content).to_not eq("abc")
      end

      it "should render :new template" do
        login_user user
        summary = create(:course_summary, course: course)
        patch :update, course_id: course.id, course_summary: { content: "abc" }
        expect(response).to render_template(:new)
      end
    end
  end
end
