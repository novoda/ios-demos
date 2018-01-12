import UIKit
import ARKit

class ViewController: UIViewController {

    @IBOutlet var sceneView: ARView!
    @IBOutlet var bottomBar: BottomBar!
    
    private var modelNodeModel: SCNNode?
    private var lightNodeModel: SCNNode?
    private var planeNodeModel: SCNNode?
    
    private var models: [Model]!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set the view's delegate
        sceneView.delegate = self
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
}

extension ViewController: ARSCNViewDelegate {
    
    func renderer(_ renderer: SCNSceneRenderer, didAdd node: SCNNode, for anchor: ARAnchor) {
        if !anchor.isKind(of: ARPlaneAnchor.self) {
            DispatchQueue.main.async { [weak self] in
                guard let strongSelf = self else { return }
                guard let model = strongSelf.modelNodeModel else {
                    print("we have no model")
                    return
                }
                
                let modelClone = model.clone()
                modelClone.position = SCNVector3Zero
                
                node.addChildNode(modelClone)
                node.addChildNode(strongSelf.lightNodeModel!)
                node.addChildNode(strongSelf.planeNodeModel!)
                                
                strongSelf.addLightEstimate()
            }
        }
    }
    
    private func addLightEstimate() {
        sceneView.autoenablesDefaultLighting = false;
        
        let estimate: ARLightEstimate!
        estimate = self.sceneView.session.currentFrame?.lightEstimate
        
        let light: SCNLight!
        light = self.lightNodeModel?.light
        light.intensity = estimate.ambientIntensity
    }
}
