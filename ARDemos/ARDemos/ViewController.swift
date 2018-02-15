import UIKit
import ARKit
import SceneKit

class ViewController: UIViewController, ARSCNViewDelegate{
    
    @IBOutlet var sceneView: ARView!
    @IBOutlet var bottomBar: BottomBar!
    
    private var responseData: ResponseData?
    private var currentModel: Model?
    private var currentNode: ObjectNode?
    
    private let modelFactory = DataFactory()
    private let jsonFileName = "ModelsData"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set the view's delegate
        sceneView.delegate = self
        responseData = modelFactory.parseJSON(fileName: jsonFileName)
        setUpFirstModel()
        setUpModelsOnView()
        setupSceneSettings()
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        let configuration = ARWorldTrackingConfiguration()
        configuration.isLightEstimationEnabled = true;
        configuration.planeDetection = .horizontal

        sceneView.session.run(configuration)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        sceneView.session.pause()
    }

    //MARK:View objects

    private func bindButtons() {
        bottomBar.onTap = { [weak self] (modelName) in
            guard let strongSelf = self else { return }
            strongSelf.setNewModel(with: modelName)
        }
    }

    private func setUpModelsOnView() {
        bottomBar.addModelButtons(models: responseData?.models ?? [])
        bindButtons()
    }

    private func setupSceneSettings() {
        guard let sceneSettings = responseData?.sceneSettings else {
            return
        }
        sceneView.apply(sceneSettings: sceneSettings)
    }
    
    //MARK: Create SCNode objects

    private func setUpFirstModel() {
        guard let models = responseData?.models else {
            return
        }
        guard let firstModelName = models.first?.fileName else { return }
        setNewModel(with: firstModelName)
    }
    
    private func setNewModel(with modelName: String) {
        guard let models = responseData?.models else {
            return
        }
        guard let model = models.first(where: { $0.fileName == modelName }) else { return }
        currentModel = model
        currentNode = createNode(from: model)
    }

    private func createNode(from model: Model) -> ObjectNode? {
        let assetPath = model.filePath + model.fileName + model.fileExtension
        let childNode = ObjectNode()
        model.nodes.forEach { node in
            switch node.type {
            case .object:
                childNode.addObjectNode(nodeName: node.name, assetPath: assetPath)
            case .plane:
                guard let planeSettings = currentModel?.planeSettings else { return }
                childNode.addPlaneNode(nodeName: node.name, assetPath: assetPath, planeSettings: planeSettings)
            case .light:
                guard let lightEstimate = sceneView.session.currentFrame?.lightEstimate else { return }
                childNode.addLightNode(nodeName: node.name, assetPath: assetPath, lightSettings: currentModel?.lightSettings, lightEstimate: lightEstimate)
            }
        }
        return childNode
    }

    //MARK: Adding SCNode objects to the scene

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let location = touches.first?.location(in: sceneView) else {
            return
        }

        if let nodeName =  currentNode?.name,
            let nodeExists = sceneView.scene.rootNode.childNode(withName: nodeName, recursively: true) {
            nodeExists.removeFromParentNode()
        }
        setNodeOnLocation(location)
    }

    private func setNodeOnLocation(_ location: CGPoint) {
        let hitResultsFeaturePoints: [ARHitTestResult] = sceneView.hitTest(location, types: .featurePoint)

        if let hit = hitResultsFeaturePoints.first {

            let rotate = simd_float4x4(SCNMatrix4MakeRotation(sceneView.session.currentFrame!.camera.eulerAngles.y, 0, 1, 0))
            let finalTransform = simd_mul(hit.worldTransform, rotate)

            let pointTranslation = finalTransform.translation
            if let currentNode = currentNode {
                currentNode.position = SCNVector3(pointTranslation.x, pointTranslation.y, pointTranslation.z)
                sceneView.scene.rootNode.addChildNode(currentNode)
            }
        }
    }
}
