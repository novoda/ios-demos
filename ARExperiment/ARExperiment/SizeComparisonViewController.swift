import UIKit
import SceneKit
import ARKit

class SizeComparisonViewController: UIViewController {
    
    @IBOutlet var sceneView: ARSCNView!
    @IBOutlet weak var worldMessuresSegmentedControl: UISegmentedControl!
    @IBOutlet weak var sizeSegmentedControl: UISegmentedControl!
    private let arAsset = ARAsset.measuringUnits
    private var arModel: ARViewModel!
    private let arSessionDelegate = ARExperimentSession()
    private var nodesForSession: [SCNNode]?
    private var currentCube = CubeModel.big
    private var currentScale = Scale.realWorldScale

    override func viewDidLoad() {
        super.viewDidLoad()

        arModel = ARViewModel(arAsset: arAsset)
        sceneView.delegate = self
        arSessionDelegate.sessionHandler = self
        sceneView.session.delegate = arSessionDelegate
        sceneView.showsStatistics = true
        sceneView.debugOptions = [ARSCNDebugOptions.showFeaturePoints,
                                  ARSCNDebugOptions.showWorldOrigin]
        
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
                                                                 withType: [.featurePoint,
                                                                            .estimatedHorizontalPlane]) else {
                                                                                return
        }
        let anchor = ARAnchor(transform: hitTransform)
        sceneView.session.add(anchor: anchor)
    }
    
    private func removeNodeIfExistAlready() {

        if let nodeExists = arModel.node(in: sceneView, named: currentCube.fileName) {
            nodeExists.removeFromParentNode()
        }

        if let nodeExists = arModel.node(in: sceneView, named: currentCube.textFileName) {
            nodeExists.removeFromParentNode()
        }

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

        guard let nodesForSession = nodesForSession,
            let cube = nodesForSession.findNode(withName: currentCube.fileName),
            let text = nodesForSession.findNode(withName: currentCube.textFileName) else {
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

extension SizeComparisonViewController: ARExperimentSessionHandler {
    func sessionTrackingSwitchedToNormal() {
        if let lightEstimate = sceneView.session.currentFrame?.lightEstimate {
            nodesForSession = arModel.nodesForARExperience(using: lightEstimate)
        }
    }
}

private extension Array where Element == SCNNode {
    func findNode(withName name: String) -> SCNNode? {
        return self.filter{$0.name == name}.first
    }
}
