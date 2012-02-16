require './helper'
require 'notifications'

class L
  def increase_setting
    puts "Increase setting called."
  end
end


class ValueTweakerTests < Test::Unit::TestCase

  #def listeners_receive
  #  klass = @sut.class.const_get("Listener")
  #  @any_old_listener = klass.new
  #  @sut.add_listener(@any_old_listener)
  #  mock(@any_old_listener).increase_setting
  #end

  def listeners_to(object)
    klass = object.class.const_get("Listener")
    any_old_listener = klass.new
    object.add_listener(any_old_listener)

    # mock(any_old_listener).increase_setting
    mockable = mock(any_old_listener)

    def mockable.receive(&block)
      instance_eval(&block)
      $what_runs_after_mock_setup.call
    end
    mockable
  end

  def setup
    @sut = ValueTweaker.new
  end

  should "notify when an up-click is received" do
    l = L.new
    @sut.add_listener(l)
    during {
      @sut.click_up
    }.listeners_to(@sut).receive {
      increase_setting
    }
  end

end