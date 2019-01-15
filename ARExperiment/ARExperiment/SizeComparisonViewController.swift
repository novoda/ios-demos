import UIKit
import SceneKit
import ARKit

class SizeComparisonViewController: UIViewController {

    @IBOutlet var sceneView: ARSCNView!
    @IBOutlet var segmentControl: UISegmentedControl!
    private let arAsset = ARAsset.measuringUnits
    private var arModel: ARViewModel!
    private var currentCube: ARNode?
    private var currentText: ARNode?

    override func viewDidLoad() {
        super.viewDidLoad()

        arModel = ARViewModel(arAsset: arAsset)
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

       removeNodeIfExistAlready()

        guard let hitTransform = arModel.worldTransformForAnchor(at: location,
                                                                 in: sceneView,
                                                                 withType: [.featurePoint]) else {
                                                            return
        }
        let anchor = ARAnchor(transform: hitTransform)
        sceneView.session.add(anchor: anchor)
    }

    private func removeNodeIfExistAlready() {
        if let nodeExists = arModel.nodeExistOnScene(sceneView, nodeName: currentCube?.name ?? "") {
            nodeExists.removeFromParentNode()
        }

        if let nodeExists = arModel.nodeExistOnScene(sceneView, nodeName: currentText?.name ?? "") {
            nodeExists.removeFromParentNode()
        }
    }

    @IBAction func segmentHasBeenChanged(_ sender: UISegmentedControl) {
        switch sender.selectedSegmentIndex {
        case 0:
            currentText = arAsset.nodeWithName("text_5")
            currentCube = arAsset.nodeWithName("cube_5")
        case 1:
            currentText = arAsset.nodeWithName("text_1")
            currentCube = arAsset.nodeWithName("cube_1")
        case 2:
            currentText = arAsset.nodeWithName("text_0.1")
            currentCube = arAsset.nodeWithName("cube_0.1")
        default: break
        }
    }
}

extension SizeComparisonViewController: ARSCNViewDelegate {

    func renderer(_ renderer: SCNSceneRenderer, nodeFor anchor: ARAnchor) -> SCNNode? {
        guard !anchor.isKind(of: ARPlaneAnchor.self) else {
            return nil
        }
        guard let currentCube = currentCube,
            let cube = arModel.createSceneNodeForAsset(currentCube.name),
            let currentText = currentText,
            let text = arModel.createSceneNodeForAsset(currentText.name) else {
                print("could not find node")
                return nil
        }
        let node = SCNNode()
        cube.position = SCNVector3Zero
        text.position = SCNVector3Zero
        node.addChildNode(cube)
        node.addChildNode(text)
        return node
    }
}
