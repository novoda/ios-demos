import UIKit
import SceneKit
import ARKit

class OneModelUsingVectorsViewController: UIViewController, ARSCNViewDelegate {

    @IBOutlet var sceneView: ARSCNView!
    private let arViewModel = ARViewModel(arAsset: ARAsset.banana)

    override func viewDidLoad() {
        super.viewDidLoad()

        sceneView.delegate = self
        sceneView.showsStatistics = true
        sceneView.debugOptions = [ARSCNDebugOptions.showFeaturePoints]
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

        for node in ARAsset.banana.nodesOfType(.model) {
            if let nodeExists = arViewModel.nodeExistOnScene(sceneView, nodeName: node.name) {
                nodeExists.removeFromParentNode()
            }
        }
        addNodesToScene(location: location)
    }

    private func addNodesToScene(location: CGPoint) {
        for node in ARAsset.banana.nodesOfType(.model) {
            addNoteToSceneUsingVector(nodeName: node.name, location: location)
        }
    }

    private func addNoteToSceneUsingVector(nodeName: String, location: CGPoint) {
        guard let model = arViewModel.createSceneNodeForAsset(nodeName) else {
            print("we have no model")
            return
        }
        if let hit = arViewModel.hitResult(at: location, in: sceneView, withType: [.existingPlaneUsingExtent, .estimatedHorizontalPlane]) {
            let pointTranslation = hit.worldTransform.translation
            model.position = SCNVector3(pointTranslation.x, pointTranslation.y, pointTranslation.z)
            sceneView.scene.rootNode.addChildNode(model)
        }
    }
}
