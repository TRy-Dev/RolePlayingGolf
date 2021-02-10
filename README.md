# RolePlayingGolf

[You can play the prototype in browser on itch.io](https://ryzy27.itch.io/role-playing-golf)

![alt text](https://github.com/TRy-Dev/RolePlayingGolf/blob/master/assets/screenshot.png "Screenshot")

This is a short (~5 mins of gameplay) prototype I have developed to actually _publish_ something using my [reusable Modules for Godot engine.](https://github.com/TRy-Dev/RolePlayingGolf/tree/master/src/Modules)

## Modules

While the **Modules** are not properly documented, I believe they can still be used to kickstart any project you might try to build using [Godot game engine.](https://godotengine.org/)

[Here](https://github.com/TRy-Dev/RolePlayingGolf/tree/master/src/Modules) you can find many useful, separated **Modules** that provide simple API for tasks commonly done in game development, such as playing sound effects or creating random values.

Using them should not be a problem if you have some experience with GDscript and Godot API. **Take any you find useful, and build on top of them!**

### Mature Modules
These [Modules](https://github.com/TRy-Dev/RolePlayingGolf/tree/master/src/Modules), I think, if added to Godot project will help you make your game prototype faster.

Add them as AutoLoads or however you like.
* [RNG](https://github.com/TRy-Dev/RolePlayingGolf/blob/master/src/Modules/Core/RNG.gd) - create random float, int, Vector2, Color, noise based float or pick random element from array
* [FileSystem](https://github.com/TRy-Dev/RolePlayingGolf/blob/master/src/Modules/Core/FileSystem.gd) - get contents of directories, concatenate paths - used by MusicController and SfxController
* [StateMachine](https://github.com/TRy-Dev/RolePlayingGolf/tree/master/src/Modules/StateMachine) - based on [GDQuest implementation](https://www.youtube.com/watch?v=Ty4wZL7pDME)
* [CameraController](https://github.com/TRy-Dev/RolePlayingGolf/blob/master/src/Modules/Camera/CameraController.gd) - follow target, shake, zoom and rotate. Based on [this GDC talk](https://www.youtube.com/watch?v=tu-Qe66AvtY&feature=emb_logo)
* [MusicController](https://github.com/TRy-Dev/RolePlayingGolf/blob/master/src/Modules/Audio/MusicController.gd) - load songs(.ogg files) dynamically from chosen directory (see FileSystem), play them using file name
* [SfxController](https://github.com/TRy-Dev/RolePlayingGolf/blob/master/src/Modules/Audio/SfxController.gd) - similar to MusicController (uses .wav files instead of .ogg), but allows for multiple simultanious AudioStreamPlayers and positional 2D sound. 
To allow dynamic loading and picking random clips you should store each _clip group_ (like shoot1.wav, shoot2.wav, ...) in separate directory and call `play(name)` based on directory name.

### Other modules

There are many more modules, but they might not be mature enough to be used for your project.

Many of those were created with help from those amazing people:
* [Gonkee](https://www.youtube.com/channel/UCJqCPFHdbc6443G3Sz6VYDw)
* [Game Endeavor](https://www.youtube.com/channel/UCLweX1UtQjRjj7rs_0XQ2Eg)
* [GDQuest](https://www.youtube.com/channel/UCxboW7x0jZqFdvMdCFKTMsQ)

### Why are Modules kept under this repository and not in dedicated one?

They will be, eventually. I just don't feel that this project is ready for this yet (lack of documentation, many modules are in *prototype* stage).

If you would like to see **Modules** get some love in terms of refactoring, documentation and development, please let me know. **Extra motivation is always welcome!**

## Miz-Jam version

Originaly developed in 48 hours for [Miz-Jam (see jam branch)](https://github.com/TRy-Dev/RolePlayingGolf/tree/miz_jam)

[Play jam version here](https://ryzy27.itch.io/role-playing-golf-jam)


### License

[MIT](https://github.com/TRy-Dev/RolePlayingGolf/blob/master/LICENSE)
