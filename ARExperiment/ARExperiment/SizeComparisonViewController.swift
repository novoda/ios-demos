import UIKit
import SceneKit
import ARKit

class SizeComparisonViewController: UIViewController, ARExperimentSessionHandler {

    struct CubeModel {
        let fileName: String
        let textFileName: String
        
        static let big = CubeModel(fileName: "cube_5", textFileName: "text_5")
        static let medium = CubeModel(fileName: "cube_1", textFileName: "text_1")
        static let small = CubeModel(fileName: "cube_0.1", textFileName: "text_0.1")
    }
    
    struct Scale {
        let percentage: Float
        
        static let realWorldScale = Scale(percentage: 0.01)
        static let arWorldScale = Scale(percentage: 1)
    }

    @IBOutlet var sceneView: ARSCNView!
    @IBOutlet weak var worldMessuresSegmentedControl: UISegmentedControl!
    @IBOutlet weak var sizeSegmentedControl: UISegmentedControl!

    private var scene: SCNScene?
    private let arSessionDelegate = ARExperimentSession()
    private let arModel = ARViewModel()
    private let fileName = "measuring-units"
    private let fileExtension = "scn"
    private var currentCube = CubeModel.big //Default model
    private var currentScale = Scale.realWorldScale

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

        sceneView.scene.rootNode.childNode(withName: currentCube.fileName, recursively: true)?.removeFromParentNode()
        sceneView.scene.rootNode.childNode(withName: currentCube.textFileName, recursively: true)?.removeFromParentNode()
    }
    
    @IBAction func worldSelectionSegmentControlHasBeenChanged(_ sender: UISegmentedControl) {
        
        sceneView.scene.rootNode.enumerateChildNodes { (node, stop) in
            node.removeFromParentNode()
        }
        
        switch sender.selectedSegmentIndex {
        case 0:
            self.currentScale = .realWorldScale
        case 1:
            self.currentScale = .arWorldScale
        default: break
        }
    }
    
    @IBAction func sizeSegmentControlHasBeenChanged(_ sender: UISegmentedControl) {
        
        switch sender.selectedSegmentIndex {
        case 0:
            currentCube = .big
        case 1:
            currentCube = .medium
        case 2:
            currentCube = .small
        default: break
        }
    }
}

extension SizeComparisonViewController: ARSCNViewDelegate {
    
    func renderer(_ renderer: SCNSceneRenderer, nodeFor anchor: ARAnchor) -> SCNNode? {
        guard !anchor.isKind(of: ARPlaneAnchor.self) else {
            return nil
        }
        guard let cube = arModel.createSceneNodeForAsset(currentCube.fileName,
                                                   fileName: fileName,
                                                   assetExtension: fileExtension),
            let text = arModel.createSceneNodeForAsset(currentCube.textFileName,
                                                   fileName: fileName,
                                                   assetExtension: fileExtension) else {
                                                    print("could not find node")
                                                    return nil
        }
        let node = SCNNode()
        cube.scale = cube.scale.vectorScaled(to:self.currentScale.percentage)
        text.scale = text.scale.vectorScaled(to:self.currentScale.percentage).vectorScaled(z:0.0)
        cube.position = SCNVector3Zero
        text.position = cube.boundingBox.max.vectorScaled(to:self.currentScale.percentage)
        node.addChildNode(cube)
        node.addChildNode(text)
        return node
    }
}
