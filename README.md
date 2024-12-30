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

## Tutorial
### Installation
1. Install Openplanet Plugin *Moving Track Configurator*.  
2. Download *Moving Track Generator* from [Releases](https://github.com/AchimBunke/TM_MovingTrackGenerator/releases).  
3. Unzip the generator wherever.
   
### Use
#### Generating Tracks with moving Items
1. Open a map in the Trackmania Editor.
2. Under Plugins/ open the Moving Track Configuration plugin.
3. Place moving Items (Items that have a KinematicConstraint and allow animations).
4. Select an item (e.g. Ctrl).
5. Check the *Mark* checkbox or *Mark All Instances* if all items of the same model should be marked.  
![image](https://github.com/user-attachments/assets/803c3687-2f75-4767-bab3-95f75a8348e3)  
6. Configure the AABB properties to match the item. This box is used to later test against the player's driven path and calculate block arrival times. (Make sure it extends over the block so the player drives *through the box*).  
![image](https://github.com/user-attachments/assets/29e697b8-cc2c-40e8-baff-dc67c64ae918)  
7. Select one of the predefined Animation Orders. This determines the order of Sub-Animations.  
![image](https://github.com/user-attachments/assets/2c65a53d-d23e-4418-9396-bb1d637bbb50)  
8. Open the **Arrival Calculator** and check the *Track Arrivals* checkbox.  
![image](https://github.com/user-attachments/assets/4fc9ea98-1603-4729-bd51-0c02bb97ab4b)  
9. Enter TestMode and drive a path. Afterwards exit the TestMode and uncheck *Track Arrivals*. (So that the path is not overwritten the next time).  
![image](https://github.com/user-attachments/assets/85a2c4de-a9a6-4aaf-af8d-7fe3641c93d7)  
10. Under *Generation* click *Generate Arrivals*.  
![image](https://github.com/user-attachments/assets/14af6ea0-477a-4192-a465-1aa46010a30d)  
11. Adjust *Arrival Index*, *Arrival Time* or *Arrival Position* for each block if necessary.  
![image](https://github.com/user-attachments/assets/6a9785e0-47a2-44ae-b34c-50edb5c04024)  
12. Configure the animation properties for a selected block.  
Each property can be a combination of fixed or calculated values. Use the dropdown to select the type of formula parameter:
    - **Max:** The maximum value of the movement. (eg. animation up 30 units => Max = 30, Axis = Y)
    - **Axis:** The axis of movement.
    - **Wait 1 Duration:** The initial waiting duration (eg. Delay until player arrives).
    - **Wait 1 Easing:** The initial waiting Easing function (Constant for waiting).
    - **FlyIn:** Animation of movement from Max to 0).
    - **FlyOut:** Animation of movement from 0 to Max.
Operator Types:
  - **Fixed:** A single static value.
  - **Random:** Generator uses a random value from the provided parameters.
    - **Avoid Arrival Dir:** Generator will not choose the direction from where the player is arriving from at this block.
    - **Inside Var declarations, the random value is fixed across uses. The resulting Var value stays constant except with the use of arrival times!**
  - **Arrival:** Generator will use the arrival time of the block this formula is used on.
  - **Var:** Generator will use the value defined in the *Variables* section (Be careful of using vars as errors due to mismatched naming or types only occur in the generator).
  - **Value From:** Takes the calculated result from a formula of another Sub-Animation that came **before** this Sub-Animation (Be careful to check with the Animation Order if the other Sub-Animation really came before it!).  
![image](https://github.com/user-attachments/assets/d3cd7fe8-fa8e-482f-9a4d-1e59898dc064)  
In this example:
  - Translation is random between 10 and 40 units in a random direction except the one the player arrives from.
  - Animation Order defines that the block will start at *Max* and after the wait will animate to its original position before inversing this motion.
  - Initially i wait until 2 seconds before the player arrives (2 seconds from *moveTime* because the block needs time to move in position).
  - The move to initial position in 2 seconds.
  - Then wait between 1 and 3 seconds.
  - Then animate back to *Max* translation using the same time as used in FlyIn.
For Rotation I copied the values and just adjusted the Max value as it is a value of degrees.
13. Copy this settings to all other instances of this Item Model.
14. Under *Save/Load* these map-dependant settings can be saved. This will create a meta file next to the map file.  
![image](https://github.com/user-attachments/assets/f3f9eaf3-4276-440d-b24a-81c4aafa6b46)  
15. Start the **Moving Track Generator** from the unzipped directory.   
![image](https://github.com/user-attachments/assets/b26487b9-4f8e-4334-b17c-41c562139924)  
16. On the right, set your Author name and select the Trackmania folder where your maps/items are saved. (Default: user\Documents\Trackmania). Adjust other folders as needed. Items will be generated into the *GeneratedItemsFolder* and maps into the *GeneratedMapsFolder*.
17. Click *Start* to start a server that listens to the Openplanet plugin. It should say *Waiting for Connection* in the Console.
18. From the Configurator Plugin under *Generation/* click *Send MapData to Server*.  
![image](https://github.com/user-attachments/assets/d0bafcf2-0d2e-4ef8-91e3-c5ab4fe545dd)  
if succesfull, there should now be information about the map like a preview of all marked items and an export path and name.  
![image](https://github.com/user-attachments/assets/c3eb2849-8eae-4cc2-8b90-f0262a6d3c56)   
ItemsPrefix can be used to prevent conflicts when generating items from the same model in different generation steps (Generating from the same item model and map name twice will overwrite the first batch of generated items). As i only want to generate once we can leave it empty.
19. **Make sure your map is saved from the Editor!! Items will only be generated from the map file!**
20. Click *Generate*.  
![image](https://github.com/user-attachments/assets/32089b88-7324-405f-bc78-f569b47ca4ae)  
Green nodes indicate successfull generation and replacement. Check the logs for further details.
21. If no errors occured, configure *Export Map Path* and click *Save*.
22. **Restart Trackmania 2020!! New Items will not be loaded while its still running and you will get a *Missing Items* when opening the generated map otherwise.**
23. Open the newly generated map (Export path) in the Editor. Each previously marked movable item should have been replaced by a variant executing the configured animation.
**If the generation was faulty or another map should be generated, the original map can still be opened, the saved configuration loaded and the generation executed again. Just be aware that generating will possibly overwrite previously generated items depending on map name, item model and ItemsPrefix!**

#### Generating Items
This tool can also be just used to generate different moving Items which then can be manually edited with **Editor++**.  
For this just follow the step above, then open the generated map and modify the placed items.

#### Multiple Generation steps and partial map Generation
The **Copy To All** makes it very easy to share animation configuration across multiple items. But if a section of a map should not receive these configurations, you still have to copy/paste those onto each item.  
This is why I recommend only marking sets of similar animated items, then generating a map replacing those instances, and then opening the genrated map and repeating this process.  
This way, the configuration can easily be copied to all objects (marking objects is easier than copy/pasting configurations).  
**But be careful when generating items using the same map name. An ItemPrefix has to be specified so that items in previous generation results are not overwritten!**


# TODO

- Add more sub-animation templates. (E.g. FlyIn -> FlyOut -> FlyIn -> FlyOut)
- Item grouping for selection and copy/paste of animation settings.
- Incremental generation from the same map. (instead of generating a new map, load and modify already existing generated map)
- Better arrival route tracking. (E.g. integration of EditorRoute plugin)
- Evaluate different schema for sub-animations (different from FlyIn, Wait, FlyOut) for more intuitive control.
- Automatic moving item generation from static items.
- Preview of generated animations in Configurator and Generator). (display of translation path and rotation as e.g. bounding volume to check for intersection with other items/route)
- Make layout for animation configuration more intuitive.
- Merge generator and configurator into standalone plugin.


 
    



  




