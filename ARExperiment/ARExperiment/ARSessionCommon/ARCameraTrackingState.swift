import Foundation
import ARKit

extension ARCamera.TrackingState {
    var presentationString: String {
        switch self {
        case .notAvailable:
            return "TRACKING UNAVAILABLE"
        case .normal:
            return "TRACKING NORMAL"
        case .limited(.excessiveMotion):
            return "TRACKING LIMITED\nExcessive motion"
        case .limited(.insufficientFeatures):
            return "TRACKING LIMITED\nLow detail"
        case .limited(.initializing):
            return "Initializing"
        case .limited(.relocalizing):
            return "Recovering from session interruption"
        }
    }

    var recommendation: String? {
        switch self {
        case .limited(.excessiveMotion):
            return "Try slowing down your movement, or reset the session."
        case .limited(.insufficientFeatures):
            return "Try pointing at a flat surface, or reset the session."
        case .limited(.relocalizing):
            return "Try returning to where you were when the interruption began, or reset the session."
        default:
            return nil
        }
    }
}

