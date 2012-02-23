module Reactive


  class ReactiveNode
    private_class_method :new
    def self.follows(*earlier_nodes, &updater)
      new(*earlier_nodes, &updater)
    end

    attr_reader :value

    def initialize(*earlier_nodes, &updater)
      @value = :no_value_at_all
      @updater = updater
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

    def update
      @value = @updater.call(*just_values(@earlier_nodes))
    end

    def value=(new_value)
      @value = new_value
      propagate()
    end

    def propagate
      @later_nodes.each do |node|
        node.update
      end
    end

    def method_missing(message, *args)
      updater = lambda do |*just_values|
        receiver = just_values.shift
        receiver.send(message, *just_values)
      end
      self.class.follows(self, *args, &updater)
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
  end

  class Behavior < ReactiveNode
    def initialize(*earlier_nodes, &updater)
      super
      update
    end

  end

  class ValueHolder < Behavior
    def self.containing(value)
      follows { value }
    end
  end

  class EventStream < ReactiveNode
    def self.manual
      follows {
        raise "Incorrect use of update function in a manual event stream"
      }
    end

    def most_recent_value; @value; end

    def send_event(new_value)
      self.value = new_value
    end
  end
end
