# encoding: utf-8
require 'spec_helper'

describe HomeHelper do

  describe 'active?' do
    context 'menu is courses' do
      let(:menu) { :courses }
      subject { helper.active?(current, menu) }
      context 'current is courses' do
        let(:current) { :courses }
        it { should == :active }
      end
      context 'current is not courses' do
        let(:current) { :activities }
        it { should be_blank }
      end
    end
  end
end
