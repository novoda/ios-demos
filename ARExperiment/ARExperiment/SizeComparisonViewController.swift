import UIKit
import SceneKit
import ARKit

class SizeComparisonViewController: UIViewController {
    
    @IBOutlet var sceneView: ARSCNView!
    @IBOutlet var segmentControl: UISegmentedControl!
    private let arAsset = ARAsset.measuringUnits
    private var arModel: ARViewModel!
    private var currentCube: SCNNode?
    private var currentText: SCNNode?
    private let arSessionDelegate = ARExperimentSession()
    private var nodesForSession: [SCNNode]?

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
            currentText = nodesForSession?.findNode(withName: "text_5")
            currentCube = nodesForSession?.findNode(withName: "cube_5")
        case 1:
            currentText = nodesForSession?.findNode(withName: "text_1")
            currentCube = nodesForSession?.findNode(withName: "cube_1")
        case 2:
            currentText = nodesForSession?.findNode(withName: "text_0.1")
            currentCube = nodesForSession?.findNode(withName: "cube_0.1")
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
            let currentText = currentText else {
                print("could not find node")
                return nil
        }
        let node = SCNNode()
        currentCube.position = SCNVector3Zero
        currentText.position = SCNVector3Zero
        node.addChildNode(currentCube)
        node.addChildNode(currentText)
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
