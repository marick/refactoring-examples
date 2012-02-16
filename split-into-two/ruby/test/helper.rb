require 'rubygems'
require 'bundler'
begin
  Bundler.setup(:default, :development)
rescue Bundler::BundlerError => e
  $stderr.puts e.message
  $stderr.puts "Run `bundle install` to install missing gems"
  exit e.status_code
end
require 'test/unit'
require 'shoulda'
require 'assert2'
require 'rr'
require 'hookr'

$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '..', 'lib'))
$LOAD_PATH.unshift(File.dirname(__FILE__))

require 'requires'

class Test::Unit::TestCase
  include RR::Adapters::TestUnit
end

# These methods are used to change the flow of control so that the
# test can state what is to happen before stating what the mock should
# receive.
class Test::Unit::TestCase
  def during(&block)
    $what_runs_after_mock_setup = block  # Feh
    self
  end

  def behold!
    yield
    @result = $what_runs_after_mock_setup.call
  end

  def listeners_to(object)
    klass = object.class.const_get("Listener")
    any_old_listener = klass.new
    object.add_listener(any_old_listener)

    # mock(any_old_listener).increase_setting
    mockable = mock(any_old_listener)

    def mockable.run_methods(&block)
      instance_eval(&block)
      $what_runs_after_mock_setup.call
    end
    mockable
  end



end