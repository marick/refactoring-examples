class Controller
  def initialize(defaults)
    @value_tweaker = defaults[:value_tweaker]
    @hardware = defaults[:hardware]
    @authoritative_value = defaults[:starting_value]
  end

  def adjust_setting(delta)
    @authoritative_value += delta
    @value_tweaker.display(@authoritative_value)
    @hardware.update(@authoritative_value)
  end

end