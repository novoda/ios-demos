# ARKit Demo

This repository is a basic iOS using ARKit to allow adding of custom `.dae` or `.scn` files so that they can be viewed through a device in augmented reality.

No prior knowledge of any code is required.

### Requirements

- Xcode 9 or higher
- iPhone 6s or higher(iOS 11 or higher)
- Apple ID

### Setup

- Download and unzip the project
- Open ARDemos.xcodeproj
- Copy any `.dae` or `.scn` model files into `art.scnassets` folder
- Update `.json` file with correct details for the model you have imported

### How to update the .json file

- In Xcode select your model file that you added to the `art.scnassets` folder. You should see your model in the main window.
- On the left bottom side of the corner there should be an icon called `Show the scene graph View` click on that, you will now see the hierarchy of the object, tap the object at the top you want to use.
- On the right top of Xcode there should be a button called `Hide or show utilities` open the utilities using it
- On the top of the utilities look for the cube icon called `Show the nodes inspector` and click on that
- Under identity -> Name there should be a textField, that is the Node Name you will need below (you can change this to whatever, just remember to update this in the `.json` file)

![Alt Text](/ARDemos/UpdateNodeName.gif)

The `.json` file you will be updating is called `ModelsData.json` in the Xcode project. It contains two different sections `sceneSettings` and `models`. Each parameter must have a corresponding value and cannot be left blank. If you don't know what to put, just leave the values that are already there.

#### Scene Settings

- showsStatistics
- autoenablesDefaultLighting
- antialiasingMode
- debugOptions
  - showPhysicsShapes
  - showBoundingBoxes
  - showLightInfluences
  - showLightExtents
  - showPhysicsFields
  - showWireframe
  - renderAsWireframe
  - showSkeletons
  - showCreases
  - showConstraints
  - showCameras
  - showPhysicsShapes

#### Models

- filePath
- fileName
- fileExtension
- nodes
  - name
  - type
- lightSettings
  - intensity
  - shadowMode
  - shadowSampleCount
- planeSettings
  - writesToDepthBuffer
  - colorBufferWriteMask
    - all
    - red
    - green
    - blue
    - alpha

### Running the App
