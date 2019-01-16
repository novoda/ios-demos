import UIKit
import SceneKit
import ARKit

class OneModelUsingAnchorsViewController: UIViewController {
    
    @IBOutlet var sceneView: ARSCNView!
    private let arAsset = ARAsset.banana
    private var arViewModel: ARViewModel!
    private let arSessionDelegate = ARExperimentSession()
    private var nodesForSession: [SCNNode]?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        arViewModel = ARViewModel(arAsset: arAsset)
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

        for node in arAsset.nodesOfType(.model) {
            if let nodeExists = arViewModel.node(in: sceneView, named: node.name) {
                nodeExists.removeFromParentNode()
            }
        }
        
        addNodeToSessionUsingAnchors(location: location)
    }
    
    private func addNodeToSessionUsingAnchors(location: CGPoint) {
        guard let hitTransform = arViewModel.worldTransformForAnchor(at: location, in: sceneView, withType: [.featurePoint, .estimatedHorizontalPlane]) else {
            return
        }
        let anchor = ARAnchor(transform: hitTransform)
        sceneView.session.add(anchor: anchor)
    }
}

extension OneModelUsingAnchorsViewController: ARSCNViewDelegate {
    
    func renderer(_ renderer: SCNSceneRenderer, nodeFor anchor: ARAnchor) -> SCNNode? {
        guard !anchor.isKind(of: ARPlaneAnchor.self) else {
            return nil
        }

        guard let nodesForSession = nodesForSession else {
            print("we have no model")
            return nil
        }

        let parentNode = SCNNode()
        for node in nodesForSession {
            parentNode.addChildNode(node)
        }

        return parentNode
    }
}

extension OneModelUsingAnchorsViewController: ARExperimentSessionHandler {
    func sessionTrackingSwitchedToNormal() {
        if let lightEstimate = sceneView.session.currentFrame?.lightEstimate {
            nodesForSession = arViewModel.nodesForARExperience(using: lightEstimate)
        }
    }
}
