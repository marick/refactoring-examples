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
    @hardware_setting = TimeVaryingValue.starting_with(DEFAULT)

    # User initiated desired bumps up or down
    @deltas = DiscreteValueStream.manual

    # How a bump should actually change the setting.
    @user_changes = DiscreteValueStream.follows(@deltas) do |delta|
      delta + @setting.value
    end
    @user_changes.on_addition do |value|
      @setting = value
    end

    #@value_displayed = TimeVaryingValue.follows(@setting)
  end

  should "propagate user changes" do
    #@deltas.add_value(5)
    #
    #assert_equal(55, @hardware_setting.current)
    #assert_equal(55, @value_displayed.current)
  end

  should "propagate and obey hardware changes" do
    #@hardware_setting.change_to(80)
    #
    #assert_equal(80, @hardware_setting.current)
    #assert_equal(80, @value_displayed.current)
    #
    #@deltas.add_value(5)
    #
    #assert_equal(85, @hardware_setting.current)
    #assert_equal(85, @value_displayed.current)
  end
end


