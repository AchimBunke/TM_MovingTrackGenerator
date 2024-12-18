# TM_MovingTrackGenerator
The **Moving Track Generator** allows for the creation of maps in Trackmania 2020 with a lot of moving items.  
It also provides **In-Editor** configuration as well as tools for generating animations.  

**Build maps 'like always' and generate variants of movable items afterwards!**

## Why?
Trackmania 2020 supports movable physics items using animations. Though they have some limitations, they allow for some cool maps and scenery.  
### Problem 1: Animations are part of the Item Model
The biggest problem I encountered was that theses animations are part of the item model and **not** of the map they are used in.  
This means that multiple instances of that item in a map will result in each instance moving the exact same way at the exact same time.  

For each different animation I must edit/copy the item and adjust the animation properties and place it.
For just a few items thats fine, but it is very tedious and time consuming for a lot of items.

### Problem 2: Editing Animations and way to many Items
The **Editor++** Openplanet plugin makes it very easy to edit the animation on items.  
But after I save an item and exit the ItemEditor, I have trouble figuiring out which items have what animation in map or my item library.  

I want to build a scenery with possibly hundreds of moving items each having the same model and different animations so i need some intuitive way to see the animation properties of items placed in a map outside of the ItemEditor.  

### Problem 3: Player timing specific animations
This one is a bit more specific.  
For the MediaTracker, I can set triggers to control when the MediaTracker should display e.g. some image or 3D triangles.  

This is not possible with physics interactions.  

What I could do instead is driving my map and tracking my positions and timings for my driven route. I can then use these timings to introduce some delay to my animations and make the block move at the exact point in time where i expect the average player to pass it.  
This obviously makes any player slower or faster than my run miss the exact animation timing but still makes for great scenery oand very precise routes.  

With tools like **EditorRoute** i can inspect my driven route in the Editor and maybe figure out the animation timing but i would still have to edit every single item and place it at the exact position.  
Afterwards, I cannot easily change the route anymore witout redoing everything.  

## Features
The **Moving Track Generator** is a tool split betwen an
1. Openplanet Plugin: [Moving Track Configurator](#Moving-Track-Configurator)
2. C# Script: [Moving Track Generator](#Moving-Track-Generator)

### Moving Track Configurator
Configure animation properties in the Trackmania 2020 Editor.  
**Configuration is used to generate a new map and items with the [Moving Track Generator](#Moving-Track-Generator)**.  
**It does not directly change the Item Model or map!**
- Tracking of movable items.  
- Calculating arrival times for each item (when does a player drive over or is closest to an item) of a driven path.
- In-Editor customization of animation properties.
  - Fixed animation properties.
  - Randomized animation properties.
  - Arrival time dependant animation properties.
  - Shared animation properties across different items.
  - Expression based calculation of animation properties

### Moving Track Generator
Generate a Trackmania 2020 map using a configuration from the [Moving Track Configurator](#Moving-Track-Configurator).  

- Generating variants of movable items containing the provided animation properties.
- Generating maps replacing items with its configured animated variant.
- Small preview of map and item layout.

  ## How?
  
