import UIKit
import SceneKit
import ARKit

class SizeComparisonViewController: UIViewController {
    
    enum CubeModel {
        case big    //5x5
        case medium //1x1
        case small  //0.1x0.1
        
        var filename: String {
            switch self {
            case .big:
                return "cube_5"
            case .medium:
                return "cube_1"
            case .small:
                return "cube_0.1"
            }
        }
        
        var textFilename: String {
            switch self {
            case .big:
                return "text_5"
            case .medium:
                return "text_1"
            case .small:
                return "text_0.1"
            }
        }
    }
    
    enum Scale {
        case arWorldScale
        case realWorldScale
        
        var persentage: Float {
            switch self {
            case .arWorldScale:
                return 1
            case .realWorldScale:
                return 0.01
            }
        }
    }
    
    @IBOutlet var sceneView: ARSCNView!
    @IBOutlet weak var realWorldMeasuresSegmentedControl: UISegmentedControl!
    @IBOutlet weak var ARMeasuresSegmentedControl: UISegmentedControl!

    private let arModel = ARViewModel()
    private let fileName = "measuring-units"
    private let fileExtension = "scn"
    
    private var currentCube = CubeModel.big //Default model
    private var currentScale:Scale = .realWorldScale

    override func viewDidLoad() {
        super.viewDidLoad()

        sceneView.delegate = self
        sceneView.showsStatistics = true
        sceneView.debugOptions = [ARSCNDebugOptions.showFeaturePoints,
                                  ARSCNDebugOptions.showWorldOrigin]

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
        if let nodeExists = sceneView.scene.rootNode.childNode(withName: currentCube.filename, recursively: true) {
            nodeExists.removeFromParentNode()
        }

        if let nodeExists = sceneView.scene.rootNode.childNode(withName: currentCube.textFilename, recursively: true) {
            nodeExists.removeFromParentNode()
        }
    }

    @IBAction func segmentHasBeenChanged(_ sender: UISegmentedControl) {
        
        //If the user selects ar measures, `realWorldMeasuresSegmentedControl` should be deselected
        //otherwise `ARMeasuresSegmentedControl` should be deselected.
        (sender == self.ARMeasuresSegmentedControl ? self.realWorldMeasuresSegmentedControl : self.ARMeasuresSegmentedControl).selectedSegmentIndex = UISegmentedControlNoSegment
        
        self.currentScale = sender == self.ARMeasuresSegmentedControl ? .arWorldScale : .realWorldScale
        
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
        guard let cube = arModel.createSceneNodeForAsset(currentCube.filename,
                                                   fileName: fileName,
                                                   assetExtension: fileExtension),
            let text = arModel.createSceneNodeForAsset(currentCube.textFilename,
                                                   fileName: fileName,
                                                   assetExtension: fileExtension) else {
                                                    print("could not find node")
                                                    return nil
        }
        let node = SCNNode()
        cube.scale = cube.scale.vectorScaled(to:self.currentScale.persentage)
        text.scale = text.scale.vectorScaled(to:self.currentScale.persentage).vectorScaled(z:0.0)
        cube.position = SCNVector3Zero
        text.position = cube.boundingBox.max.vectorScaled(to:self.currentScale.persentage)
        node.addChildNode(cube)
        node.addChildNode(text)
        return node
    }
}

extension SCNVector3 {
    
    func vectorScaled(to scale:Float) -> SCNVector3{
        return SCNVector3 (self.x * scale , self.y * scale, self.z * scale)
    }
    
    func vectorScaled(_ x:Float = 1.0, y:Float = 1.0, z:Float = 1.0) -> SCNVector3{
        return SCNVector3 (self.x * x , self.y * y, self.z * z)
    }
}
