=== father ===
= start
Hello son.
{start < 2: -> long_start}
-> options

= long_start
The soil here is wonderful.
Black as tar, smells great. Here, taste it!
-> options

= options
* {not taste}[Bleh!] -> bleh
* {not bleh}[Taste it] -> taste
* {plans and !play_around}[Visit neighbor] -> visit_neighbor
* {plans and !visit_neighbor}[Play around] -> play_around
* _p_ -> start

= bleh
Haha! I was joking!
Remember, son. Never eat manure, even for a bet.
Your stomach will thank you for it. Beleve me, I know...
-> plans

= taste
(It tastes like dirt)
Haha! How is it? Not moldy I hope?
-> plans

= plans
Anyway... What are your plans for today?
-> options

= visit_neighbor
Oh, yes. He has some problems with dirt rats.
It would be great if you could help him.
I'm sure he would pay you.
And we don't want those pests on our field. Best to get rid of them as quickly as possible.
Well then, off you go!
-> options

= play_around
It is exciting, isn't it? 
New start, new place. And such wonderful one!
But don't waste all day. I hear our neighbor could use your help.
-> options