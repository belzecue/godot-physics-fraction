# godot-physics-fraction

This project demonstrates how to use Godot's get_physics_interpolation_fraction() function to achieve smooth rigidbody motion no matter the physics tick rate and its fluctuations.

Smooth motion can be achieved if either the physics tick is always equal to or greater than the rendering rate (FPS) or if visual bodies are separated from their rigidbody representations.

We cannot reliably achieve the first, which leaves the second method.  Once you decouple a Rigidbody's visual representation from its physics, you are free to update the visual body in _process and the physics body in _physics_process.

## Physics fraction explained

Learn about the magic ingredient [here](https://docs.godotengine.org/en/latest/classes/class_engine.html#class-engine-method-get-physics-interpolation-fraction).

## How to use the demo

Load the project, export a build and run it.  If you run the project within the Editor it probably won't be as smooth.

![](https://raw.githubusercontent.com/belzecue/images/main/Screen-2021-12-08_15-28-47.png)

The purpose here is to explore the effect of having a physics tick and FPS that drastically do not match, and to demonstrate that when you decouple visual representations from physics representations, smooth motion results at low physics rates.


