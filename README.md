## Task

We have a server that allows a client to generate a maze. You are provided with
designs, assets, and a server framework. It is your job to create the client.
This task should take around 4-6 hours, there is no hard limit,
   focus on getting the best results in this time.

Please feel free to ask if you have any questions when interpreting this
document!

## Requirements

 * Implement the iPhone UI as seen in the designs
 * Each time the "Generate" button is pressed you must:
  
  1. Fetch a new starting room from the server
  2. Display the known maze as it is available, the whole maze should be visible
  3. For each new room you need to fetch all adjacent rooms
  4. Adjacent rooms may be locked, unlock them so the room can be fetched
  5. Don't display adjacent rooms until after the new room's image is displayed
  6. Show how long the maze takes to fully generate.

 * Write a unit test to ensure the same room isn't fetched more than once

## Resources

You should have the following:

 * `README.md` - instructions for completing the task
 * `TakeHomeTask.framework` - an interface to the maze server
 * `TakeHomeTask.xcasset` - assets that can be used in your UI
 * `MazeApp-iPhone.jpg` - Designs provided by our made up designer 'Stew Morfik'

## How we evaluate

We want you to succeed! We aim to evaluate each submission with the same
criterion, they are:

 * *Requirements* you've done what we asked you to
 * *Efficiency* fast generation, device resources are used effectively, etc.
 * *Code Architecture* appropriate patterns, structure, etc.
 * *Code Syle* idiomatic, safe, clean, concise etc.
 * *Testability* architecture, design, dependencies, etc.
 * *User Experience* responsive, user-centric design, etc.

## Notes

 * Use Swift;
 * Start with MazeManager, it simulates a server, make sure you retain it;
 * This server is simulated, but the tiles are served from Github;
 * Pretend you're submitting this as production-quality code for review; i.e.,
   - Write the code so it can have unit tests written for it;
   - Make the code adaptable to changing requirements;
   - Write effective comments, enough to understand the code in 6 months;
 * It should be easy to compile, avoid complex dependencies,
    Carthage and CocoaPods are fine;
 * Use the latest (App Store / Stable) Xcode;
 * Choose a minimum iOS version you want to support
   (latest version must be supported);
 * The font we use in the designs Zapfino size 20.0

## Thanks

Tiles derived from the art found at:
  http://www.lostgarden.com/2006/07/more-free-game-graphics.html
