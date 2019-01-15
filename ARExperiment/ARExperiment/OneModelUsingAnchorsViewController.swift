import UIKit
import SceneKit
import ARKit

class OneModelUsingAnchorsViewController: UIViewController {

    @IBOutlet var sceneView: ARSCNView!
    private let arAsset = ARAsset.banana
    private var arViewModel: ARViewModel!

    override func viewDidLoad() {
        super.viewDidLoad()

        sceneView.delegate = self
        sceneView.showsStatistics = true
        sceneView.debugOptions = [ARSCNDebugOptions.showFeaturePoints,
                                  ARSCNDebugOptions.showWorldOrigin]
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

        for node in arAsset.nodesOfType(.model) {
            if let nodeExists = arViewModel.nodeExistOnScene(sceneView, nodeName: node.name) {
                nodeExists.removeFromParentNode()
            }
        }

        addNodeToSessionUsingAnchors(location: location)
    }

    private func addNodeToSessionUsingAnchors(location: CGPoint) {

        guard let hitTransform = arViewModel.worldTransformForAnchor(at: location, in: sceneView, withType: .featurePoint) else {
            return
        }
        let anchor = ARAnchor(transform: hitTransform)
        sceneView.session.add(anchor: anchor)
    }
}

extension OneModelUsingAnchorsViewController: ARSCNViewDelegate {

    func renderer(_ renderer: SCNSceneRenderer, nodeFor anchor: ARAnchor) -> SCNNode? {
        if !anchor.isKind(of: ARPlaneAnchor.self) {
            for node in arAsset.nodesOfType(.model) {
                guard let model = arViewModel.createSceneNodeForAsset(node.name) else {
                    print("we have no model")
                    return nil
                }
                let node = SCNNode()
                model.position = SCNVector3Zero
                node.addChildNode(model)
                return node
            }
        }
        return nil
    }
}

