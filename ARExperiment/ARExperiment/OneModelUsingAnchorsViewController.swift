import UIKit
import SceneKit
import ARKit

class OneModelUsingAnchorsViewController: UIViewController, ARExperimentSessionHandler {
    
    @IBOutlet var sceneView: ARSCNView!
    private let assetFolder = "Banana"
    private let nodeName = "banana"
    private let fileName = "banana-small"
    private let fileExtension = "dae"
    private let arViewModel = ARViewModel()
    private let arSessionDelegate = ARExperimentSession()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
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
        
        if let existingNode = sceneView.scene.rootNode.childNode(withName: nodeName, recursively: true) {
            existingNode.removeFromParentNode()
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
        if !anchor.isKind(of: ARPlaneAnchor.self) {
            guard let model = arViewModel.createSceneNodeForAsset(nodeName,
                                                                  assetFolder: assetFolder,
                                                                  fileName: fileName,
                                                                  assetExtension: fileExtension) else {
                                                                    print("we have no model")
                                                                    return nil
            }
            let node = SCNNode()
            model.position = SCNVector3Zero
            node.addChildNode(model)
            return node
        }
        return nil
    }
}
