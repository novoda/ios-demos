import UIKit
import SceneKit
import ARKit

class SizeComparisonViewController: UIViewController {

    @IBOutlet var sceneView: ARSCNView!
    @IBOutlet var segmentControl: UISegmentedControl!
    private var scene: SCNScene?
    private let arSessionDelegate = ARExperimentSession()
    private let arModel = ARViewModel()
    private let fileName = "measuring-units"
    private let fileExtension = "scn"
    private var currentCubeName = ""
    private var currentTextName = ""

    override func viewDidLoad() {
        super.viewDidLoad()

        sceneView.delegate = self
        arSessionDelegate.sessionHandler = self
        sceneView.session.delegate = arSessionDelegate
        sceneView.showsStatistics = true
        sceneView.debugOptions = [ARSCNDebugOptions.showFeaturePoints,
                                  ARSCNDebugOptions.showWorldOrigin]

        scene = SCNScene(named: "art.scnassets/measuring-units.scn")
        self.view.backgroundColor = .white
        styleNavigationBar(with: .white)
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
        sceneView.scene.rootNode.childNode(withName: currentCubeName, recursively: true)?.removeFromParentNode()
        sceneView.scene.rootNode.childNode(withName: currentTextName, recursively: true)?.removeFromParentNode()
    }

    @IBAction func segmentHasBeenChanged(_ sender: UISegmentedControl) {
        switch sender.selectedSegmentIndex {
        case 0:
            currentTextName = "text_5"
            currentCubeName = "cube_5"
        case 1:
            currentTextName = "text_1"
            currentCubeName = "cube_1"
        case 2:
            currentTextName = "text_0.1"
            currentCubeName = "cube_0.1"
        default: break
        }
    }
}

extension SizeComparisonViewController: ARSCNViewDelegate {

    func renderer(_ renderer: SCNSceneRenderer, nodeFor anchor: ARAnchor) -> SCNNode? {
        guard !anchor.isKind(of: ARPlaneAnchor.self) else {
            return nil
        }
        guard let cube = arModel.createSceneNodeForAsset(currentCubeName,
                                                   fileName: fileName,
                                                   assetExtension: fileExtension),
            let text = arModel.createSceneNodeForAsset(currentTextName,
                                                   fileName: fileName,
                                                   assetExtension: fileExtension) else {
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

extension SizeComparisonViewController: ARExperimentSessionHandler {
    var stateDescription: String {
        get {
            return title ?? "\(type(of: self))"
        }
        set {
            title = newValue
        }
    }
}
