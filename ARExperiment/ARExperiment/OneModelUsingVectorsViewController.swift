import UIKit
import SceneKit
import ARKit

class OneModelUsingVectorsViewController: UIViewController, ARSCNViewDelegate {
    
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
        sceneView.debugOptions = [ARSCNDebugOptions.showFeaturePoints]
        
        self.view.backgroundColor = .white
        styleNavigationBar(with: .white)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        let configuration = ARWorldTrackingConfiguration()
        configuration.planeDetection = .horizontal
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
            if let existingNode = arViewModel.node(in: sceneView, named: node.name) {
                existingNode.removeFromParentNode()
            }
        }
        addNodesToScene(location: location)
    }

    private func addNodesToScene(location: CGPoint) {
        guard let nodesForSession = nodesForSession else {
            print("we have no model")
            return
        }

        let parentNode = SCNNode()
        for node in nodesForSession {
            parentNode.addChildNode(node)
        }

        if let hit = arViewModel.hitResult(at: location, in: sceneView, withType: [.existingPlaneUsingExtent, .estimatedHorizontalPlane]) {
            let pointTranslation = hit.worldTransform.translation
            parentNode.position = SCNVector3(pointTranslation.x, pointTranslation.y, pointTranslation.z)
            sceneView.scene.rootNode.addChildNode(parentNode)
        }
    }
}

extension OneModelUsingVectorsViewController: ARExperimentSessionHandler {
    func sessionTrackingSwitchedToNormal() {
        if let lightEstimate = sceneView.session.currentFrame?.lightEstimate {
            nodesForSession = arViewModel.nodesForARExperience(using: lightEstimate)
        }
    }
}
