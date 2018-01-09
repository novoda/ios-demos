//
//  ViewController.swift
//  ARExperiment
//
//  Created by Berta Devant on 02/01/2018.
//  Copyright © 2018 Berta Devant. All rights reserved.
//

import UIKit
import SceneKit
import ARKit

class OneSceneViewController: UIViewController {

    @IBOutlet var sceneView: ARSCNView!
    fileprivate var nodeModel: SCNNode?
    //MARK: These strings is what you need to switch between different 3D objects
    /** NodeName is the name of the object you want to show, not necessarily the name of the file.
        - You can find the nodeName and change when opening the file on SceneKit Editor (click on the file or right click and use open as SceneKit Editor)
        - on the left bottom side of the corner there should be an icon called "Show the scene graph View" click on that, you will now see the hierarchy of the object, tap the object at the top you want to use
        - on the right top of xcode there should be a button called "Hide or show utilities" open the utilities using it
        - On the top of the utilities look for the cube icon called "Show the nodes inspector" and click on that
        - Under identity -> Name there should be a textField, that is the nodeName you need for here
     **/
    private let nodeName = "icecream"
    private let fileName = "icecream"
    private let fileExtension = "dae"

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set the view's delegate
        sceneView.delegate = self
        
        // Show statistics such as fps and timing information
        sceneView.showsStatistics = true
        sceneView.debugOptions = [ARSCNDebugOptions.showFeaturePoints, ARSCNDebugOptions.showWorldOrigin]

        nodeModel = createSceneNodeForAsset(nodeName, assetPath: "art.scnassets/\(fileName).\(fileExtension)")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // Create a session configuration
        let configuration = ARWorldTrackingConfiguration()
        // Run the view's session
        sceneView.session.run(configuration)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        // Pause the view's session
        sceneView.session.pause()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Release any cached data, images, etc that aren't in use.
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

        if let nodeExists = sceneView.scene.rootNode.childNode(withName: nodeName, recursively: true) {
            nodeExists.removeFromParentNode()
        }
        
        let hitResultsFeaturePoints: [ARHitTestResult] =
            sceneView.hitTest(location, types: .featurePoint)

        if let hit = hitResultsFeaturePoints.first {
            let anchor = ARAnchor(transform: hit.worldTransform)
            print("anchor \(anchor)")
            sceneView.session.add(anchor: anchor)
        }
    }
}

extension OneSceneViewController: ARSCNViewDelegate {

    func renderer(_ renderer: SCNSceneRenderer, didAdd node: SCNNode, for anchor: ARAnchor) {
        if !anchor.isKind(of: ARPlaneAnchor.self) {
            DispatchQueue.main.async {
                guard let model = self.nodeModel else {
                    print("we have no model")
                    return
                }
                let modelClone = model.clone()
                modelClone.position = SCNVector3Zero
                // Add model as a child of the node
                node.addChildNode(modelClone)
            }
        }
    }
}

extension float4x4 {
    var translation: float3 {
        let translation = self.columns.3
        return float3(translation.x, translation.y, translation.z)
    }
}
