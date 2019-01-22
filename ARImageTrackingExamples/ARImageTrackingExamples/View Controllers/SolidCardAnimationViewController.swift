import Foundation
import UIKit
import ARKit

class SolidCardAnimationViewController: UIViewController, ARExperimentSessionHandler {

    @IBOutlet var sceneView: ARSCNView!
    private let arSessionDelegate = ARExperimentSession()
    private let arViewModel = ARViewModel()

    override func viewDidLoad() {
        super.viewDidLoad()
        sceneView.delegate = self
        arSessionDelegate.sessionHandler = self
        sceneView.session.delegate = arSessionDelegate
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        let configuration = arViewModel.imageTrackingConfiguration()
        sceneView.session.run(configuration, options: [.removeExistingAnchors, .resetTracking])
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        sceneView.session.pause()
    }
}

extension SolidCardAnimationViewController: ARSCNViewDelegate {

    func renderer(_ renderer: SCNSceneRenderer, didAdd node: SCNNode, for anchor: ARAnchor) {
        guard let imageAnchor = anchor as? ARImageAnchor else {
            return
        }

        guard let image = arViewModel.image(correspondingTo: imageAnchor.referenceImage) else {
            print("could not find image")
            return
        }

        let plane = SCNPlane(width: imageAnchor.imageSize().width,
                             height: imageAnchor.imageSize().height)
        plane.firstMaterial?.colorBufferWriteMask = .alpha

        let planeNode = SCNNode(geometry: plane)
        planeNode.eulerAngles.x = -.rightAngle
        planeNode.renderingOrder = .renderFirst

        let solidDataPlane = SCNPlane(width: imageAnchor.imageSize().width / 2,
                                      height: imageAnchor.imageSize().height)
        solidDataPlane.styleFirstMaterial(with: image)

        node.addChildNode(planeNode)
    }
}


