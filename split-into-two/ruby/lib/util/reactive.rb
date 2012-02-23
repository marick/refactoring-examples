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
      tell_earlier_nodes_about_me(earlier_nodes)
    end

    def tell_earlier_nodes_about_me(earlier_nodes)
      earlier_nodes.each do |e|
        e.this_node_is_later_than_you(self) if e.is_a?(ReactiveNode)
      end
    end

    def this_node_is_later_than_you(behavior)
      @later_nodes << behavior
    end

    def update
      @value = @updater.call
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
      this = self
      updater = lambda do
        values =
            args.collect do |arg|
              if arg.is_a?(Behavior)
                arg.value
              else
                arg
              end
            end
        this.value.send(message, *values)
      end
      self.class.follows(self, *args, &updater)
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
