import ARKit
import Foundation

protocol ARExperimentSessionHandler: class {
    func showTrackingState(for trackingState: ARCamera.TrackingState)
    func sessionWasInterrupted(message: String)
    func resetTracking(message: String)
    func sessionErrorOccurred(title: String, message: String)
}

class ARExperimentSession: NSObject, ARSessionDelegate {

    weak var sessionHandler: ARExperimentSessionHandler?
    
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

extension ARExperimentSessionHandler where Self: UIViewController {

    func showTrackingState(for trackingState: ARCamera.TrackingState) {
        title = trackingState.presentationString
    }

    func sessionWasInterrupted(message: String) {
        title = "SESSION INTERRUPTED"
    }

    func resetTracking(message: String) {
        title = "RESETTING TRACKING"
    }

    func sessionErrorOccurred(error: String, message: String) {
        title = error
    }
}
