require_relative '../testutil'

class Fixnum
  # A useful N-argument method for testing
  def max3(other1, other2)
    [self, other1, other2].max
  end
end


class ReactiveTests < Test::Unit::TestCase
  include Reactive

  context "value holders" do
    should "hold values" do
      v = ValueHolder.containing(3)
      assert_equal(3, v.value)
      v.value = 4
      assert_equal(4, v.value)
    end
  end

  context "behaviors" do
    should "be able to depend on value-holders" do
      origin = ValueHolder.containing(3)
      destination = Behavior.follows(origin) { origin.value + 1}
      assert_equal(4, destination.value)
      origin.value = 4
      assert_equal(5, destination.value)
    end

    should "be able to depend on behaviors" do
      origin = ValueHolder.containing(3)
      middle = Behavior.follows(origin) { origin.value + 1}
      destination = Behavior.follows(middle, origin) do
        middle.value + origin.value + 100
      end
      assert_equal(107, destination.value)
      origin.value = 0
      assert_equal(101, destination.value)
    end

    should "create implicit Behaviors" do
      origin = ValueHolder.containing(8)
      destination = origin + 1
      assert_equal(9, destination.value)

      origin.value = 33
      assert_equal(34, destination.value)
    end

    should "work with multi-argument methods" do
      # See below for definition of max3
      assert_equal(3, 1.max3(2, 3))

      origin = ValueHolder.containing(2)
      other = origin * -1
      final = origin.max3(8, other)
      assert_equal(8, final.value)

      origin.value = 100
      assert_equal(100, final.value)

      origin.value = -222
      assert_equal(222, final.value)
    end

  end

  context "events" do
    should "be able to send an event" do
      s = EventStream.manual
      s.send_event(33)
      assert_equal(33, s.most_recent_value)
    end

    should "be able to create new event streams from old" do
      origin = EventStream.manual
      transformed = EventStream.follows(origin) {
        origin.value + 1
      }
      origin.send_event(33)
      assert_equal(34, transformed.most_recent_value)
    end
  end

  ### Not the public API

  context "Reactive Nodes" do
    should "take a block that calculates their value" do
      b = ReactiveNode.new { 5 }
      b.update
      assert_equal(5, b.value)
    end

  end

end


