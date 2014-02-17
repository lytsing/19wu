class Profile < ActiveRecord::Base
  extend HasHtmlPipeline

  belongs_to :user
  validates :name, length: { maximum: 20 }
  
  mount_uploader :avatar, AvatarUploader

  has_html_pipeline :bio, :profile_markdown
end
