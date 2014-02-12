require 'spec_helper'

describe CoursesController do

  describe "GET 'index'" do
    login_user
    it "renders the course list" do
      get 'index'
      response.should render_template('index')
    end
  end

  describe "GET 'ordered'" do
    login_user
    it "renders the course list" do
      get 'ordered'
      response.should render_template('ordered')
    end
  end

  describe "GET 'new'" do
    context 'when user has signed in' do
      let(:user) { login_user }
      before { login_user }
      it "builds a new course" do
        get 'new'
        assigns[:course].should be_a_kind_of(Course)
        assigns[:course].should be_a_new_record
      end
      it "renders the new course form" do
        get 'new'
        response.should render_template('new')
      end
      context 'with other course' do
        let(:course) { create(:course, user: user) }
        before { course }
        it "should show source courses" do
          get 'new'
          assigns[:source_courses].should_not be_empty
        end
        it "should be copy" do
          get 'new', from: course.id
          assigns[:course].should be_a_new_record
          assigns[:course].title.should eql course.title
        end
      end
    end
    context 'when user has not yet signed in' do
      it "should be redirect" do
        get 'new'
        response.should be_redirect
      end
    end
  end

  describe "POST 'create'" do
    context 'when user has signed in' do
      login_user
      let(:valid_attributes) { attributes_for(:course) }
      context 'with valid attributes' do
        it 'creates the course' do
          expect {
            post 'create', :course => valid_attributes
          }.to change{Course.count}.by(1)
        end
      end
      context 'with invalid attributes' do # issue#392
        render_views
        it 'should not creates the course' do
          expect {
            post 'create', :course => valid_attributes.except(:start_time)
          }.to_not change{Course.count}
          response.should be_success
        end
      end

      context 'post with compound_start_time_attributes' do
        let(:compound_start_time_attributes) do
          {
            'date' => '2013-12-31',
            'time' => '12:10:30 PM'
          }
        end
        let(:attributes) do
          valid_attributes.except('start_time').
            merge('compound_start_time_attributes' => compound_start_time_attributes)
        end

        it 'creates course with date 2013-12-31 12:10:30' do
          post 'create', :course => attributes
          assigns[:course].start_time.should == Time.zone.parse('2013-12-31 12:10:30')
        end
      end
    end
    context 'when user has not yet signed in' do
      it "should be redirect" do
        post 'create'
        response.should be_redirect
      end
    end
  end

  describe "PATCH 'update'" do
    let(:course_creator) { login_user }
    let(:course) { FactoryGirl.create(:course, user: course_creator) }
    let(:valid_attributes) { attributes_for(:course) }
    context 'when user has signed in' do
      context 'with valid attributes' do
        it 'update the course' do
          patch 'update', :id => course.id, :course => valid_attributes
          response.should redirect_to(edit_course_path(course))
        end
      end

      context 'update all attributes' do
        let(:compound_start_time_attributes) do
          {
            'date' => '2013-01-08',
            'time' => '4:10:30 PM'
          }
        end
        let(:compound_end_time_attributes) do
          {
            'date' => '2013-01-08',
            'time' => '6:10:30 PM'
          }
        end
        let(:attributes) do
          valid_attributes.merge(
                'title' => "shinebox development meeting by issuse #185",
                'location' => "Dalian, China",
                'content' => "Dalian shinebox development meeting by issuse #185",
                'location_guide' => "Best by Plant come here",
                'compound_start_time_attributes' => compound_start_time_attributes,
                'compound_end_time_attributes' => compound_end_time_attributes
            )
        end

        it 'when all input changed' do
          patch 'update', :id => course.id, :course => attributes
          assigns[:course].title.should == "shinebox development meeting by issuse #185"
          assigns[:course].location.should ==  "Dalian, China"
          assigns[:course].content.should == "Dalian shinebox development meeting by issuse #185"
          assigns[:course].location_guide.should == "Best by Plant come here"
          assigns[:course].start_time.should == Time.zone.parse('2013-01-08 16:10:30')
          assigns[:course].end_time.should == Time.zone.parse('2013-01-08 18:10:30')
        end
      end
    end

    context 'when user has not yet signed in' do
      it "should be redirect" do
        patch 'update', :id => course.id, :course => valid_attributes
        response.should be_redirect
      end
    end
  end

  describe "follower" do
    let(:course) { create(:course, :user => create(:user)) }
    let(:user) { login_user }
    subject { course.group }
    context 'follow' do
      before { user }
      before { post :follow, id: course.id }
      its('followers.first') { should eql user }
    end
    context 'unfollow' do
      before { user.follow(subject) }
      before { post :unfollow, id: course.id }
      its(:followers) { should be_empty }
    end
  end
end
