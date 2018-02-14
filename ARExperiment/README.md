# ARExperiment

This is a simple demo app that pairs with our investigation into ARKIT

* `OneModelUsingAnchorsViewController` Adds one 3D model to the scene using `ARAnchors` method described on the [Getting started with ARKit](https://www.novoda.com/blog/getting-started-with-arkit/) blog post
* `OneModelUsingVectorsViewController` Adds one 3D model to the scene using `SCNNodes` and `planeDetection` method described on the [Getting started with ARKit](https://www.novoda.com/blog/getting-started-with-arkit/) blog post
* `SizeComparisonViewController` Adds 3 different sized cubes to the `sceneView` to check how big cm are in the AR world
* `RecognizeObjectsViewController` Adds a 3D model to the scene using CoreML to recognise where to place the model. You can read more on the Machine Learning part in the [Making AR more precise with CoreML](https://www.novoda.com/blog/arkit-coreml/)
* `LightsAnimationsViewController` Adds one 3D model to the scene using `ARAnchors` and allowing for animations, lights and shadows to be imported from the model

## How to contribute to the project
- Pull from master and create a new branch with your project and/or changes
- Push your branch and make a PR. Your PR should have:
  1. Description of what the branch is, or what changes you are making and why
  2. If you're adding a new feature or making UI changes to an existing one, provide screenshots so the changes can be reviewed properly

  Someone will code review your PR as soon as possible. From there, it could be approved right away and merged — great job! :tada: — or it may require some more work. Don't worry if that's the case, the team will work with you to make the necessary changes and get your PR merged!

  If you found a bug/issue with the code you can create an issue on the repo 🤓 be as explicit as you can and we will look at it as soon as possible!
