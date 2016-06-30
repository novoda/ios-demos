# Ch4 Demo using TVML templates

This is a barebones demo of a content-delivery app for the Apple TV. It's not a native app but uses the TVMLKit framework's javascript templates to display content. All the content urls are hardcoded at the moment, rather than served from a json file. The app showcases different templates and also shows how to play video from both inside an element and in full-screen mode. It's based on Apple's sample code.

## Requirements
Build Requirements: Xcode 8.0, tvOS 10.0 SDK
Runtime Requirements: tvOS 10.0 or later

## Installation instructions:
To start a local server run the following command in a terminal within the **Server** folder to create a simple webserver.

```
ruby -run -ehttpd . -p9001
```
