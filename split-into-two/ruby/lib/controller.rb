class Controller
  def initialize(defaults)
    @value_tweaker = defaults[:value_tweaker]
    @hardware = defaults[:hardware]
    @authoritative_value = defaults[:starting_value]
    @allowed_range = defaults[:allowed_range]
  end

  def adjust_setting(delta)
    @authoritative_value = closest_to_desired_value(delta)
    @value_tweaker.display(@authoritative_value)
    @hardware.update(@authoritative_value)
  end

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