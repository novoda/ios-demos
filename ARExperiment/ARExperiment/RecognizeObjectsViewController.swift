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
    private let arAsset = ARAsset.cubeWireframe
    private var arViewModel: ARViewModel!
    private var currentSceneFrame: CGRect = .zero
    private let arSessionDelegate = ARExperimentSession()
    private var nodesForSession: [SCNNode]?
    private var prediction: ObjectPrediction?

    override func viewDidLoad() {
        super.viewDidLoad()

        arViewModel = ARViewModel(arAsset: arAsset)
        arSessionDelegate.sessionHandler = self
        sceneView.session.delegate = arSessionDelegate
        sceneView.delegate = self
        sceneView.showsStatistics = true
        sceneView.debugOptions = [ARSCNDebugOptions.showFeaturePoints]

        setupStartButton()
        setUpVision()
        self.view.backgroundColor = .white
        styleNavigationBar(with: .white)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        let configuration = ARWorldTrackingConfiguration()
        configuration.planeDetection = .horizontal
        sceneView.session.run(configuration)
        currentSceneFrame = sceneView.frame
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
        }
    }

    private func showStartButtonIfError() {
        DispatchQueue.main.async { [weak self] in
            self?.startButton.isHidden = false
        }
    }
    
    //MARK: Vision Prediction
    private func predictUsingVision(pixelBuffer: CVPixelBuffer) {
        // Vision will automatically resize the input image.
        let handler = VNImageRequestHandler(cvPixelBuffer: pixelBuffer)
        try? handler.perform([request])
    }
    
    private func setUpVision() {
        if usingTinyModel {
            guard let visionModel = try? VNCoreMLModel(for: yolo.model.model) else {
                print("Error: could not create Vision model")
                return
            }
            request = VNCoreMLRequest(model: visionModel, completionHandler: visionRequestDidComplete)
        } else {
            guard #available(iOS 12.0, *) else {
                usingTinyModel = true
                setUpVision()
                return
            }
            guard let visionModel = try? VNCoreMLModel(for: ObjectDetector().model) else {
                print("Error: could not create Vision model")
                return
            }
            request = VNCoreMLRequest(model: visionModel, completionHandler: visionRequestDidComplete)
        }

        // NOTE: If you choose another crop/scale option, then you must also
        // change how the BoundingBox objects get scaled when they are drawn.
        // Currently they assume the full input image is used.
        request.imageCropAndScaleOption = .scaleFill
    }
    
    func visionRequestDidComplete(request: VNRequest, error: Error?) {
        self.semaphore.signal()

        if usingTinyModel {
            prediction = processPredictionFromTinyYolo(results: request.results)
        } else {
            prediction = processPredictionFromVision(results: request.results)
        }
        addBoxOnMainThread(prediction)
    }

    private func processPredictionFromTinyYolo(results: [Any]?) -> ObjectPrediction? {
        guard let observations = results as? [VNCoreMLFeatureValueObservation],
            let topObservation = observations.first?.featureValue.multiArrayValue else {
                print("Tiny YOLO failed finding prediction" )
                showStartButtonIfError()
                return nil
        }

        guard let prediction = predictionForTinyYOLO(topObservation: topObservation),
            let objectBounds = boundingBoxRectForTinyYOLO(prediction: prediction) else {
                showStartButtonIfError()
                print("Tiny YOLO failed finding top prediction" )
                return nil
        }
        return ObjectPrediction(name: objectNameForTinyYOLO(prediction: prediction), bounds: objectBounds)
    }

    private func processPredictionFromVision(results: [Any]?) -> ObjectPrediction? {
        guard #available(iOS 12.0, *) else {
            usingTinyModel = true
            return nil
        }
        guard let observations = results as? [VNRecognizedObjectObservation],
            let topObservation = observations.first,
            let topLabelObservation = topObservation.labels.first else {
                print("Vision failed finding prediction" )
                showStartButtonIfError()
                return nil
        }
        let objectRect = VNImageRectForNormalizedRect(topObservation.boundingBox,
                                                      Int(currentSceneFrame.width),
                                                      Int(currentSceneFrame.height))
        return ObjectPrediction(name: topLabelObservation.identifier, bounds: objectRect)
    }

    private func predictionForTinyYOLO(topObservation: MLMultiArray) -> YOLO.Prediction? {
        let boundingBoxes = yolo.computeBoundingBoxes(features: topObservation)
        let prominentBox = boundingBoxes.sorted{ $0.score > $1.score}
        return prominentBox.first
    }

    private func boundingBoxRectForTinyYOLO(prediction: YOLO.Prediction) -> CGRect? {
        let viewRect = CGRect(x: 0, y: 0, width: Int(currentSceneFrame.width), height: Int(currentSceneFrame.height))
        return yolo.scaleImageForCameraOutput(predictionRect: prediction.rect, viewRect: viewRect)
    }

    private func objectNameForTinyYOLO(prediction: YOLO.Prediction) -> String {
        return labels[prediction.classIndex]
    }

    //MARK: Add Model to the scene

    private func addBoxOnMainThread(_ prediction: ObjectPrediction?) {
        guard let prediction = prediction,
            let hitPoint = findHitPointFor(prediction.bounds) else {
                showStartButtonIfError()
                print("failed finding hit point or prediction")
                return
        }
        DispatchQueue.main.async { [weak self] in
            guard let strongSelf = self else {
                return
            }
            if DeveloperOptions.usingAnchors.isActive {
                strongSelf.addAnchorToScene(in: hitPoint)
            } else {
                strongSelf.addVectorToScene(in: hitPoint, withPrediction: prediction)
            }
        }
    }

    private func findHitPointFor(_ boundingBox: CGRect) -> ARHitTestResult? {
        let scaledPoint = CGPoint(x: boundingBox.origin.x, y: boundingBox.origin.y)
        return arViewModel.hitResult(at: scaledPoint, in: sceneView, withType: [.featurePoint, .estimatedHorizontalPlane])
    }

    private func addAnchorToScene(in hitPoint: ARHitTestResult) {
        let anchor = ARAnchor(transform: hitPoint.localTransform)
        sceneView.session.add(anchor: anchor)
    }

    private func addVectorToScene(in hitPoint: ARHitTestResult, withPrediction prediction: ObjectPrediction) {
        let pointTranslation = hitPoint.worldTransform.translation
        guard let node = nodeForTextAndSize() else {
            showStartButtonIfError()
            print("we have no model")
            return
        }
        node.position = SCNVector3(pointTranslation.x, pointTranslation.y, pointTranslation.z)
        sceneView.scene.rootNode.addChildNode(node)
    }

    private func nodeForTextAndSize() -> SCNNode? {
        guard let nodesForSession = nodesForSession else {
            print("we have no model")
            return nil
        }

        let parentNode = SCNNode()
        for node in nodesForSession {
            parentNode.addChildNode(node)
        }

        return parentNode
    }
}


extension RecognizeObjectsViewController: ARSCNViewDelegate {
    func renderer(_ renderer: SCNSceneRenderer, nodeFor anchor: ARAnchor) -> SCNNode? {
        guard !anchor.isKind(of: ARPlaneAnchor.self) && DeveloperOptions.usingAnchors.isActive else {
            return nil
        }
        guard let model = nodeForTextAndSize() else {
            showStartButtonIfError()
            print("we have no model")
            return nil
        }
        return model
    }
}

extension RecognizeObjectsViewController: ARExperimentSessionHandler {
    func sessionTrackingSwitchedToNormal() {
        if let lightEstimate = sceneView.session.currentFrame?.lightEstimate {
            nodesForSession = arViewModel.nodesForARExperience(using: lightEstimate)
        }
    }
}

