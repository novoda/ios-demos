import UIKit
import SceneKit
import ARKit

class SizeComparisonViewController: UIViewController {

    @IBOutlet var sceneView: ARSCNView!
    @IBOutlet var segmentControl: UISegmentedControl!
    private let arModel = ARViewModel()
    private let fileName = "measuring-units"
    private let fileExtension = "scn"
    private var currentCubeName = ""
    private var currentTextName = ""
    private let centimetersScale = Float(0.01)

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
        if let nodeExists = sceneView.scene.rootNode.childNode(withName: currentCubeName, recursively: true) {
            nodeExists.removeFromParentNode()
        }

        if let nodeExists = sceneView.scene.rootNode.childNode(withName: currentTextName, recursively: true) {
            nodeExists.removeFromParentNode()
        }
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
        cube.scale = cube.scale.vectorScaled(to:centimetersScale)
        text.scale = text.scale.vectorScaled(to:centimetersScale).vectorScaled(z:0.0)
        cube.position = SCNVector3Zero
        text.position = cube.boundingBox.max.vectorScaled(to:centimetersScale)
        node.addChildNode(cube)
        node.addChildNode(text)
        return node
    }
}

extension SCNVector3 {
    
    func vectorScaled(to scale:Float) -> SCNVector3{
        return SCNVector3 (self.x * scale , self.y * scale, self.z * scale)
    }
    
    func vectorScaled(_ x:Float = 1.0, y:Float = 1.0, z:Float = 1.0) -> SCNVector3{
        return SCNVector3 (self.x * x , self.y * y, self.z * z)
    }
}
