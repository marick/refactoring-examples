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
      destination = Behavior.follows(origin) { |o| o + 1}
      assert_equal(4, destination.value)
      origin.value = 4
      assert_equal(5, destination.value)
    end

    should "be able to depend on behaviors" do
      origin = ValueHolder.containing(3)
      middle = Behavior.follows(origin) { |o| o + 1}
      destination = Behavior.follows(middle, origin) do |m,o|
        m + o + 100
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
      transformed = EventStream.follows(origin) { |o|
        o + 1
      }
      origin.send_event(33)
      assert_equal(34, transformed.most_recent_value)
    end
  end

  ### Not the public API

  context "Reactive Nodes" do
    should "take a block that calculates their value" do
      n = ReactiveNode.follows { 5 }
      n.update
      assert_equal(5, n.value)
    end

    should "be able to depend on other nodes" do
      before = ValueHolder.containing(5)
      after = ReactiveNode.follows(before) do |b|
        1 + b
      end
      after.update
      assert_equal(6, after.value)

      before.value = 88
      assert_equal(89, after.value)
    end

    should "be able to generate nodes implicitly" do
      origin = ValueHolder.containing(8)
      destination = origin + 1
      assert_equal(9, destination.value)

      origin.value = 33
      assert_equal(34, destination.value)

      final_destination = destination + origin
      assert_equal(67, final_destination.value)

      origin.value = 1
      assert_equal(2, destination.value)
      assert_equal(3, final_destination.value)

    end


  end

end


