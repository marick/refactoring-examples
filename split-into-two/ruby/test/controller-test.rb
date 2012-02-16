require "./helper"

class ControllerTest < Test::Unit::TestCase

  DEFAULT_VALUE = 10
  def setup
    @value_tweaker = Object.new
    @hardware = Object.new
    @sut = Controller.new(value_tweaker: @value_tweaker,
                          hardware: @hardware,
                          starting_value: DEFAULT_VALUE)
  end

  should "change controlled object's displayed values when adjusting" do
    during {
      @sut.adjust_setting(3)
    }.behold! {
      mock(@value_tweaker).display(DEFAULT_VALUE+3)
      mock(@hardware).update(DEFAULT_VALUE+3)
    }
  end

end
