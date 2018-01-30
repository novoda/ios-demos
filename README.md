# iOS demos [![](https://raw.githubusercontent.com/novoda/novoda/master/assets/btn_apache_lisence.png)](LICENSE.txt)

This is a collection of basic iOS examples created by Novoda. Most recent at the top.

* [Rick-and-Morty](https://github.com/novoda/ios-demos/tree/master/Rick-and-Morty)
This is a project to be used for pairing sessions with potential new hires. The application is basically a `TabViewController` with 2 different tabs: "Rick" and "Morty". Each tab implements a `CollectionViewController` with a hardcoded data source. The implementation is really basic so there is plenty of refactoring potential.

* [Demo for the Apple TV](https://github.com/novoda/ios-demos/tree/master/TVDemo)
This is a barebones demo of a content-delivery app for the Apple TV. It's not a native app but uses the TVMLKit framework's javascript templates to display content. All the content urls are hardcoded at the moment, rather than served from a json file. The app showcases different templates and also shows how to play video from both inside an element and in full-screen mode. It's based on Apple's sample code.

* [Adaptive iOS Design](https://github.com/novoda/ios-demos/tree/master/Adaptive%20iOS%20Design)
This demo is not a full application but simply shows different stages of getting a sample screen design to behave adaptively. It is part of a [Hack & Tell](https://www.youtube.com/watch?v=iI4PmsjYW3Y&index=1&list=PLsAfcuwrBov7UYpOrN8ez7Y0e-O38bOoa) I gave on adaptive iOS design. See [linked pdf](https://github.com/novoda/ios-demos/blob/master/Adaptive%20iOS%20Design/Adaptive%20iOS%20Design.pdf) for the H&T slides.

* [Kaleidoscope (no tests)](https://github.com/novoda/ios-demos/tree/master/Kaleidoscope%20(no%20tests))
A simulated kaleidoscope. It follows the standard MVC pattern but uses no reactive programming. It also has no tests. I'm planning to rewrite it from scratch strictly following TDD to see what the differences are.

* [Calculator - Your First iOS App](https://github.com/novoda/ios-demos/tree/master/Your%20First%20iOS%20App)
A very simple calculator app, with just enough interesting bits to give an idea of what an iOS app looks like from a developer's point of view. No, it has no error checking or unit tests, and doesn't follow the MVC pattern the way it should, but it's a start.

* [Earl Grey demo](https://github.com/novoda/ios-demos/tree/master/Earl-Grey-Demo): A demo project showing how to use [Earl Grey](https://github.com/google/EarlGrey) in an iOS project. Also includes our wrapper API which makes it easier to use (see the [UITest file](https://github.com/novoda/ios-demos/blob/master/Earl-Grey-Demo/Earl-Grey-DemoTests/UITest.swift)). Requires a `gem install earlgrey && pod install` first.

* [Cucumberish - BDD testing framework + sample app](https://github.com/novoda/ios-demos/tree/master/Cucumberish-demo): Sample iOS app with the Cucumberish - BDD testing framework. Includes implementation of the UI tests on MiraclePillUITests target. Requires `pod install` before opening xcworkspace. It is part of the [blog post](https://www.novoda.com/blog/cucumberish-bdd-testing-framework-for-ios-applications-sample-application/).

* [CustomScheduler](https://github.com/novoda/ios-demos/blob/master/CustomScheduler.swift)
A custom scheduler to easily run tasks either in the back- or the foreground.

* [UIView+Autolayout](https://github.com/novoda/ios-demos/blob/master/UIView%2BAutolayout.swift)
extends UIView; Import this into your project to be able to use constraints programmatically in a straightforward way.

* [ARDemos](https://github.com/novoda/ios-demos/tree/master/ARDemos): This repository is a basic iOS app using ARKit to allow adding of custom `.dae` or `.scn` files so that they can be viewed through a device in augmented reality. No prior knowledge of any code is required.

* [ARExperiment](https://github.com/novoda/ios-demos/tree/master/ARExperiment): Sample iOS app with the different demos . It is part of the [blog post](https://www.novoda.com/blog/).

## How to add a new project
 - Pull from master and create a new branch with your project and/or changes
 - If you are creating a new project make sure that XCode did not created a `.git` file inside of your folder. You can check that by going inside the project folder on terminal and entering `ls -la` if there is a `.git` folder it will conflict with the git repository of the `ios-demos` repo. Delete it by entering `rm -rf .git` while being inside your project folder.
- Push your branch and make a PR. Your PR should have:
  1. Description of what the project is, or what changes you are making and why
  2. If you're adding a new project or making UI changes to an existing one, provide screenshots so the changes can be reviewed properly

  Someone will code review your PR as soon as possible. From there, it could be approved right away
  and merged — great job! :tada: — or it may require some more work. Don't worry if that's the case,
  the team will work with you to make the necessary changes and get your PR merged!
