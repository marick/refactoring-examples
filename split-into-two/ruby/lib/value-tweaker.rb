require 'notifications'

class ValueTweaker
  include Notifications

  signals :increase_setting
  signals :foo

  def click_up
    signal :increase_setting
  end
end