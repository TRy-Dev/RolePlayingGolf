=== mother ===
= start
Hello child.
{start < 2: -> long_start}
-> options

= long_start
I'm sorry it's such a mess.
We were promised a nice house to live in.
But we will manage, as we always do.
At least outside looks nice and there is something for you to do there.
-> options

= options
* [House] -> house
* {house} [He] -> he
* [Outside] -> outside
* {outside} [West] -> west
* _p_ -> start

= house
Oh yes! A big one with a few rooms and a fancy roof.
But I suppose he had different priorities.
It does not matter now. 
Your father and I can live off of land and build something small for ourselves.
-> options

= he
We don't know who he really is. 
All we know is we were moved here and promised a new start.
Anyway, it's not that bad.
Weather seems nice outside and your father says the soil is healthy.
We will manage.
-> options

= outside
There's plenty of space for you to hop around in. See for yourself!
And I've heard that our neighbor to the west was having some problems on his farm. Maybe you could help him?
-> options

= west
West is to the left.
\<--- this way
Has father not taught you this?...
-> options