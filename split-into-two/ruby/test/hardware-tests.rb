require_relative 'testutil'
require 'notifications'

class HardwareTests < Test::Unit::TestCase

  def setup
    @sut = Hardware.new
  end

  should "tell listeners when told to update" do
    during {
      @sut.update(33)
    }.listeners_to(@sut).are_sent {
      accept_hardware_setting(33)
    }
    assert_equal(33, @sut.setting)
  end
end