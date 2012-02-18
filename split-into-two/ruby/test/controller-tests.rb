require_relative "./testutil"

class ControllerTest < Test::Unit::TestCase
  DEFAULT_VALUE = 10
  MIN = 0
  MAX = 20

  def setup
    collaborators :value_tweaker, :hardware, :setting_changing_page
    @sut = Controller.new(value_tweaker: @value_tweaker,
                          hardware: @hardware,
                          setting_changing_page: @setting_changing_page,
                          starting_value: DEFAULT_VALUE,
                          allowed_range: MIN..MAX)
  end

  should "change hardware wn user wants to adjust setting" do
    during {
      @sut.adjust_setting(3)
    }.behold! {
      @hardware.is_sent.update(DEFAULT_VALUE+3)
    }
    assert_equal(DEFAULT_VALUE+3, @sut.setting)
  end

  should "peg values at upper bound of the allowed range" do
    during {
      up_to_top = MAX-DEFAULT_VALUE
      @sut.adjust_setting(up_to_top+1)
    }.behold! {
      @hardware.is_sent.update(MAX)
      @value_tweaker.is_sent.update(anything).never
    }
    assert_equal(MAX, @sut.setting)
  end

  should "peg values at lower bound of the allowed range" do
    during {
      down_to_bottom = MIN - DEFAULT_VALUE
      @sut.adjust_setting(down_to_bottom - 1)
    }.behold! {
      @hardware.is_sent.update(MIN)
      @value_tweaker.is_sent.update(anything).never
    }
    assert_equal(MIN, @sut.setting)
  end

  should "reveal setting-changing page when user desires" do
    during {
      @sut.user_wants_to_change_settings
    }.behold! {
      @setting_changing_page.is_sent.reveal
    }
  end

  should "accept changes from the hardware and notify the value tweaker" do
    # Note: values outside the valid ranger are "impossible"
    during {
      @sut.accept_hardware_setting(DEFAULT_VALUE+3)
    }.behold! {
      @value_tweaker.is_sent.display(DEFAULT_VALUE+3)
      @hardware.is_sent.update(anything).never
    }
    assert_equal(DEFAULT_VALUE+3, @sut.setting)
  end
end
