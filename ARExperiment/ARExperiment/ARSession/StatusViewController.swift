/*
See LICENSE folder for this sample’s licensing information.

Abstract:
Utility view controller for showing messages above the AR view.
*/

import Foundation
import ARKit

class StatusViewController: UIViewController {
    // MARK: - Properties

    @IBOutlet weak var messagePanel: UIView!
    @IBOutlet weak var messageLabel: UILabel!

    @IBOutlet weak var restartExperienceButton: UIButton!

    /// Trigerred when the "Restart Experience" button is tapped.
    var restartExperienceHandler: () -> Void = {}

    var isRestartExperienceButtonEnabled: Bool {
        get { return restartExperienceButton.isEnabled }
        set { restartExperienceButton.isEnabled = newValue }
    }

    // Timer for hiding messages.
    private var messageHideTimer: Timer?

    // MARK: - Message Handling
    
	func showMessage(_ text: String, autoHide: Bool = true) {
        // Cancel any previous hide timer.
        messageHideTimer?.invalidate()

        messageLabel.text = text

        // Make sure status is showing.
        showHideMessage(hide: false, animated: true)

        if autoHide {
            // Seconds before fade out. Adjust if the app needs longer transient messages.
            let displayDuration: TimeInterval = 6
            messageHideTimer = Timer.scheduledTimer(withTimeInterval: displayDuration, repeats: false, block: { [weak self] _ in
                self?.showHideMessage(hide: true, animated: true)
            })
        }
	}

	// MARK: - Panel Visibility
    
	private func showHideMessage(hide: Bool, animated: Bool) {
		guard animated else {
			messageLabel.isHidden = hide
			return
		}
		
		UIView.animate(withDuration: 0.2, delay: 0, options: [.allowUserInteraction, .beginFromCurrentState], animations: {
            self.messageLabel.isHidden = hide
            self.updateMessagePanelVisibility()
        }, completion: nil)
	}
	
	private func updateMessagePanelVisibility() {
		// Show and hide the panel depending whether there is something to show.
		messagePanel.isHidden = messageLabel.isHidden
	}

    // MARK: - IBActions

    @IBAction func restartExperience(_ sender: UIButton) {
        restartExperienceHandler()
    }
}
