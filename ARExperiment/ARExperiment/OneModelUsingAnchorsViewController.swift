import UIKit
import SceneKit
import ARKit

class OneModelUsingAnchorsViewController: ARExampleViewController {

    @IBOutlet var sceneView: ARSCNView!
    private let nodeName = "banana"
    private let fileName = "banana-small"
    private let fileExtension = "dae"
    private let arViewModel = ARViewModel()

    override func viewDidLoad() {
        super.viewDidLoad()

        sceneView.delegate = self
        sceneView.showsStatistics = true
        sceneView.debugOptions = [ARSCNDebugOptions.showFeaturePoints,
                                  ARSCNDebugOptions.showWorldOrigin]
        setbackgroundColor()
        setNavigationBar(controllerName: "\(OneModelUsingAnchorsViewController.self)")
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

        if let nodeExists = sceneView.scene.rootNode.childNode(withName: nodeName, recursively: true) {
            nodeExists.removeFromParentNode()
        }

        addNodeToSessionUsingAnchors(location: location)
    }

    private func addNodeToSessionUsingAnchors(location: CGPoint) {
        if let hit = arViewModel.getHitResults(location: location, sceneView: sceneView, resultType: [.featurePoint, .estimatedHorizontalPlane]) {
            let anchor = ARAnchor(transform: hit.worldTransform)
            sceneView.session.add(anchor: anchor)
        }
    }
}

extension OneModelUsingAnchorsViewController: ARSCNViewDelegate {

    func renderer(_ renderer: SCNSceneRenderer, nodeFor anchor: ARAnchor) -> SCNNode? {
        if !anchor.isKind(of: ARPlaneAnchor.self) {
            guard let model = arViewModel.createSceneNodeForAsset(nodeName, assetPath: "art.scnassets/\(fileName).\(fileExtension)") else {
                print("we have no model")
                return nil
            }
            model.position = SCNVector3Zero
            return model
        }
        return nil
    }
}

