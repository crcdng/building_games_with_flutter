# Building Games with Flutter

Updated code of the book "Building Games with Flutter" by Paul Teale / Packt

Now for Flame 1.28.1 / Flutter 3.32. NOTE the code now diverges from the book to be compatible with latest versions. I also run it through `flutter_lints`.

- https://flame-engine.org/
- https://flutter.dev/

Rationale: I found the book to be a good comprehensive introduction to game development with the Flame game engine. However, Flame has changed a lot since the book came out. So I updated the code as I went through the chapters as an exercise. I left most of the original code intect, with three notable differences: 

1. Throughout, I use the `camera` system, adding components to the `world` and user interface (HUD) elements to `camera.viewport` instead of adding everything to the game object. See https://docs.flame-engine.org/latest/flame/camera_component.html 
2. Also I tweaked the particle effect (chapter 9) a bit. 
3. I added the `flutter_lints` package and some analyzer options for better code insights, then refactored the code following the linter recommendations

I checked  

- chapter 1, 2, 4 to 7 and 9 to 11 on macOS (chapter 3 doesn't have code),
- chapter 8 on Chrome / web, and
- chapter 11 also on a Pixel 7 / Android 35 emulator.

Platform folders are not in git so you have to add them yourself.

TODO: test on mobile devices, refactor a few more places, tweak parameters

Credits: 

Building Games with Flutter by Paul Teale, Packt, 2022.
- https://www.packtpub.com/product/building-games-with-flutter/9781801816984

original code by Paul Teale
- https://github.com/PacktPublishing/Building-Games-with-Flutter

see License




