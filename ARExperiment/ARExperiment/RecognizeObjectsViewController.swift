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
        let scalePixelBufferCameraCapture = scaleImageForModel(pixelBuffer: pixelBufferCamerCapture)
        if let predictions = try? yolo.predict(image: scalePixelBufferCameraCapture) {
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
        let scaledRect = scaleImageForCameraOutput(predictionRect: prediction.rect)
        boundingBox.show(frame: scaledRect, label: "", color: .blue)
    }


    //MARK: Processing Image

    private func scaleImageForModel(pixelBuffer: CVPixelBuffer) -> CVPixelBuffer {
        let copyToRender = pixelBuffer
        let ciImage = CIImage(cvPixelBuffer: pixelBuffer)
        let scaleX = CGFloat(YOLO.inputWidth) / CGFloat(CVPixelBufferGetWidth(pixelBuffer))
        let scaleY = CGFloat(YOLO.inputHeight) / CGFloat(CVPixelBufferGetHeight(pixelBuffer))
        let scaleTransform = CGAffineTransform(scaleX: scaleX, y: scaleY)
        let scaledImage = ciImage.transformed(by: scaleTransform)

        CIContext().render(scaledImage, to: copyToRender)
        return copyToRender
    }

    private func scaleImageForCameraOutput(predictionRect: CGRect) -> CGRect {
        // The predicted bounding box is in the coordinate space of the input
        // image, which is a square image of 416x416 pixels. We want to show it
        // on the video preview, which is as wide as the screen and has a 4:3
        // aspect ratio. The video preview also may be letterboxed at the top
        // and bottom.
        let width = view.bounds.width
        let height = width * 4 / 3
        let scaleX = width / CGFloat(YOLO.inputWidth)
        let scaleY = height / CGFloat(YOLO.inputHeight)
        let top = (view.bounds.height - height) / 2

        // Translate and scale the rectangle to our own coordinate system.
        var scaleRect = predictionRect
        scaleRect.origin.x *= scaleX
        scaleRect.origin.y *= scaleY
        scaleRect.origin.y += top
        scaleRect.size.width *= scaleX
        scaleRect.size.height *= scaleY

        return scaleRect
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
