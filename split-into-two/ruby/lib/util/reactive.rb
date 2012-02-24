module Reactive


  class ReactiveNode
    private_class_method :new
    def self.follows(*earlier_nodes, &updater)
      new(*earlier_nodes, &updater)
    end

    attr_reader :value

    def initialize(*earlier_nodes, &recalculator)
      @value = :no_value_at_all
      @recalculator = recalculator
      @later_nodes = []
      @earlier_nodes = earlier_nodes
      tell_earlier_nodes_about_me(earlier_nodes)
    end

    def tell_earlier_nodes_about_me(earlier_nodes)
      earlier_nodes.each do |e|
        e.this_node_is_later_than_you(self) if e.is_a?(ReactiveNode)
      end
    end

    def this_node_is_later_than_you(this_node)
      @later_nodes << this_node
    end

    def recalculate
      @value = @recalculator.call(*just_values(@earlier_nodes))
      propagate
    end

    def value=(new_value)
      @value = new_value
      propagate
    end

    def propagate
      @later_nodes.each do |node|
        node.recalculate
      end
    end

    def method_missing(message, *args)
      recalculator = lambda do |*just_values|
        receiver = just_values.shift
        receiver.send(message, *just_values)
      end
      self.class.follows(self, *args, &recalculator)
    end

    def just_values(args)
      args.collect do |arg|
        if arg.is_a?(ReactiveNode)
          arg.value
        else
          arg
        end
      end
    end

    test_support

    def self.blank
      follows() {}
    end

  end

  class TimeVaryingValue < ReactiveNode
    alias_method :current, :value
    alias_method :change_to, :value=
    def initialize(*earlier_nodes, &recalculator)
      super
      recalculate
    end

    # Flapjax startsWith
    def self.tracks_stream(event_stream, initial_value)
      retval = new(event_stream) do |last_event|
        last_event
      end
      retval.value = initial_value
      retval
    end

    def self.starting_with(value)
      follows { value }
    end
  end

  class DiscreteValueStream < ReactiveNode
    def self.manual
      follows {
        raise "Incorrect use of recalculation in a manual event stream"
      }
    end

    def most_recent_value; @value; end

    def add_value(new_value)
      self.value = new_value
    end
  end
end
