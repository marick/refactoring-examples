require "./helper"

class ControllerTest < Test::Unit::TestCase
  DEFAULT_VALUE = 10
  MIN = 0
  MAX = 20

  def setup
    collaborators :value_tweaker, :hardware
    @sut = Controller.new(value_tweaker: @value_tweaker,
                          hardware: @hardware,
                          starting_value: DEFAULT_VALUE,
                          allowed_range: MIN..MAX)
  end

  should "change controlled object's displayed values when adjusting" do
    during {
      @sut.adjust_setting(3)
    }.behold! {
      @value_tweaker.receives.display(DEFAULT_VALUE+3)
      @hardware.receives.update(DEFAULT_VALUE+3)
    }
    assert_equal(DEFAULT_VALUE+3, @sut.setting)
  end

  should "peg values at upper bound of the allowed range" do
    during {
      up_to_top = MAX-DEFAULT_VALUE
      @sut.adjust_setting(up_to_top+1)
    }.behold! {
      @value_tweaker.receives.display(MAX)
      @hardware.receives.update(MAX)
    }
    assert_equal(MAX, @sut.setting)
  end

  should "peg values at lower bound of the allowed range" do
    during {
      down_to_bottom = MIN - DEFAULT_VALUE
      @sut.adjust_setting(down_to_bottom - 1)
    }.behold! {
      @value_tweaker.receives.display(MIN)
      @hardware.receives.update(MIN)
    }
    assert_equal(MIN, @sut.setting)
  end

end
