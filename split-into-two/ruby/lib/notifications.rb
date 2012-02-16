require 'hookr'

module Notifications
  include HookR::Hooks
  alias_method :tell_listeners, :execute_hook

  module NotificationDefinitions
    include HookR::Hooks::ClassMethods
    alias_method :tells_listeners, :define_hook
  end

  # I know this is uncool these days.
  def self.included(by)
    by.extend(NotificationDefinitions)
  end
end
