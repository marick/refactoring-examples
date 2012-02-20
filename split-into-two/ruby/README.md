Dependencies
-----------

* If you use RVM and Bundler, things will be automagically set
up for you (once you do a `bundle install`). Note that RVM
uses gems from the catch-all version of 1.9.2, not a
project-specific set.

* If not:

   ** The code depends on Ruby 1.9.2. (Other versions of 1.9 might work, 1.8.X surely will not.)

   ** You can find the list of gems that need to be available in `Gemfile`.

Running the code
--------------

From the command line, you can run the tests with a plain
`rake`.

If you're using something like RubyMine to run the tests,
notice that the pattern for test filenames is
idiosyncratic. Use `**/*test*.rb`.

Notes on the code
--------------

When reading the code and tests, I recommend starting with
test/end-to-end-ish/up-and-down-the-vertical-slice-test.rb. 

**broadcast**

The code uses a vague sort of "broadcast a message send"
metaphor for some of its communication. For example, the
`ValueTweaker` broadcasts messages that happen to be caught by
the `Controller`. This wiring can be seen in configuration.rb,
which looks roughly like this:

    ui = ValueTweaker.new
    controller = Controller.new
    ui.add_listener(controller)

Just as a message is sent to a single object using `send`, a
message is broadcast by sending it to a `listeners`
object. So, for example, one `ValueTweaker` method contains
this:

    listeners.send(:adjust_setting, 1)

That causes the `adjust_setting` method to be invoked on all
of the registered listeners (the controller, in this case).

**capturing ordinary message sends in tests**

I write mock-style tests using this format:

    during {
      ... some code execution ...
    }.behold! {
      object.is_sent.message(arg1, arg2)
    }

In a more familiar mocking notation, this would be written:

    object.expects(:message).with(arg1, arg2)
   ... some code execution ...

I like my format because it reads funny to see the effect
specified before the cause. That's required in languages
without blocks, but Ruby's not one of those languages.

**listening in tests**

When objects broadcast messages, you want to make assertions
about what *any* listener receives. That's written like
this:

    during {
      ...some code execution... 
    }.listeners_to(@sut).are_sent {
      adjust_setting(1)
    }

As with ordinary mocks, `adjust_setting(1)` means "[all
listeners] should receive the `:adjust_setting` message
carrying the single argument `1`.

