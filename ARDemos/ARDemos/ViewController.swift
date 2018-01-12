import UIKit
import ARKit
import SceneKit

class ViewController: UIViewController {

    @IBOutlet var sceneView: ARView!
    @IBOutlet var bottomBar: BottomBar!
    
    private var modelNodeModel: SCNNode?
    private var planeNodeModel: SCNNode?
    private var lightNodeModel: SCNNode?
    private let modelFactory = ModelFactory()
    
    private var models: [Model]!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set the view's delegate
        sceneView.delegate = self
        self.models = modelFactory.parseJSON()
        setUpFirstModel()
        setUpModelsOnView()
    }

    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // Create a session configuration
        let configuration = ARWorldTrackingConfiguration()
        configuration.isLightEstimationEnabled = true;

        // Run the view's session
        sceneView.session.run(configuration)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        // Pause the view's session
        sceneView.session.pause()
    }
    
    private func setUpModelsOnView() {
        bottomBar.addModelButtons(models: models ?? [])
        bindButtons()
    }
    
    private func setUpFirstModel() {
        guard let firstModelName = models.first?.fileName else { return }
        setNewModel(with: firstModelName)
    }
    
    private func bindButtons() {
        bottomBar.onTap = { [weak self] (modelName) in
            guard let strongSelf = self else { return }
            strongSelf.setNewModel(with: modelName)
        }
    }
    
    private func setNewModel(with modelName: String) {
        guard let model = models.first(where: { $0.fileName == modelName }) else { return }
        addNodes(to: model)
    }
    
    private func addNodes(to model: Model) {
        let assetpath = model.filePath + model.fileName + model.fileExtension
        model.nodes.forEach { node in
            switch node.type {
            case .object:
                let assetName = node.name
                modelNodeModel = createSceneNodeForAsset(assetName, assetPath: assetpath)
            case .plane:
                let assetName = node.name
                planeNodeModel = createSceneNodeForAsset(assetName, assetPath: assetpath)
            case .lightSource:
                let assetName = node.name
                lightNodeModel = createSceneNodeForAsset(assetName, assetPath: assetpath)
            }
        }
    }
    
    private func createSceneNodeForAsset(_ assetName: String, assetPath: String) -> SCNNode? {
        guard let scene = SCNScene(named: assetPath) else {
            return nil
        }
        let node = scene.rootNode.childNode(withName: assetName, recursively: true)
        return node
    }
}

extension ViewController: ARSCNViewDelegate {
    
    func renderer(_ renderer: SCNSceneRenderer, didAdd node: SCNNode, for anchor: ARAnchor) {
        if !anchor.isKind(of: ARPlaneAnchor.self) {
            DispatchQueue.main.async { [weak self] in
                guard let strongSelf = self else { return }
                guard let model = strongSelf.modelNodeModel else {
                    print("We have no model to render")
                    return
                }
                
                let modelClone = model.clone()
                modelClone.position = SCNVector3Zero
                
                node.addChildNode(modelClone)
                node.addChildNode(strongSelf.lightNodeModel!)
                node.addChildNode(strongSelf.planeNodeModel!)
                                
                strongSelf.setSceneLighting()
                strongSelf.setPlane()
            }
        }
    }
    
    private func setSceneLighting() {
        let estimate: ARLightEstimate! = sceneView.session.currentFrame?.lightEstimate
        let light: SCNLight! = lightNodeModel?.light
        
        light.intensity = estimate.ambientIntensity
        light.shadowMode = .deferred
        light.shadowSampleCount = 16
        
        sceneView.autoenablesDefaultLighting = false;
    }
    
    private func setPlane() {
        let plane = self.planeNodeModel?.geometry!
        
        plane?.firstMaterial?.writesToDepthBuffer = true
        plane?.firstMaterial?.colorBufferWriteMask = []
    }
}
