require_relative '../testutil'

class Fixnum
  # A useful N-argument method for testing
  def max3(other1, other2)
    [self, other1, other2].max
  end
end


class ReactiveUseCaseTests < Test::Unit::TestCase
  include Reactive

  MIN=0
  MAX=100
  DEFAULT=50

  def setup
    # What our program knows about the current setting.
    @hardware_setting = TimeVaryingValue.containing(DEFAULT)

    # User initiated desired bumps up or down
    @deltas = EventStream.manual

    # How a bump should actually change the setting.
    @user_changes = EventStream.follows(@deltas) do |delta|
      delta + @setting.value
    end
    @user_changes.on_event do |value|
      @setting = value
    end

    @value_displayed = TimeVaryingValue.follows(@setting)
  end

  should_eventually "propagate user changes" do
    @deltas.send_event(5)

    assert_equal(55, @hardware_setting.value)
    assert_equal(55, @value_displayed.value)
  end

  should_eventually "propagate and obey hardware changes" do
    @hardware_setting.value=(80)

    assert_equal(80, @hardware_setting.value)
    assert_equal(80, @value_displayed.value)

    @deltas.send_event(5)

    assert_equal(85, @hardware_setting.value)
    assert_equal(85, @value_displayed.value)
  end
end


