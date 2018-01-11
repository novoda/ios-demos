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
import Vision

class RecognizeObjectsViewController: UIViewController {

    @IBOutlet weak var sceneView: ARSCNView!
    fileprivate var nodeModel: SCNNode?
    fileprivate let dispatchQueueML = DispatchQueue(label: "com.hw.dispatchqueueml") // A Serial Queue
    fileprivate let yolo = YOLO()
    fileprivate var boundingBox = BoundingBox()
    private let semaphore = DispatchSemaphore(value: 2)
    private var request: VNCoreMLRequest!
    private var touchPoint: float4x4?

    let labels = [
        "aeroplane", "bicDDycle", "bird", "boat", "bottle", "bus", "car", "cat",
        "chair", "cow", "diningtable", "dog", "horse", "motorbike", "person",
        "pottedplant", "sheep", "sofa", "train", "tvmonitor"
    ]

    //MARK: These strings is what you need to switch between different 3D objects
    /** NodeName is the name of the object you want to show, not necessarily the name of the file.
     - You can find the nodeName and change when opening the file on SceneKit Editor (click on the file or right click and use open as SceneKit Editor)
     - on the left bottom side of the corner there should be an icon called "Show the scene graph View" click on that, you will now see the hierarchy of the object, tap the object at the top you want to use
     - on the right top of xcode there should be a button called "Hide or show utilities" open the utilities using it
     - On the top of the utilities look for the cube icon called "Show the nodes inspector" and click on that
     - Under identity -> Name there should be a textField, that is the nodeName you need for here
     **/
    private let nodeName = "cubewireframe"
    private let fileName = "cubewireframe"
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
        setUpVision()
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

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let pixelBuffer = getCurrentFrame() else { return }
        self.touchPoint = getCoordinateFromTouchHitPoint(touch: touches.first)
        let arAnchorToTest = ARAnchor(transform: touchPoint ?? float4x4())
        print("touchPOint: \(arAnchorToTest)")
        semaphore.wait()
         DispatchQueue.global().async {
            self.predictUsingVision(pixelBuffer: pixelBuffer)
        }
    }

    func setUpVision() {
        guard let visionModel = try? VNCoreMLModel(for: yolo.model.model) else {
            print("Error: could not create Vision model")
            return
        }
        request = VNCoreMLRequest(model: visionModel, completionHandler: visionRequestDidComplete)

        // NOTE: If you choose another crop/scale option, then you must also
        // change how the BoundingBox objects get scaled when they are drawn.
        // Currently they assume the full input image is used.
        request.imageCropAndScaleOption = .scaleFill
    }


    private func predictUsingVision(pixelBuffer: CVPixelBuffer) {
        // Vision will automatically resize the input image.
        let handler = VNImageRequestHandler(cvPixelBuffer: pixelBuffer)
        try? handler.perform([request])
    }

    func visionRequestDidComplete(request: VNRequest, error: Error?) {
        if let observations = request.results as? [VNCoreMLFeatureValueObservation],
            let features = observations.first?.featureValue.multiArrayValue {

            let boundingBoxes = yolo.computeBoundingBoxes(features: features)
            let prominentBox = boundingBoxes.sorted{ $0.score > $1.score}.first
            self.semaphore.signal()
            if let prominentBox = prominentBox {
                showOnMainThread(prominentBox)
            }
        }
    }

    private func getCurrentFrame() -> CVPixelBuffer? {
        let pixelBufferCameraCapture = (sceneView.session.currentFrame?.capturedImage)
        return pixelBufferCameraCapture
    }

    func showOnMainThread(_ boundingBox: YOLO.Prediction) {
        DispatchQueue.main.async {
            self.show(prediction: boundingBox)
        }
    }

    func show(prediction: YOLO.Prediction) {
        let scaledRect = scaleImageForCameraOutput(predictionRect: prediction.rect)
        print("prediction: \(prediction.score)  \(labels[prediction.classIndex]) \(prediction.rect)")
        let anchor = ARAnchor(transform: scaledRect ?? float4x4())
        print("anchor \(anchor)")
        sceneView.session.add(anchor: anchor)
        matrix_identity_float4x4
    }

    /**
     var translation = matrix_identity_float4x4
     translation.columns.3.z = -0.3
     let transform = simd_mul(currentFrame.camera.transform, translation)

     let anchor = ARAnchor(transform: transform)
     sceneView.session.add(anchor: anchor)
     anchors.append(anchor)

 **/


    //MARK: Processing Image

    private func scaleImageForCameraOutput(predictionRect: CGRect) -> float4x4? {
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

        touchPoint?.columns.3.x = Float(scaleRect.origin.x)
        touchPoint?.columns.3.y = Float(scaleRect.origin.y)
        touchPoint?.columns.3.w = Float(scaleRect.width)
        touchPoint?.columns.3.z = Float(scaleRect.height)

        return touchPoint
    }

    private func getCoordinateFromTouchHitPoint(touch: UITouch?) -> float4x4? {
        guard let touch = touch else { return nil}
        let location = touch.location(in: sceneView)
        let hitResultsFeaturePoints: [ARHitTestResult] =
            sceneView.hitTest(location, types: .featurePoint)
        return hitResultsFeaturePoints.first?.worldTransform
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


