import UIKit
import ARKit
import SceneKit
import Vision

class RecognizeObjectsViewController: UIViewController, ARSCNViewDelegate, ARExperimentSessionHandler {
    
    @IBOutlet weak var sceneView: ARSCNView!
    fileprivate let yolo = YOLO()
    private let semaphore = DispatchSemaphore(value: 2)
    private var request: VNCoreMLRequest!
    private let startButton = UIButton()
    private var objectName = ""
    private let arViewModel = ARViewModel()
    private let nodeName = "cubewireframe"
    private let fileName = "cubewireframe"
    private let fileExtension = "dae"
    private var viewSizeForScale: CGRect = .zero
    private var boundingBoxSize: CGSize = .zero
    private let usingAnchors = true
    private var usingTinyModel = false
    private let arSessionDelegate = ARExperimentSession()

    override func viewDidLoad() {
        super.viewDidLoad()
        
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
        viewSizeForScale = sceneView.frame
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
        var objectRect: CGRect = .zero

        if usingTinyModel {
            let (predictionRect, predictionName) = processPredictionFromTinyYolo(results: request.results)
            objectName = predictionName
            objectRect = predictionRect ?? .zero
        } else {
            let (predictionRect, predictionName) = processPredictionFromVision(results: request.results)
            objectName = predictionName
            objectRect = predictionRect ?? .zero
        }
        addBoxOnMainThread(objectRect)

    }

    private func processPredictionFromTinyYolo(results: [Any]?) -> (CGRect?, String) {
        guard let observations = results as? [VNCoreMLFeatureValueObservation],
            let topObservation = observations.first?.featureValue.multiArrayValue else {
                print("Tiny YOLO failed finding prediction" )
                showStartButtonIfError()
                return (nil, "")
        }

        guard let prediction = predictionForTinyYOLO(topObservation: topObservation),
            let objectBounds = boundingBoxRectForTinyYOLO(prediction: prediction) else {
                showStartButtonIfError()
                print("Tiny YOLO failed finding top prediction" )
                return (nil, "")
        }
        return (objectBounds, objectNameForTinyYOLO(prediction: prediction))
    }

    private func processPredictionFromVision(results: [Any]?) -> (CGRect?, String) {
        guard #available(iOS 12.0, *) else {
            usingTinyModel = true
           return (nil, "")
        }
        guard let observations = results as? [VNRecognizedObjectObservation],
            let topObservation = observations.first,
            let topLabelObservation = topObservation.labels.first else {
                print("Vision failed finding prediction" )
                showStartButtonIfError()
                return (nil, "")
        }
        let objectRect = VNImageRectForNormalizedRect(topObservation.boundingBox,
                                                  Int(viewSizeForScale.width),
                                                  Int(viewSizeForScale.height))
        return (objectRect, topLabelObservation.identifier)
    }

    private func predictionForTinyYOLO(topObservation: MLMultiArray) -> YOLO.Prediction? {
        let boundingBoxes = yolo.computeBoundingBoxes(features: topObservation)
        let prominentBox = boundingBoxes.sorted{ $0.score > $1.score}
        return prominentBox.first
    }

    private func boundingBoxRectForTinyYOLO(prediction: YOLO.Prediction) -> CGRect? {
        let viewRect = CGRect(x: 0, y: 0, width: Int(viewSizeForScale.width), height: Int(viewSizeForScale.height))
        return yolo.scaleImageForCameraOutput(predictionRect: prediction.rect, viewRect: viewRect)
    }

    private func objectNameForTinyYOLO(prediction: YOLO.Prediction) -> String {
        return labels[prediction.classIndex]
    }

    //MARK: Add Model to the scene

    private func addBoxOnMainThread(_ boundingBox: CGRect) {
        guard let hitPoint = findHitPointFor(boundingBox) else {
            showStartButtonIfError()
            print("failed finding hit point")
            return
        }
        DispatchQueue.main.async { [weak self] in
            if self?.usingAnchors ?? false {
                self?.addAnchorToScene(in: hitPoint, withSize: boundingBox)
            } else {
                self?.addVectorToScene(in: hitPoint, withSize: boundingBox)
            }
        }
    }

    private func findHitPointFor(_ boundingBox: CGRect) -> ARHitTestResult? {
        let scaledPoint = CGPoint(x: boundingBox.origin.x, y: boundingBox.origin.y)
        boundingBoxSize = CGSize(width: boundingBox.width, height: boundingBox.height)
        return arViewModel.hitResult(at: scaledPoint, in: sceneView, withType: [.featurePoint, .estimatedHorizontalPlane])
    }

    private func addAnchorToScene(in hitPoint: ARHitTestResult, withSize boundingBox: CGRect) {
        let anchor = ARAnchor(transform: hitPoint.localTransform)
        sceneView.session.add(anchor: anchor)
    }

    private func addVectorToScene(in hitPoint: ARHitTestResult, withSize boundingBox: CGRect) {
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
        guard let model = arViewModel.createSceneNodeForAsset(nodeName,
                                                              fileName: fileName,
                                                              assetExtension: fileExtension) else {
                                                                showStartButtonIfError()
                                                                print("we have no model")
                                                                return nil
        }
        let parentNode = SCNNode()
        let text = SCNText(string: objectName, extrusionDepth: 0.5)
        text.styleFirstMaterial(with: UIColor.blue)
        let textNode = SCNNode(geometry: text)
        textNode.scale = SCNVector3(textNode.scale.x * 0.01 ,
                                    textNode.scale.y * 0.01 ,
                                    textNode.scale.z * 0.01)
        let modelWidth = model.boundingBox.max.x - model.boundingBox.min.x
        let modelHeight = model.boundingBox.max.y - model.boundingBox.min.y
        let widthScale = Float(boundingBoxSize.width) / modelWidth
        let heightScale = Float(boundingBoxSize.height) / modelHeight
        model.scale = SCNVector3(model.scale.x * widthScale,
                                 model.scale.y * heightScale,
                                 model.scale.z)
        parentNode.addChildNode(model)
        parentNode.addChildNode(textNode)
        return parentNode
    }
}


extension RecognizeObjectsViewController: ARSCNViewDelegate {
    func renderer(_ renderer: SCNSceneRenderer, nodeFor anchor: ARAnchor) -> SCNNode? {
        guard !anchor.isKind(of: ARPlaneAnchor.self) && usingAnchors else {
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
