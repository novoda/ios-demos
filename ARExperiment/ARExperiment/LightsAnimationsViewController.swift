import UIKit
import SceneKit
import ARKit


class LightsAnimationsViewController: UIViewController {

    @IBOutlet var sceneView: ARSCNView!
    fileprivate var objectNodeModel: SCNNode?
    fileprivate var secondObjectNodeModel: SCNNode?
    fileprivate var planeNodeModel: SCNNode?
    fileprivate var lightNodeModel: SCNNode?
    private let fileName = "EarthMoon/earth-moon"
    private let fileExtension = "dae"
    private let objectNode1 = "earth"
    private let objectNode2 = "moon_orbit"
    private let planeNode = "Plane"
    private let lightNode = "Sun"

    override func viewDidLoad() {
        super.viewDidLoad()

        sceneView.delegate = self
        objectNodeModel = createSceneNodeForAsset(objectNode1, assetPath: "art.scnassets/\(fileName).\(fileExtension)")
        secondObjectNodeModel = createSceneNodeForAsset(objectNode2, assetPath: "art.scnassets/\(fileName).\(fileExtension)")
        planeNodeModel = createSceneNodeForAsset(planeNode, assetPath: "art.scnassets/\(fileName).\(fileExtension)")
        lightNodeModel = createSceneNodeForAsset(lightNode, assetPath: "art.scnassets/\(fileName).\(fileExtension)")
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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

    private func createSceneNodeForAsset(_ assetName: String, assetPath: String) -> SCNNode? {
        guard let paperPlaneScene = SCNScene(named: assetPath) else {
            return nil
        }
        let carNode = paperPlaneScene.rootNode.childNode(withName: assetName, recursively: true)
        return carNode
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
        let hitResultsFeaturePoints: [ARHitTestResult] =
            sceneView.hitTest(location, types: .featurePoint)

        if let hit = hitResultsFeaturePoints.first {
            let rotate = simd_float4x4(SCNMatrix4MakeRotation(sceneView.session.currentFrame!.camera.eulerAngles.y, 0, 1, 0))
            let finalTransform = simd_mul(hit.worldTransform, rotate)
            let anchor = ARAnchor(transform: finalTransform)
            sceneView.session.add(anchor: anchor)
        }
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
