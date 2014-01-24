# Static settings loaded from the YAML file
class Settings < Settingslogic
  source Rails.root.join('config/settings.yml')
  namespace Rails.env

  # 'shinebox <support@shinebox.cn>' => 'support@shinebox.cn'
  def self.raw_email(email)
    email.gsub(/(.*<|>)/, '')
  end
end
