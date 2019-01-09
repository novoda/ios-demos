/*
 Copyright © 2018 Apple Inc.

 Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

 The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

 THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
 */

import Foundation
import ARKit

class StatusViewController: UIViewController {

    enum MessageType {
        case trackingStateEscalation
        case contentPlacement

        static var all: [MessageType] = [
            .trackingStateEscalation,
            .contentPlacement
        ]
    }

    @IBOutlet weak private var messagePanel: UIVisualEffectView!
    @IBOutlet weak private var messageLabel: UILabel!
    @IBOutlet weak private var restartExperienceButton: UIButton!

    var restartExperienceHandler: () -> Void = {}
    private let displayDuration: TimeInterval = 6
    private var messageHideTimer: Timer?
    private var timers: [MessageType: Timer] = [:]

    func showMessage(_ text: String, autoHide: Bool = true) {
        messageHideTimer?.invalidate()
        messageLabel.text = text
        setMessageHidden(false, animated: true)

        if autoHide {
            messageHideTimer = Timer.scheduledTimer(withTimeInterval: displayDuration, repeats: false, block: { [weak self] _ in
                self?.setMessageHidden(true, animated: true)
            })
        }
    }

    func scheduleMessage(_ text: String, inSeconds seconds: TimeInterval, messageType: MessageType) {
        cancelScheduledMessage(for: messageType)

        let timer = Timer.scheduledTimer(withTimeInterval: seconds, repeats: false, block: { [weak self] timer in
            self?.showMessage(text)
            timer.invalidate()
        })

        timers[messageType] = timer
    }

    func showTrackingState(for trackingState: ARCamera.TrackingState) {
        showTrackingQualityInfo(for: trackingState, autoHide: true)

        switch trackingState {
        case .notAvailable, .limited:
            escalateFeedback(for: trackingState, inSeconds: 3.0)
        case .normal:
            cancelScheduledMessage(for: .trackingStateEscalation)
        }
    }

    private func cancelScheduledMessage(for messageType: MessageType) {
        timers[messageType]?.invalidate()
        timers[messageType] = nil
    }

    private func cancelAllScheduledMessages() {
        for messageType in MessageType.all {
            cancelScheduledMessage(for: messageType)
        }
    }

    private func showTrackingQualityInfo(for trackingState: ARCamera.TrackingState, autoHide: Bool) {
        showMessage(trackingState.presentationString, autoHide: autoHide)
    }

    private func escalateFeedback(for trackingState: ARCamera.TrackingState, inSeconds seconds: TimeInterval) {
        cancelScheduledMessage(for: .trackingStateEscalation)

        let timer = Timer.scheduledTimer(withTimeInterval: seconds, repeats: false, block: { [unowned self] _ in
            self.cancelScheduledMessage(for: .trackingStateEscalation)

            var message = trackingState.presentationString
            if let recommendation = trackingState.recommendation {
                message.append(": \(recommendation)")
            }

            self.showMessage(message, autoHide: false)
        })

        timers[.trackingStateEscalation] = timer
    }

    @IBAction private func restartExperience(_ sender: UIButton) {
        restartExperienceHandler()
    }

    private func setMessageHidden(_ hide: Bool, animated: Bool) {
        // The panel starts out hidden, so show it before animating opacity.
        messagePanel.isHidden = false

        guard animated else {
            messagePanel.alpha = hide ? 0 : 1
            return
        }

        UIView.animate(withDuration: 0.2, delay: 0, options: [.beginFromCurrentState], animations: {
            self.messagePanel.alpha = hide ? 0 : 1
        }, completion: nil)
    }
}

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
