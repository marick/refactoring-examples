require 'notifications'

class Hardware
  include Notifications
  tells_listeners :accept_hardware_setting, :value

  attr_reader :setting

  def update(absolute_value)
    # Do magic hardware-ish things
    @setting = absolute_value
    tell_listeners :accept_hardware_setting, absolute_value
  end
end