require_relative 'testutil'
require 'notifications'

class ValueTweakerTests < Test::Unit::TestCase

  def setup
    @sut = ValueTweaker.new
  end

  should "tell listeners when user asks to increase the setting" do
    during {
      @sut.click_up
    }.listeners_to(@sut).are_sent {
      adjust_setting(1)
    }
  end

  should "tell listeners when user asks to decrease the setting" do
    during {
      @sut.click_down
    }.listeners_to(@sut).are_sent {
      adjust_setting(-1)
    }
  end
end