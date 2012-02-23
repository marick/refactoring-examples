module Reactive
  class Behavior

    attr_writer :updater
    attr_reader :value

    def initialize(*upstreams, &updater)
      @updater = updater
      @downstreams = []
      notify_upstream_behaviors(upstreams)
      update
    end

    def notify_upstream_behaviors(upstreams)
      upstreams.each do | e |
        case e
          when Behavior
            e.add_downstream(self)
        end
      end

    end

    def add_downstream(behavior)
      @downstreams << behavior
    end

    def update
      @value = @updater.call
    end
  end

  class ValueHolder < Behavior
    def initialize(value)
      updater = -> {value}
      super(&updater)
    end

    def value=(new_value)
      @value = new_value
      @downstreams.each do |dependent|
        dependent.update
      end
    end
  end
end