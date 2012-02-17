require "./testutil"

class UpAndDownTheVerticalSliceTest < Test::Unit::TestCase

  def setup
    @configuration = Configuration.create
    @ui = @configuration.ui
    @hardware = @configuration.hardware

    @starting_value = @configuration.starting_value
  end

  should "handle typical changing by user" do
    @ui.click_up
    assert_equal(@starting_value+1, @ui.displayed_value)
    assert_equal(@starting_value+1, @hardware.setting)

    @ui.click_down
    assert_equal(@starting_value, @ui.displayed_value)
    assert_equal(@starting_value, @hardware.setting)
  end

  should "handle hardware changing its own state" do
    @hardware.update(@starting_value-3)
    assert_equal(@starting_value-3, @hardware.setting)
    assert_equal(@starting_value-3, @ui.displayed_value)

    @ui.click_down
    assert_equal(@starting_value-4, @hardware.setting)
    assert_equal(@starting_value-4, @ui.displayed_value)
  end

end