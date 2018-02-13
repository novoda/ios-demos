import UIKit
import ARKit
import SceneKit
import Vision

class RecognizeObjectsViewController: UIViewController {

    @IBOutlet weak var sceneView: ARSCNView!
    fileprivate let yolo = YOLO()
    private let semaphore = DispatchSemaphore(value: 2)
    private var request: VNCoreMLRequest!
    private let startButton = UIButton()
    private let compoundingBox = UIView()
    private let predictionLabel = UILabel()
    private let arViewModel = ARViewModel()

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

        sceneView.delegate = self
        sceneView.showsStatistics = true
        sceneView.debugOptions = [ARSCNDebugOptions.showFeaturePoints]

        setupStartButton()
        setUpVision()
        setupCompoundingBox()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        let configuration = ARWorldTrackingConfiguration()
        configuration.planeDetection = .horizontal
        sceneView.session.run(configuration)
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)

        sceneView.session.pause()
    }

    private func setupStartButton() {
        startButton.setTitle("Start", for: .normal)
        startButton.setTitleColor(.black, for: .normal)
        startButton.backgroundColor = .white
        startButton.alpha = 0.85
        startButton.addTarget(self, action: #selector(startButtonHasBeenPressed), for: .touchUpInside)
        self.view.addSubview(startButton)

        startButton.translatesAutoresizingMaskIntoConstraints = false
        startButton.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        startButton.centerYAnchor.constraint(equalTo: self.view.centerYAnchor).isActive = true
        startButton.widthAnchor.constraint(equalTo: self.view.widthAnchor, multiplier: 0.6).isActive = true
    }

    @objc private func startButtonHasBeenPressed(_ sender: UIButton) {
        guard let pixelBuffer = sceneView.session.currentFrame?.capturedImage else { return }
        startButton.isHidden = true
        semaphore.wait()
        DispatchQueue.global().async { [weak self] in
            self?.predictUsingVision(pixelBuffer: pixelBuffer)
//            self?.predictUsingCoreML(pixelBuffer: pixelBuffer)
        }
    }

    private func setupCompoundingBox() {
        predictionLabel.textColor = .gray
        compoundingBox.isHidden = true

        compoundingBox.addSubview(predictionLabel)
        view.addSubview(compoundingBox)

        predictionLabel.translatesAutoresizingMaskIntoConstraints = false
        predictionLabel.trailingAnchor.constraint(equalTo: compoundingBox.trailingAnchor).isActive = true
        predictionLabel.topAnchor.constraint(equalTo: compoundingBox.topAnchor).isActive = true
    }

    //MARK: Vision Prediction
    private func predictUsingVision(pixelBuffer: CVPixelBuffer) {
        // Vision will automatically resize the input image.
        let handler = VNImageRequestHandler(cvPixelBuffer: pixelBuffer)
        try? handler.perform([request])
    }

    private func setUpVision() {
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

    func visionRequestDidComplete(request: VNRequest, error: Error?) {
        if let observations = request.results as? [VNCoreMLFeatureValueObservation],
            let features = observations.first?.featureValue.multiArrayValue {

            let boundingBoxes = yolo.computeBoundingBoxes(features: features)
            showOnMainThread(boundingBoxes)
        }
    }

    //MARK: CoreML Functions

    private func predictUsingCoreML(pixelBuffer: CVPixelBuffer) {
        guard let resizedImage = yolo.scaleImageForPredictionInput(pixelBufferImage: pixelBuffer) else {
            return
        }
        guard let boundingBoxes = try? yolo.predict(image: resizedImage) else {
            return
        }
        showOnMainThread(boundingBoxes)
    }


    //MARK: Prediction

    private func showOnMainThread(_ boundingBoxes: [YOLO.Prediction]) {
        let prominentBox = boundingBoxes.sorted{ $0.score > $1.score}.first
        self.semaphore.signal()
        print("boxes: \(boundingBoxes)")

        DispatchQueue.main.async { [weak self] in
            if let prominentBox = prominentBox {
                self?.show(prediction: prominentBox)
            } else {
                self?.startButton.isHidden = false
            }
        }
    }

    private func show(prediction: YOLO.Prediction) {
        guard let scaledRect = yolo.scaleImageForCameraOutput(predictionRect: prediction.rect, viewRect: self.view.bounds) else {
            print("could not scale the Point vectors")
            return
        }

        guard let model = arViewModel.createSceneNodeForAsset(nodeName, assetPath: "art.scnassets/\(fileName).\(fileExtension)") else {
            print("we have no model")
            return
        }

        compoundingBox.frame = scaledRect
        predictionLabel.text = "\(labels[prediction.classIndex])"
        compoundingBox.isHidden = false

        let scaledPoint = CGPoint(x: scaledRect.origin.x, y: scaledRect.origin.y)
        if let hitPoint = arViewModel.getHitResults(location: scaledPoint, sceneView: sceneView) {
            print("scaledRect \(scaledRect)")
            let pointTranslation = hitPoint.worldTransform.translation
            print("pointTranslation \(pointTranslation)")
            model.position = SCNVector3(pointTranslation.x, pointTranslation.y, pointTranslation.z)
            sceneView.scene.rootNode.addChildNode(model)

        }
    }
}

extension RecognizeObjectsViewController: ARSCNViewDelegate {

//    func renderer(_ renderer: SCNSceneRenderer, nodeFor anchor: ARAnchor) -> SCNNode? {
//        if !anchor.isKind(of: ARPlaneAnchor.self) {
//            guard let model = arViewModel.createSceneNodeForAsset(nodeName, assetPath: "art.scnassets/\(fileName).\(fileExtension)") else {
//                print("we have no model")
//                return nil
//            }
//            print("anchor: \(anchor.transform.translation)")
//            model.position = SCNVector3Zero
//            return model
//        }
//        return nil
//    }

//    func renderer(_ renderer: SCNSceneRenderer, didAdd node: SCNNode, for anchor: ARAnchor) {
//        if !anchor.isKind(of: ARPlaneAnchor.self) {
//            DispatchQueue.main.async {
//                guard let model = self.nodeModel else {
//                    print("we have no model")
//                    return
//                }
//                let modelClone = model.clone()
//                modelClone.position = SCNVector3Zero
//                // Add model as a child of the node
//                node.addChildNode(modelClone)
//            }
//        }
//    }
}



