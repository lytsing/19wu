class EventSummary < ActiveRecord::Base
  extend HasHtmlPipeline

  belongs_to :course

  has_html_pipeline :content, :markdown

  validates_presence_of :content
  validates :content, :length => { :minimum => 10 }
end
