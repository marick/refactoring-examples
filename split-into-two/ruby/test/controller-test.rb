require "./helper"

class ControllerTest < Test::Unit::TestCase

  #def mocked(n = 1)
  #  (0...n).collect do
  #    core_object = Object.new
  #    mock_wrapper = mock(core_object)
  #    core_object.define_singleton_method(:receives) { mock_wrapper }
  #    core_object
  #  end
  #end

  DEFAULT_VALUE = 10
  def setup
    collaborators :value_tweaker, :hardware

    #@value_tweaker = Object.new
    #@hardware = Object.new

    #@vt = mock(@value_tweaker)
    #puts @vt.__blank_slated_class
    #puts @vt.__double_definition_create__.subject
    #puts @value_tweaker

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
