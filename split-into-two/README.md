Splitting one class with one instance into two classes, one
with one instance, and the other with two.

The app
------

Consider this to be an app with a desktop-style user
interface. It is to control some **settings** (integer values)
of some hardware. When you enter the picture, it controls
only one single setting via a "vertical slice" that involves
three classes:

The **ValueTweaker** is some sort of composite view object
that lets the user both view and control a single
setting. Presumably, it lashes together other values (like
buttons and a text field, a slider and gauges, or whatever -
we're not concerned with that.

The **Controller** fields user intentions ("raise the
setting!") from the `ValueTweaker`. It's used to set the true
setting in the hardware and also used to update the
`ValueTweaker`'s display. Values can't exceed some predefined
range. If the user tries to move outside the range, the
value is "pegged" at either the top or bottom of the range.

The **Hardware** is an (imaginary) facade over whatever kind
of complexity is required to tell true hardware to take on a
new setting. Hardware can also spontaneously change its own
value, which should be reflected to the `ValueTweaker`. 


Following a style of user experience design I learned from
Jeff Patton, I metaphorically consider a user's use of an
app to include navigation from **place** to place within it. A
"place" is, roughly, visible real estate on the screen. So,
for example, there's a place the user goes to change the
setting. 

The story
-------

At this moment in the app's life, the `Controller` handles
both navigation from place to place and the handling of the
setting changes. 

The latest task is to put a second `ValueTweaker` on the same
place in the UI as the first, and use it to control a second
hardware setting. This makes the `Controller`'s dual
responsibility annoying, so that change will come after
splitting the `Controller` into one class that controls
movement from place to place (call it the **Navigator**) and one
that handles the vertical interaction (call it the
**SettingAuthority**). 

Reading the code and tests
--------------

I recommend starting with
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

** capturing ordinary message sends in tests **

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

** listening in tests **

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


Exercise 1: Superclass refactoring
--------------------------

**The short version**

Make the `SettingAuthority` an empty superclass of
`Controller`. Pull setting-relevant methods up into that
superclass, keeping the tests passing at all time. Sever the
inheritance connection, and rename `Controller` to be
Navigator.

**Step-by-step**

1. Create an empty `SettingAuthority` class with an empty
    `SettingAuthority` test suite. Have `Controller` be its
    subclass. All the `Controller` tests still pass.

1.  One by one, move the `Controller` tests that are about
    controlling settings up into the `SettingAuthority` test
    suite. Move the code to make them pass.

1.  When that’s done, we still have a `Controller` object that
    does everything it used to do. We also have an
    end-to-end test that checks that a tweak of the UI
    propagates down into the system to make a change and
    also propagates back up to the UI to show that the
    change happened.

1. Change the end-to-end test so that it no longer refers to `Controller` but only to `SettingAuthority`.

1. Change the object that wires up this whole subsystem so
   that it (1) creates both a `Controller` and
   `SettingAuthority` object, (2) connects the
   `SettingAuthority` to the `ValueTweaker` and to the
   appropriate object down toward the hardware, and (3)
   continues to connect the `Controller` to the objects that
   don’t have anything to do with changing the tweakable
   value. Confirm (manually) that both tweaking and the
   remaining `Controller` end-to-end behaviors work.

1. Since it no longer uses its superclass’s behavior, change
   `Controller` so that it’s no longer a subclass of
   `SettingAuthority`.

1. Change the wire-up-the-whole-subsystem object so that it
   also makes story B’s vertical slice (new `ValueTweaker`,
   new `SettingAuthority`, new connection to the
   hardware). Confirm manually.

1. Change `Controller`'s name.
