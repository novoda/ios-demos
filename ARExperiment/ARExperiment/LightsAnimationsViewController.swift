import UIKit
import SceneKit
import ARKit


class LightsAnimationsViewController: UIViewController {
    
    @IBOutlet var sceneView: ARSCNView!
    private let arAsset = ARAsset.earthMoon
    private var arViewModel: ARViewModel!
    private let arSessionDelegate = ARExperimentSession()
    private var nodesForSession: [SCNNode]?

    override func viewDidLoad() {
        super.viewDidLoad()
        arViewModel = ARViewModel(arAsset: arAsset)
        sceneView.delegate = self
        arSessionDelegate.sessionHandler = self
        sceneView.session.delegate = arSessionDelegate
        
        self.view.backgroundColor = .white
        styleNavigationBar(with: .white)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        let configuration = ARWorldTrackingConfiguration()
        configuration.isLightEstimationEnabled = true;
        
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

        for node in arAsset.nodes {
            if let existingNode = arViewModel.node(in: sceneView, named: node.name) {
                existingNode.removeFromParentNode()
            }
        }

        addNodeToSessionUsingFeaturePoints(location: location)
    }
    
    private func addNodeToSessionUsingFeaturePoints(location: CGPoint) {
        guard let hitTransfrom = arViewModel.worldTransformForAnchor(at: location,
                                                                 in: sceneView, withType: [.estimatedHorizontalPlane,
                                                                                           .existingPlaneUsingExtent]) else {
                                                                    return
        }
        let anchor = ARAnchor(transform: hitTransfrom)
        sceneView.session.add(anchor: anchor)
    }
}

extension LightsAnimationsViewController: ARSCNViewDelegate {

    func renderer(_ renderer: SCNSceneRenderer, nodeFor anchor: ARAnchor) -> SCNNode? {
        guard !anchor.isKind(of: ARPlaneAnchor.self) else {
            return nil
        }

        guard let nodesForSession = nodesForSession else {
            print("nodes were not loaded properly")
            return nil
        }
        let parentNode = SCNNode()
        for node in nodesForSession {
            parentNode.addChildNode(node)
        }
        return parentNode
    }
}

extension LightsAnimationsViewController: ARExperimentSessionHandler {
    func sessionTrackingSwitchedToNormal() {
        if let lightEstimate = sceneView.session.currentFrame?.lightEstimate {
            nodesForSession = arViewModel.nodesForARExperience(using: lightEstimate)
        }
    }
}
