class Controller
  def initialize(defaults)
    @value_tweaker = defaults[:value_tweaker]
    @hardware = defaults[:hardware]
    @setting_changing_page = defaults[:setting_changing_page]
    @authoritative_value = defaults[:starting_value]
    @allowed_range = defaults[:allowed_range]
  end

  def user_wants_to_change_settings
    @setting_changing_page.reveal
  end

  def adjust_setting(delta)
    @authoritative_value = closest_to_desired_value(delta)
    @hardware.update(@authoritative_value)
  end

  def accept_hardware_setting(absolute_value)
    @authoritative_value = absolute_value
    @value_tweaker.display(@authoritative_value)
  end

  test_support

  def setting; @authoritative_value; end

  private

  def closest_to_desired_value(delta)
    desired = @authoritative_value + delta
    if (desired > @allowed_range.last)
      desired = @allowed_range.last
    elsif (desired < @allowed_range.first)
      desired = @allowed_range.first
    end
    desired
  end

end