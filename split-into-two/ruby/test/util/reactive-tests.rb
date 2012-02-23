require_relative '../testutil'

class ReactiveTests < Test::Unit::TestCase
  include Reactive

  context "value holders" do

    should "hold values" do
      v = ValueHolder.new(3)
      assert_equal(3, v.value)
      v.value = 4
      assert_equal(4, v.value)
    end
  end

  context "behaviors" do

    should "take a block that calculates their value" do
      b = Behavior.new { 5 }
      assert_equal(5, b.value)
    end

    should "be able to depend on value-holders" do
      origin = ValueHolder.new(3)
      destination = Behavior.new(origin) { origin.value + 1}
      assert_equal(4, destination.value)
      origin.value = 4
      assert_equal(5, destination.value)
    end

    should "be able to depend on behaviors" do
      origin = ValueHolder.new(3)
      middle = Behavior.new(origin) { origin.value + 1}
      destination = Behavior.new(middle, origin) do
        middle.value + origin.value + 100
      end
      assert_equal(107, destination.value)
      origin.value = 0
      assert_equal(101, destination.value)
    end
  end
end
