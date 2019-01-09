import UIKit
import SceneKit
import ARKit


class LightsAnimationsViewController: UIViewController {

    @IBOutlet var sceneView: ARSCNView!
    private let arModel = ARViewModel()
    fileprivate var earthNode: SCNNode?
    fileprivate var moonNode: SCNNode?
    fileprivate var planeNodeModel: SCNNode?
    fileprivate var lightNodeModel: SCNNode?
    private let arViewModel = ARViewModel()
    private let arSessionDelegate = ARExperimentSession()
    private let assetFolder = "EarthMoon"
    private let fileName = "earth-moon"
    private let fileExtension = "dae"
    private let earthNodeName = "Sphere"
    private let moonNodeName = "Moon_Orbit"
    private let planeNode = "Plane"
    private let lightNode = "Sun"

    override func viewDidLoad() {
        super.viewDidLoad()

        sceneView.delegate = self
        arSessionDelegate.sessionHandler = self
        sceneView.session.delegate = arSessionDelegate

        self.viewBackgroundColor(to: .white)
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
        earthNode = modelForNodeName(earthNodeName)
        moonNode = modelForNodeName(moonNodeName)
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

        if let nodeExists = sceneView.scene.rootNode.childNode(withName: earthNodeName, recursively: true),
            let secondNodeExists = sceneView.scene.rootNode.childNode(withName: moonNodeName, recursively: true) {
            nodeExists.removeFromParentNode()
            secondNodeExists.removeFromParentNode()
        }
        addNodeToSessionUsingFeaturePoints(location: location)
    }

    private func addNodeToSessionUsingFeaturePoints(location: CGPoint) {
        guard let hitTransfrom = arModel.worldTransformForAnchor(at: location,
                                                                 in: sceneView, withType: [.featurePoint]) else {
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
                guard let model = strongSelf.earthNode,
                let secondModel = strongSelf.moonNode else {
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

extension LightsAnimationsViewController: ARExperimentSessionHandler {

    func showTrackingState(for trackingState: ARCamera.TrackingState) {
        title = trackingState.presentationString
    }

    func sessionWasInterrupted(message: String) {
        title = "SESSION INTERRUPTED"
    }

    func resetTracking(message: String) {
        title = "RESETTING TRACKING"
    }

    func sessionErrorOccurred(title: String, message: String) {
        self.title = title
    }
}
