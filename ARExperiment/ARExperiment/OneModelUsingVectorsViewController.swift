import UIKit
import SceneKit
import ARKit

class OneModelUsingVectorsViewController: UIViewController, ARSCNViewDelegate, ARExperimentSessionHandler {
    
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
        
        if let nodeExists = sceneView.scene.rootNode.childNode(withName: nodeName, recursively: true) {
            nodeExists.removeFromParentNode()
        }
        addNoteToSceneUsingVector(location: location)
    }
    
    private func addNoteToSceneUsingVector(location: CGPoint) {
        guard let model = arViewModel.createSceneNodeForAsset(nodeName,
                                                              assetFolder: assetFolder,
                                                              fileName: fileName,
                                                              assetExtension: fileExtension) else {
                                                                return
        }
        if let hit = arViewModel.hitResult(at: location, in: sceneView, withType: [.existingPlaneUsingExtent, .estimatedHorizontalPlane]) {
            let pointTranslation = hit.worldTransform.translation 
            model.position = SCNVector3(pointTranslation.x, pointTranslation.y, pointTranslation.z)
            sceneView.scene.rootNode.addChildNode(model)
        }
    }
}
