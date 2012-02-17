require 'hookr'

module Notifications
  include HookR::Hooks

  def listeners
    # Whee! Javascript!
    this = self
    proxy = Object.new
    proxy.define_singleton_method(:send, -> *args {
      this.execute_hook(*args)
    })
    proxy
  end

  module NotificationDefinitions
    include HookR::Hooks::ClassMethods
    alias_method :broadcasts, :define_hook
  end

  # I know this is uncool these days.
  def self.included(by)
    by.extend(NotificationDefinitions)
  end
end
