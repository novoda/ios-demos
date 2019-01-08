import UIKit
import SceneKit
import ARKit

class SizeComparisonViewController: UIViewController {

    @IBOutlet var sceneView: ARSCNView!
    @IBOutlet var segmentControl: UISegmentedControl!
    private var textName: String = "text_5"
    private var cubeName: String = "cube_5"
    private var scene: SCNScene?
    private let arSessionDelegate = ARExperimentSession()

    override func viewDidLoad() {
        super.viewDidLoad()

        sceneView.delegate = self
        arSessionDelegate.sessionHandler = self
        sceneView.session.delegate = arSessionDelegate
        sceneView.showsStatistics = true
        sceneView.debugOptions = [ARSCNDebugOptions.showFeaturePoints, ARSCNDebugOptions.showWorldOrigin]

        scene = SCNScene(named: "art.scnassets/measuring-units.scn")
        self.viewBackgroundColor(to: .white)
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        let configuration = ARWorldTrackingConfiguration()
        sceneView.session.run(configuration)
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        sceneView.session.pause()
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let location = touches.first?.location(in: sceneView) else {
            return
        }

        if let nodeExists = sceneView.scene.rootNode.childNode(withName: cubeName, recursively: true) {
            nodeExists.removeFromParentNode()
        }

        let hitResultsFeaturePoints: [ARHitTestResult] =
            sceneView.hitTest(location, types: .featurePoint)

        if let hit = hitResultsFeaturePoints.first {
            let anchor = ARAnchor(transform: hit.worldTransform)
            sceneView.session.add(anchor: anchor)
        }
    }

    @IBAction func segmentHasBeenChanged(_ sender: UISegmentedControl) {
        switch sender.selectedSegmentIndex {
        case 0:
            textName = "text_5"
            cubeName = "cube_5"
        case 1:
            textName = "text_1"
            cubeName = "cube_1"
        case 2:
            textName = "text_0.1"
            cubeName = "cube_0.1"
        default: break
        }
    }

    func getNode() -> SCNNode? {

        guard let scene = scene else {
            return nil
        }
        return scene.rootNode.childNode(withName: cubeName, recursively: true)
    }

}

extension SizeComparisonViewController: ARSCNViewDelegate {

    func renderer(_ renderer: SCNSceneRenderer, didAdd node: SCNNode, for anchor: ARAnchor) {
        if !anchor.isKind(of: ARPlaneAnchor.self) {
            DispatchQueue.main.async { [weak self] in
                guard let textNode = self?.getNode() else {
                    print("we have no model")
                    return
                }
                textNode.position = SCNVector3Zero
                // Add model as a child of the node
                node.addChildNode(textNode)
            }
        }
    }
}

extension SizeComparisonViewController: ARExperimentSessionHandler {

    func showTrackingState(for trackingState: ARCamera.TrackingState) {
        title = trackingState.presentationString
    }

    func sessionWasInterrupted(message: String) {
        title = "SESSION INTERRUPTED"
    }

    func resetTracking(message: String) {
        title = "RESETTING TRACKING"
    }

    func sessionErrorOccurred(title: String, message: String) {
        self.title = title
    }
}
