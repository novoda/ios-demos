/*
 Copyright © 2018 Apple Inc.

 Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

 The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

 THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
 */

import ARKit
import Foundation

protocol ARExperimentSessionHandler {
    func showTrackingState(for trackingState: ARCamera.TrackingState)
    func sessionWasInterrupted(message: String)
    func resetTracking(message: String)
    func sessionErrorOccurred(title: String, message: String)
}

class ARExperimentSession: NSObject, ARSessionDelegate {

    var sessionHandler: ARExperimentSessionHandler?
    
    func session(_ session: ARSession, cameraDidChangeTrackingState camera: ARCamera) {
        sessionHandler?.showTrackingState(for: camera.trackingState)
    }
    
    func session(_ session: ARSession, didFailWithError error: Error) {
        guard error is ARError else { return }
        
        let errorWithInfo = error as NSError
        let messages = [
            errorWithInfo.localizedDescription,
            errorWithInfo.localizedFailureReason,
            errorWithInfo.localizedRecoverySuggestion
        ]

        let errorMessage = messages.compactMap({ $0 }).joined(separator: "\n")
        sessionHandler?.sessionErrorOccurred(title: "The AR session failed.", message: errorMessage)
    }
    
    func sessionWasInterrupted(_ session: ARSession) {
        sessionHandler?.sessionWasInterrupted(message: """
        SESSION INTERRUPTED
        The session will be reset after the interruption has ended.
        """)
    }
    
    func sessionInterruptionEnded(_ session: ARSession) {
        sessionHandler?.resetTracking(message: "RESETTING SESSION")

        if let configuration = session.configuration {
            session.run(configuration, options: [.resetTracking])
        }
    }
    
    func sessionShouldAttemptRelocalization(_ session: ARSession) -> Bool {
        return true
    }
    
}
