# godot-physics-fraction

This project demonstrates how to use Godot's get_physics_interpolation_fraction() function to achieve smooth rigidbody motion no matter the physics tick rate (and its fluctuations) by decoupling visual representation from physics representation.  With this project you can explore what happens when the physics tick rate and the render rate differ dramatically.

In Godot, and game platforms in general, smooth motion is achieved when either the physics tick is equal to or greater than the rendering rate (FPS) or when visual bodies are decoupled from their rigidbody representations.

We cannot reliably achieve the first goal, which leaves the second.  Once you decouple a Rigidbody's visual representation from its physics, you can update the visual body in _process and the physics body in _physics_process.

## Physics fraction explained

Learn about the magic ingredient [here](https://docs.godotengine.org/en/latest/classes/class_engine.html#class-engine-method-get-physics-interpolation-fraction).  This function tells us "the fraction through the current physics tick we are at the time of rendering the frame" e.g. [ Start_0.0 ... Physics Tick progress = 0.72 ... End_1.0 ] so, for the current rendered frame we are almost three-quarters of the way through a physics tick.  If we have movement code in _physics_process, it's not going to catch up until some future rendered frame, and when it does catch up, it's going to teleport to the new location.

If we know how far until the next physics tick, we can lerp our positions during _process/idle and avoid any teleportation/stuttering when the physics tick falls below the FPS.  This come at a small cost: living in the past ever so slightly.  We cannot lerp from the current position to an unknown future position -- actually, we can if we choose to make an educated guess of varying uncertainty, but here we want guaranteed smooth motion with no corrections so we'll stick with known, precise positions.  We can only lerp from an object's prior last-known position (where it was before it got here) to its current known position (here!) while we wait for the latest physics tick to finish and return all object new positions.

## How to use the demo

Load the project, export a build and run it.  If you run the project within the Editor it probably won't be as smooth.

![](https://raw.githubusercontent.com/belzecue/images/main/Screen-2021-12-08_15-28-47.png)



The character controller and the blue balls are using physics_fraction-decoupled rigidbodies, where their visual bodies update in _process, i.e. every rendered frame.  The yellow balls are regular rigidbodies whose movement updates entirely inside _physics_process at the physics tick rate.

### Demo components

- **Balls**
  - **Yellow balls**
    - These are plain rigidbodies that update their position during _physics_process.  As the physics tick rate drops below the FPS, movement becomes more of a slideshow.
  - **Blue balls**
    - These balls are dipped in the magic sauce.  Instead of combining rigidbody with a visual body (mesh), the blue balls are constructed with decoupled rigidbodies and visual bodies.  With each rendered frame, the visual body lerps toward the last known physics position of its companion rigidbody according to how far through the current physics tick we are.
    - Notice the yellow corona.  That is a child rigidbody used to indicate where the physics server thinks the ball should be for that physics tick.  As the physics tick rate falls you will see the yellow corona leading the blue visual body more and more.  And yet the blue visual body will continue to move smoothly due to updating/lerping in _process/idle.
  - **Ball boost** (left-CTRL)
    - Give each ball some random acceleration.  Hammer the boost key to really get those balls flying.

- **Player controller**
  - This also uses decoupled visual/physics objects to achieve smooth motion.
  - **Jump** (spacebar)
    - Might as well jump (jump).  Go ahead and jump. Jump jump jump jump.
    - You can wall-climb too.
    - **Infinite jump** (Home key/toggle)


