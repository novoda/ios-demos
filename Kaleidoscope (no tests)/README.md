# Kaleidoscope (no tests)

This demo builds a simulated kaleidoscope. It follows the standard MVC pattern but uses no reactive programming. It also has no tests. I'm planning to rewrite it from scratch strictly following TDD to see what the differences are.

The two most interesting aspects of this app, in my view, are:

- I don't use views as `UIDynamicItem`s. Rather, I use a custom class whose objects conform to the `UIDynamicItem` protocol and do all the `UIKitDynamics` processing on those objects instead. Of course, at the end of the day, I do need to draw them so I pass an array of those custom items to a view that draws them as indiviual little circles.

- I don't actually have as many `UIDynamicItem`s as it looks like. I only have the actual, colliding ones. Then, at drawing time, I draw them along with all their reflections. This is much more performant and is closer to physically realistic kaleidoscopes. A fun exercise is to watch the kaleidoscope in action and try to identify which balls are the "physical" ones and which are merely their reflections.

Some animated gifs:

![](https://github.com/novoda/ios-demos/blob/master/Kaleidoscope%20(no%20tests)/animated_gif_1.gif)

![](https://github.com/novoda/ios-demos/blob/master/Kaleidoscope%20(no%20tests)/animated_gif_2.gif)

![](https://github.com/novoda/ios-demos/blob/master/Kaleidoscope%20(no%20tests)/animated_gif_3.gif)

