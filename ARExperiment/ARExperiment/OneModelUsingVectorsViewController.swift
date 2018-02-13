import UIKit
import SceneKit
import ARKit

class OneModelUsingVectorsViewController: UIViewController, ARSCNViewDelegate {

    @IBOutlet var sceneView: ARSCNView!
    //MARK: These strings is what you need to switch between different 3D objects
    /** NodeName is the name of the object you want to show, not necessarily the name of the file.
        - You can find the nodeName and change when opening the file on SceneKit Editor (click on the file or right click and use open as SceneKit Editor)
        - on the left bottom side of the corner there should be an icon called "Show the scene graph View" click on that, you will now see the hierarchy of the object, tap the object at the top you want to use
        - on the right top of xcode there should be a button called "Hide or show utilities" open the utilities using it
        - On the top of the utilities look for the cube icon called "Show the nodes inspector" and click on that
        - Under identity -> Name there should be a textField, that is the nodeName you need for here
     **/
    private let nodeName = "banana"
    private let fileName = "banana-small"
    private let fileExtension = "dae"
    private let arViewModel = ARViewModel()

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

        if let nodeExists = sceneView.scene.rootNode.childNode(withName: nodeName, recursively: true) {
            nodeExists.removeFromParentNode()
        }
        addNoteToSceneUsingVector(location: location)
    }

    private func addNoteToSceneUsingVector(location: CGPoint) {
        guard let nodeModel = arViewModel.createSceneNodeForAsset(nodeName, assetPath: "art.scnassets/Banana/\(fileName).\(fileExtension)") else {
            return
        }
        if let hit = arViewModel.getHitResults(location: location, sceneView: sceneView, resultType: [.existingPlaneUsingExtent, .estimatedHorizontalPlane]) {
            let pointTranslation = hit.worldTransform.translation 
            nodeModel.position = SCNVector3(pointTranslation.x, pointTranslation.y, pointTranslation.z)
            sceneView.scene.rootNode.addChildNode(nodeModel)
        }
    }
}
