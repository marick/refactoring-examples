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
**SettingController**). 

Reading the code and tests
--------------

Each of the subdirectories has a README.md file that
describes quirks of the implementation.


Exercise 1 (of 1+N+1): Superclass refactoring
--------------------------

**The short version**

Make the `SettingController` an empty superclass of
`Controller`. Pull setting-relevant methods up into that
superclass, keeping the tests passing at all time. Sever the
inheritance connection, and rename `Controller` to be
Navigator.

**Step-by-step**

1.  Create an empty `SettingController` class with an empty
    `SettingController` test suite. Have `Controller` be its
    subclass. (Don't forget to put the `require_relative` in
    either `requires.rb` or `controller.rb`.)
    All the `Controller` tests still pass.

1.  Identify the parts of `initialize` that are about
    controlling settings. Move them up into the superclass. 
    All the tests still pass.

1.  One by one, move the `Controller` tests that are about
    controlling settings up into the `SettingController` test
    suite. Move the code to make them pass.

1.  When that's done, we still have a `Controller` object that
    does everything it used to do. We have a `Configuration`
    object that wires the system together. The wiring is
    tested by an UpAndDownTheVerticalSlice "end-to-end-ish"
    test. 

    Change the `Configuration` so
    that it (1) creates both a `Controller` and a
    `SettingController` object, (2) connects the
    `SettingController` to the `ValueTweaker` and to the
    appropriate object down toward the hardware, and (3)
    continues to connect the `Controller` to the objects that
    don't have anything to do with changing the tweakable
    value. The end-to-end test should still work.

1.  Since it no longer uses its superclass's behavior, change
    `Controller` so that it's no longer a subclass of
    `SettingController`.

1.  Change `Controller`'s name to `Navigator`.

Exercises 2 to 1+N: Other Refactorings
--------------------------------------

Invent at least one other path that takes you from the same beginning class structure to the same end class structure.

Exercise 1+N+1: The Next Refactoring
------------------------------------

Are you ready to add the next `ValueTweaker` to the UI? Or is there another appealing refactoring lurking in the wings?   
   
   
   
(I'd be inclined to "reify" the idea of a vertical slice into its own class.)

