require 'notifications'

class Hardware
  include Notifications
  broadcasts :accept_hardware_setting, :value

  attr_reader :setting

  def update(absolute_value)
    # Do magic hardware-ish things
    @setting = absolute_value
    listeners.send(:accept_hardware_setting, absolute_value)
  end
end