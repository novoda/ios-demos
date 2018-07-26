import UIKit
import SpriteKit
import ARKit

class ViewController: UIViewController {
    
    @IBOutlet var sceneView: ARSCNView!
    @IBOutlet weak var blurView: UIVisualEffectView!
    var labelView: UIView?

    /// The view controller that displays the status and "restart experience" UI.
    lazy var statusViewController: StatusViewController = {
        return children.lazy.compactMap({ $0 as? StatusViewController }).first!
    }()

    var session: ARSession {
        return sceneView.session
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        sceneView.delegate = self
        sceneView.session.delegate = self
        blurView.isHidden = true

        // Hook up status view controller callback(s).
        statusViewController.restartExperienceHandler = { [unowned self] in
            self.restartExperience()
        }
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        // Prevent the screen from being dimmed to avoid interuppting the AR experience.
        UIApplication.shared.isIdleTimerDisabled = true

        // Start the AR experience
        resetTracking()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        // Pause the view's session
        sceneView.session.pause()
    }

    /// Prevents restarting the session while a restart is in progress.
    var isRestartAvailable = true
}

extension ViewController {

    func resetTracking() {

        guard let referenceImages = ARReferenceImage.referenceImages(inGroupNamed: "AR Resources", bundle: nil) else {
            fatalError("Missing expected asset catalog resources.")
        }

//        let configuration = ARWorldTrackingConfiguration()
//        configuration.worldAlignment = .gravityAndHeading
//        configuration.maximumNumberOfTrackedImages = 2
//        configuration.detectionImages = referenceImages

        let configuration = ARImageTrackingConfiguration()
        configuration.maximumNumberOfTrackedImages = 2
        configuration.trackingImages = referenceImages

        session.run(configuration, options: [.resetTracking, .removeExistingAnchors])

        statusViewController.scheduleMessage("Look around to detect images", inSeconds: 7.5, messageType: .contentPlacement)
    }
}
