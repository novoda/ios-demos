# ARExperiment

This is a simple demo app that pairs with our investigation into ARKIT

* `OneModelUsingAnchorsViewController` Adds one 3D model to the scene using `ARAnchors` method described on the [Getting started with ARKit](https://www.novoda.com/blog/getting-started-with-arkit/) blog post
* `OneModelUsingVectorsViewController` Adds one 3D model to the scene using `SCNNodes` and `planeDetection` method described on the [Getting started with ARKit](https://www.novoda.com/blog/getting-started-with-arkit/) blog post
* `SizeComparisonViewController` Adds 3 different sized cubes to the `sceneView` to demonstrate how big cm are in the AR world
* `RecognizeObjectsViewController` Adds a 3D model to the scene using CoreML to recognise where to place the model. You can read more on the Machine Learning part in the [Making AR more precise with CoreML](https://www.novoda.com/blog/arkit-coreml/)
* `LightsAnimationsViewController` Adds one 3D model to the scene using `ARAnchors` and allowing for animations, lights and shadows to be imported from the model

## FileNames vs NodeNames

At the beginning of every controller you will see there are around 3 or more string variables hardcoded
  - `fileName` if you are assets are not on the route of `art.scnassets` folder you should add the folder name before the file name like so: `Banana/banana`
  - `fileExtension` you can have the same file on both `.dae` and `.scn` format
  - `nodeName` NodeName is the name of the object you want to show, not necessarily the name of the file. You can find the nodeName and change when opening the file on SceneKit Editor (click on the file or right click and use open as SceneKit Editor)
    - On the left bottom side of the corner there should be an icon called "Show the scene graph View" click on that, you will now see the hierarchy of the object, tap the object at the top you want to use
    - On the top right of xcode there should be a button named "Hide or show utilities" open the utilities using it
    - On the top of the utilities look for the cube icon called "Show the nodes inspector" and click on that
    - Under identity -> Name there should be a textField, that is the nodeName you need for here

![Gif Missing](/ARDemos/UpdateNodeName.gif)

[How to contribute to the project](/master/README.md#how-to-add-a-new-project)
