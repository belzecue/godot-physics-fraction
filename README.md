# godot-physics-fraction

This project demonstrates how to use Godot's get_physics_interpolation_fraction() function to achieve smooth rigidbody motion no matter the physics tick rate and its fluctuations.

Smooth motion can be achieved if either the physics tick is always equal to or greater than the rendering rate (FPS) or if visual bodies are separated from their rigidbody representations.

We cannot reliably achieve the first, which leaves the second method.  Once you decouple a Rigidbody's visual representation from its physics, you can update the visual body in _process and the physics body in _physics_process.

## Physics fraction explained

Learn about the magic ingredient [here](https://docs.godotengine.org/en/latest/classes/class_engine.html#class-engine-method-get-physics-interpolation-fraction).  This function tells us "the fraction through the current physics tick we are at the time of rendering the frame" e.g. [ Start_0.0 ... Physics Tick in progress = 0.72 ... End_1.0 ] so, for the current rendered frame we are almost three-quarters of the way through a physics tick.  If we have movement code in _physics_process, it's not going to catch up until some future rendered frame, and when it does catch up, it's going to teleport to the new location.

If we know how far until the next physics tick, we can lerp our positions during _process and avoid any teleportation/stuttering when the physics tick falls below the FPS.  This come at a small cost, which is living in the past ever so slightly.  We cannot lerp from the current position to an unknown future position -- actually we can if we choose to make an educated guess of varying uncertainty, but here we want guaranteed smooth motion with no corrections so we'll stick with known, precise positions.  We can only lerp from an object's prior last-known position (where it was before it got here) to its current known position (here!) while we wait for the latest physics tick to finish.

## How to use the demo

Load the project, export a build and run it.  If you run the project within the Editor it probably won't be as smooth.

![](https://raw.githubusercontent.com/belzecue/images/main/Screen-2021-12-08_15-28-47.png)

The purpose here is to explore the effect of having a physics tick and FPS that drastically do not match, and to demonstrate that when you decouple visual representations from physics representations, smooth motion results at low physics rates.

The character controller and the blue balls are using physics_fraction-decoupled rigidbodies, where their visual bodies update in _process, i.e. every rendered frame.  The yellow balls are regular rigidbodies whose movement updates entirely inside _physics_process at the physics tick rate.


