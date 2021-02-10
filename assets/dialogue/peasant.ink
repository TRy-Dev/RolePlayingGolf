VAR killed_rats = false

=== peasant ===
{killed_rats: -> thank_you}
{not killed_rats: -> start}

= start
 Oi, boy!
{start < 2: -> long_start}
-> options

= long_start
 Would you help me out?
 You know dirt rats?
-> options

= options
* [Hello sir!] -> sir
* [Dirt Rats?] -> rats
* {rats} [How to get rid of them?] -> rid
* {rid} [How old are you?] -> age
* _p_ -> start

= sir
I ain't no sir, just a simple farmer.
And you must be the boy who just came here.
So will you help me or not?
I'll reward you, of course.
-> options

= rats
Those annoying creatures living under ground...
They keep digging holes on my field.
Get rid of them and you shall be rewarded!
-> options

= rid
Just wait for them to pop out of one of their holes...
And smash them!
They can be fast though, not a task for man my age.
(The game is TRUN BASED so actually WAITING for them to appear might not be the best strategy)
-> options

= age
I'm not sure... 
I remember celebrating my 70th birthday on the year the King died...
Sad year that was...
-> options

= thank_you
You took care of them! Thank you!
...
About the reward...
I'm sorry, but I don't have anything to give you.
Feel free to take anything from my field though!
(This is the end of the prototype. Thank YOU for playing!)
-> options