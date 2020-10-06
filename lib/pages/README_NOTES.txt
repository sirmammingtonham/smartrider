-==-=--=-=--==-=-=-=-=-=-=-=-=
LOOK HERE LOOK HERE LOOK HERE
-=-=-=-=-=-=-=-=-=-=--=--=---=

For people in the UI improvement team, we are trying to implement this
panel system into our current schedule slider.
To better understand this look at home.dart under pages and change line 93 
from "panel: test())," to "panel: main()),". And rerun your andriod emulator
to see what is the current schuedle UI.
Looking at the current scheduele UI we have a top section that has each individual
shuttle and bus. Clicking on this allows us to see each shuttles stop. Right now 
all we have is the bus's stops looping over and over again in a list.
We are trying to change this to a panel system. Where each stop under a given bus has 
a panel listing out the times when the bus should be at said stop.

To implement we first should work to understand flutter and this panel system. Then
we should work to implement this into the schedule.dart file.

Remember that this panel systme should be sub system under each shuttle at the top.

NOTE: Remember to switch back to the testing file in the home.dart file.