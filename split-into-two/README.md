Splitting one class with one instance into two classes, one
with one instance, and the other with two.

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
setting!") from the ValueTweaker. It's used to set the true
setting in the hardware and also used to update the
ValueTweaker's display. Values can't exceed some predefined
range. If the user tries to move outside the range, the
value is "pegged" at either the top or bottom of the range.

The **Hardware** is an (imaginary) facade over whatever kind
of complexity is required to tell true hardware to take on a
new setting. Hardware can also spontaneously change its own
value, which should be reflected to the ValueTweaker. 


Following a style of user experience design I learned from
Jeff Patton, I metaphorically consider a user's use of an
app to include navigation from **place** to place within it. A
"place" is, roughly, visible real estate on the screen. So,
for example, there's a place the user goes to change the
setting. 

At this moment in the app's life, the Controller handles
both navigation from place to place and the handling of the
setting changes. 

The latest task is to put a second ValueTweaker on the same
place in the UI as the first, and use it to control a second
hardware setting. This makes the Controller's dual
responsibility annoying, so that change will come after
splitting the Controller into one class that controls
movement from place to place (call it the **Navigator**) and one
that handles the vertical interaction (call it the
**SettingAuthority**). 
