# ARKit Demo

This repository is a basic iOS app using ARKit to allow adding of custom `.dae` or `.scn` files so that they can be viewed through a device in augmented reality.

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

![Gif Missing](/ARDemos/UpdateNodeName.gif)

The `.json` file you will be updating is called `ModelsData.json` in the Xcode project. It contains two different sections `sceneSettings` and `models`. Each parameter must have a corresponding value and cannot be left blank. If you don't know what to put, just leave the values that are already there.

#### Scene Settings

- showsStatistics - Determines whether the receiver should display statistics info like FPS.
- autoenablesDefaultLighting - Specifies whether the receiver should automatically light up scenes that have no light source
- antialiasingMode - NA `multisampling4X`, `multisampling2X` or `none`
- debugOptions - Most of these are self explanatory, but we've added some descriptions to remove any ambiguity
  - showPhysicsShapes
  - showBoundingBoxes - show object bounding boxes
  - showLightInfluences - show objects's light influences
  - showLightExtents
  - showPhysicsFields - show physics fields forces and extents
  - showWireframe - show wireframe on top of objects
  - renderAsWireframe
  - showSkeletons - show skinning bones
  - showCreases - show subdivision creases
  - showConstraints - show slider constraint
  - showCameras
  - showPhysicsShapes

#### Models

- filePath - The path where your `.dae` or `.scn` file is. Don't for get to add a `/` at the end. e.g `/art.scnassets/Banana/`
- fileName - The name of your `.dae` or `.scn` file. e.g `Banana`
- fileExtension - The type of file, either `.dae` or `.scn`
- nodes - Encapsulates the position, rotations, and other transforms, which define a coordinate system.
  - name - Determines the name of the receiver
  - type - Whether the node is a type of `object`, `light` or `plane`
- lightSettings - Settings for a light that can be attached to a Node.
  - intensity - used to modulate the light color. When used with a physically-based material, this corresponds to the luminous flux of the light, expressed in lumens (lm)
  - shadowMode - The mode to use to cast shadows. Choose from `forward`, `deferred` or `modulated`
  - shadowSampleCount - The number of sample per fragment to compute the shadow map.
- planeSettings
  - writesToDepthBuffer - Determines whether the receiver writes to the depth buffer when rendered.
  - colorBufferWriteMask - Determines whether the receiver writes to the color buffer when rendered. Settings are either true or false
    - all
    - red
    - green
    - blue
    - alpha

### Running the App

Once you have added your files and update the `ModelsData.json` you are almost ready to run and use the app.

The final steps are:

- Change the bundle identifier where it says `novoda` to your name
- Select automatically manage signing
- Choose Your profile in the Team selection box
- Make sure your phone is plugged in and select it form the device list in the top left corner
- Make sure the phone is unlocked
- Press the play button in Xcode

![Gif Missing](/ARDemos/SetupToRunApp.gif)

Note: You may/will get popups saying to wait until your device is ready, or to add the app to be trusted. If so just follow the instructions in the popup that appears.
