require "./helper"

class ControllerTest < Test::Unit::TestCase
  DEFAULT_VALUE = 10
  def setup
    collaborators :value_tweaker, :hardware
    @sut = Controller.new(value_tweaker: @value_tweaker,
                          hardware: @hardware,
                          starting_value: DEFAULT_VALUE)
  end

  should "change controlled object's displayed values when adjusting" do
    during {
      @sut.adjust_setting(3)
    }.behold! {
      @value_tweaker.receives.display(DEFAULT_VALUE+3)
      @hardware.receives.update(DEFAULT_VALUE+3)
    }
  end
end
