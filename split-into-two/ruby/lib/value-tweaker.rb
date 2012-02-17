require 'notifications'

# ValueTweaker is some sort of composite view object
# that has controls for bumping the value up or down
# by some increment, plus a way to display that value.
class ValueTweaker
  include Notifications
  tells_listeners :adjust_setting, :delta

  def display(value)
    @displayed_value = value
  end

  def click_up
    tell_listeners :adjust_setting, 1
  end

  def click_down
    tell_listeners :adjust_setting, -1
  end

  test_support

  attr_reader :displayed_value
end