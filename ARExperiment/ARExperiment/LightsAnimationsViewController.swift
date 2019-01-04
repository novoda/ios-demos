import UIKit
import SceneKit
import ARKit


class LightsAnimationsViewController: UIViewController {

    @IBOutlet var sceneView: ARSCNView!
    private let arModel = ARViewModel()
    fileprivate var objectNodeModel: SCNNode?
    fileprivate var secondObjectNodeModel: SCNNode?
    fileprivate var planeNodeModel: SCNNode?
    fileprivate var lightNodeModel: SCNNode?
    private let assetFolder = "EarthMoon"
    private let fileName = "earth-moon"
    private let fileExtension = "dae"
    private let objectNode1 = "Sphere"
    private let objectNode2 = "Moon_Orbit"
    private let planeNode = "Plane"
    private let lightNode = "Sun"

    override func viewDidLoad() {
        super.viewDidLoad()

        sceneView.delegate = self
        setUpModelsOnLoad()
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

    private func setUpModelsOnLoad() {
        objectNodeModel = modelForNodeName(objectNode1)
        secondObjectNodeModel = modelForNodeName(objectNode2)
        planeNodeModel = modelForNodeName(planeNode)
        lightNodeModel = modelForNodeName(lightNode)
    }

    private func modelForNodeName(_ nodeName: String) -> SCNNode? {
        return arModel.createSceneNodeForAsset(nodeName,
                                               assetFolder: assetFolder,
                                               fileName: fileName,
                                               assetExtension: fileExtension)
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let location = touches.first?.location(in: sceneView) else {
            return
        }

        if let nodeExists = sceneView.scene.rootNode.childNode(withName: objectNode1, recursively: true),
            let secondNodeExists = sceneView.scene.rootNode.childNode(withName: objectNode2, recursively: true) {
            nodeExists.removeFromParentNode()
            secondNodeExists.removeFromParentNode()
        }
        addNodeToSessionUsingFeaturePoints(location: location)
    }

    private func addNodeToSessionUsingFeaturePoints(location: CGPoint) {
        guard let hitTransfrom = arModel.getTransformForAnchor(location: location,
                                                               sceneView: sceneView, resultType: [.featurePoint]) else {
                                                                return
        }
        let anchor = ARAnchor(transform: hitTransfrom)
        sceneView.session.add(anchor: anchor)
    }
}

extension LightsAnimationsViewController: ARSCNViewDelegate {

    func renderer(_ renderer: SCNSceneRenderer, didAdd node: SCNNode, for anchor: ARAnchor) {
        if !anchor.isKind(of: ARPlaneAnchor.self) {
            DispatchQueue.main.async { [weak self] in
                guard let strongSelf = self else { return }
                guard let model = strongSelf.objectNodeModel,
                let secondModel = strongSelf.secondObjectNodeModel else {
                    print("We have no model to render")
                    return
                }

                let modelClone = model.clone()
                modelClone.position = SCNVector3Zero
                let secondModelClone = secondModel.clone()
                secondModel.position = SCNVector3Zero

                node.addChildNode(modelClone)
                node.addChildNode(secondModelClone)
                if let lightNodeModel = strongSelf.lightNodeModel {
                    strongSelf.setSceneLighting()
                    node.addChildNode(lightNodeModel)
                }
                if let planeNodeModel = strongSelf.planeNodeModel {
                    strongSelf.setScenePlane()
                    node.addChildNode(planeNodeModel)
                }
            }
        }
    }

    private func setSceneLighting() {
        guard let lightnode = lightNodeModel else { return }

        if let light: SCNLight = lightnode.light,
            let estimate: ARLightEstimate = sceneView.session.currentFrame?.lightEstimate {
            light.intensity = estimate.ambientIntensity
            light.shadowMode = .deferred
            light.shadowSampleCount = 16
            light.shadowRadius = 24
        }
    }

    private func setScenePlane() {
        guard let planenode = planeNodeModel else { return }

        if let plane = planenode.geometry {
            plane.firstMaterial?.writesToDepthBuffer = true
            plane.firstMaterial?.colorBufferWriteMask = []
            plane.firstMaterial?.lightingModel = .constant
        }
    }
}
