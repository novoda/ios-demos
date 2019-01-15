import UIKit
import SceneKit
import ARKit


class LightsAnimationsViewController: UIViewController {

    @IBOutlet var sceneView: ARSCNView!
    private let arAsset = ARAsset.earthMoon
    private var arModel: ARViewModel!

    override func viewDidLoad() {
        super.viewDidLoad()
        arModel = ARViewModel(arAsset: arAsset)
        sceneView.delegate = self
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

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let location = touches.first?.location(in: sceneView) else {
            return
        }

        for node in arAsset.nodes {
            if let nodeExists = arModel.nodeExistOnScene(sceneView, nodeName: node.name) {
                nodeExists.removeFromParentNode()
            }
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
        guard !anchor.isKind(of: ARPlaneAnchor.self) else {
            return
        }
        DispatchQueue.main.async { [weak self] in
            guard let strongSelf = self else { return }

            for assetNode in strongSelf.arAsset.nodesOfType(.model) {
                if let model = strongSelf.sceneModel(with: assetNode.name) {
                    node.addChildNode(model)
                }
            }

            for lightNode in strongSelf.arAsset.nodesOfType(.light) {
                if let light = strongSelf.sceneLighting(with: lightNode.name) {
                    node.addChildNode(light)
                }
            }

            for planeNode in strongSelf.arAsset.nodesOfType(.plane) {
                if let plane = strongSelf.scenePlane(with: planeNode.name) {
                    node.addChildNode(plane)
                }
            }
        }
    }

    private func sceneModel(with name: String?) -> SCNNode? {
        guard let name = name,
            let model = arModel.createSceneNodeForAsset(name) else {
            return nil
        }
        model.position = SCNVector3Zero
        return model
    }

    private func sceneLighting(with name: String?) -> SCNNode? {
        guard let name = name,
            let lightNode = arModel.createSceneNodeForAsset(name) else {
            return nil
        }

        guard let light: SCNLight = lightNode.light,
            let estimate: ARLightEstimate = sceneView.session.currentFrame?.lightEstimate else {
                return nil
        }
        light.intensity = estimate.ambientIntensity
        light.shadowMode = .deferred
        light.shadowSampleCount = 16
        light.shadowRadius = 24

        return lightNode
    }

    private func scenePlane(with name: String?) -> SCNNode? {
        guard let name = name,
            let planeNode = arModel.createSceneNodeForAsset(name) else {
            return nil
        }

        guard let plane = planeNode.geometry else {
            return nil
        }
        plane.firstMaterial?.writesToDepthBuffer = true
        plane.firstMaterial?.colorBufferWriteMask = []
        plane.firstMaterial?.lightingModel = .constant
        return planeNode
    }
}
