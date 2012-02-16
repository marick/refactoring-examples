require 'hookr'

module Notifications
  include HookR::Hooks
  alias_method :signal, :execute_hook

  module NotificationDefinitions
    include HookR::Hooks::ClassMethods
    alias_method :signals, :define_hook
  end

  # I know this is uncool these days.
  def self.included(by)
    puts "FOO"
    by.extend(NotificationDefinitions)
  end
end
