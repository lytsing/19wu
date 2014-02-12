require 'spec_helper'

describe FallbackUrl do
  let(:course) { create :course, slug: 'ruby-conf-china' }
  context 'is not exists' do
    before { course }
    it 'should be create' do
      expect do
        course.update_attributes! slug: 'rubyconfchina'
      end.to change{FallbackUrl.count}.by(1)
      fallback_url = FallbackUrl.find_by_origin('ruby-conf-china')
      fallback_url.change_to.should eql 'rubyconfchina'
    end
  end
  context 'exists' do
    before { create :fallback_url, origin: 'ruby-conf-china', change_to: 'rubyconf' }
    it 'should be update' do
      expect do
        course.update_attributes! slug: 'rubyconfchina'
      end.not_to change{FallbackUrl.count}
      fallback_url = FallbackUrl.find_by_origin('ruby-conf-china')
      fallback_url.change_to.should eql 'rubyconfchina'
    end
  end
end
