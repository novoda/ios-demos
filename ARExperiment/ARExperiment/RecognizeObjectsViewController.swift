//
//  RecognizeObjectsViewController.swift
//  ARExperiment
//
//  Created by Berta Devant on 09/01/2018.
//  Copyright © 2018 Berta Devant. All rights reserved.
//

import UIKit
import ARKit
import SceneKit

class RecognizeObjectsViewController: UIViewController {

    @IBOutlet weak var sceneView: ARSCNView!
    fileprivate var nodeModel: SCNNode?
    fileprivate let dispatchQueueML = DispatchQueue(label: "com.hw.dispatchqueueml") // A Serial Queue
    fileprivate let yolo = YOLO()
    fileprivate var boundingBox = BoundingBox()

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

        // Begin Loop to Update CoreML
        loopCoreMLUpdate()
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
        // Dispose of any resources that can be recreated.
    }

    //MARK: ARKit functions

    private func createSceneNodeForAsset(_ assetName: String, assetPath: String) -> SCNNode? {
        guard let paperPlaneScene = SCNScene(named: assetPath) else {
            return nil
        }
        let carNode = paperPlaneScene.rootNode.childNode(withName: assetName, recursively: true)
        return carNode
    }

    //MARK: Core ML Yolo functions
    private func loopCoreMLUpdate() {
        dispatchQueueML.async { [weak self] in
            guard let strongSelf = self else {
                return
            }
            strongSelf.getCoreMLPredictions()
            strongSelf.loopCoreMLUpdate()
        }
    }

    private func getCoreMLPredictions() {
        guard let pixelBufferCamerCapture : CVPixelBuffer = (sceneView.session.currentFrame?.capturedImage) else {
            return
        }
        if let predictions = try? yolo.predict(image: pixelBufferCamerCapture) {
            if let boundingBox = predictions.first {
                showOnMainThread(boundingBox)
            }
        }
    }

    func showOnMainThread(_ boundingBox: YOLO.Prediction) {
        DispatchQueue.main.async {
            self.show(prediction: boundingBox)
        }
    }

    func show(prediction: YOLO.Prediction) {
        boundingBox.show(frame: prediction.rect, label: "", color: .blue)
    }
}

extension RecognizeObjectsViewController: ARSCNViewDelegate {

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
