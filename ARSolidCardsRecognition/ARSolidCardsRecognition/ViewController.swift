import UIKit
import SpriteKit
import ARKit

class ViewController: UIViewController {
    
    @IBOutlet var sceneView: ARSKView!
    @IBOutlet weak var blurView: UIVisualEffectView!

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

        // Hook up status view controller callback(s).
        statusViewController.restartExperienceHandler = { [unowned self] in
            self.restartExperience()
        }
        // Show statistics such as fps and node count
        sceneView.showsFPS = true
        sceneView.showsNodeCount = true
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

extension ViewController: ARSKViewDelegate {

    func resetTracking() {

        guard let referenceImages = ARReferenceImage.referenceImages(inGroupNamed: "AR Resources", bundle: nil) else {
            fatalError("Missing expected asset catalog resources.")
        }

        let configuration = ARWorldTrackingConfiguration()
        configuration.worldAlignment = .gravityAndHeading
        configuration.detectionImages = referenceImages
        session.run(configuration, options: [.resetTracking, .removeExistingAnchors])

        statusViewController.scheduleMessage("Look around to detect images", inSeconds: 7.5, messageType: .contentPlacement)
    }

    func view(_ view: ARSKView, nodeFor anchor: ARAnchor) -> SKNode? {
        guard let imageAnchor = anchor as? ARImageAnchor else { return nil}
        let referenceImage = imageAnchor.referenceImage

        DispatchQueue.main.async {
            let imageName = referenceImage.name ?? ""
            self.statusViewController.cancelAllScheduledMessages()
            self.statusViewController.showMessage("Detected image “\(imageName)”")
        }

        return getNodeFor(referenceImage, on: imageAnchor)
    }

}

extension ViewController {

    private func getNodeFor(_ referenceImage: ARReferenceImage, on anchor: ARImageAnchor) -> SKNode? {
        guard let imageName = referenceImage.name,
            imageName.contains("SOLID") else {
                return nil
        }
        var text = ""

        switch imageName {
        case "SOLID-substitution-principle":
            text = "Substitutability is a principle in object-oriented programming stating that," +
                "in a computer program, if S is a subtype of T, " +
                "then objects of type T may be replaced with objects of type S "
                + "without altering any of the desirable properties of the program"
        case "SOLID-open-close":
            text = "The open/closed principle states software entities (classes, modules, functions, etc.) should be open for extension, but closed for modification"

        case "SOLID-dependency-injection":
            text = "The interface-segregation principle states " +
                "that no client should be forced to depend on " +
            "methods it does not use"
        case "SOLID-single-responsibility":
            text = "The single responsibility principle states that every module or class should have responsibility over a single part of the functionality provided by the software, and that responsibility should be entirely encapsulated by the class."
        case "SOLID-segregation":
            text = "The dependency inversion principle states that High-level modules should not depend on low-level modules. Both should depend on abstractions and abstractions should not depend on details. Details should depend on abstractions."
        default:
            return nil
        }

        let skScene = SKScene(size: referenceImage.physicalSize)
        skScene.backgroundColor = UIColor.clear

        let labelNode = SKLabelNode(text: text)
        labelNode.fontSize = 20
        labelNode.fontColor = SKColor.blue
        labelNode.position = CGPoint(x:(referenceImage.physicalSize.width) / 2,
                                     y:(referenceImage.physicalSize.height) / 2)
        labelNode.horizontalAlignmentMode = .center
        labelNode.verticalAlignmentMode = .center
        labelNode.zRotation = .pi

        let rectangle = SKShapeNode(rect: CGRect(x: 0,
                                                 y: 0,
                                                 width: referenceImage.physicalSize.width,
                                                 height: referenceImage.physicalSize.height),
                                    cornerRadius: 5)
        rectangle.fillColor = SKColor.white
        rectangle.alpha = 0.25

        skScene.addChild(rectangle)
        skScene.addChild(labelNode)

        let material = SCNMaterial()
        material.isDoubleSided = true
        material.diffuse.contents = skScene

        let plane = SCNPlane(width: referenceImage.physicalSize.width,
                             height: referenceImage.physicalSize.height)
        plane.materials = [material]

        let node = SKNode()
//        node.geometry?.materials = [material]
//        node.eulerAngles.x = -.pi / 2
        return node
    }
}
