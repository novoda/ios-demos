import UIKit
import ARKit
import SceneKit
import Vision

class RecognizeObjectsViewController: UIViewController, ARSCNViewDelegate {

    @IBOutlet weak var sceneView: ARSCNView!
    fileprivate let yolo = YOLO()
    private let semaphore = DispatchSemaphore(value: 2)
    private var request: VNCoreMLRequest!
    private let startButton = UIButton()
    private let compoundingBox = UIView()
    private let predictionLabel = UILabel()
    private let arViewModel = ARViewModel()
    private let nodeName = "cubewireframe"
    private let fileName = "cubewireframe"
    private let fileExtension = "dae"
    private var pixelBufferWidth: Int = 0
    private var pixelBufferHeight: Int = 0

    override func viewDidLoad() {
        super.viewDidLoad()

        sceneView.delegate = self
        sceneView.showsStatistics = true
        sceneView.debugOptions = [ARSCNDebugOptions.showFeaturePoints, ARSCNDebugOptions.showWorldOrigin]

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
        pixelBufferWidth = CVPixelBufferGetWidth(pixelBuffer)
        pixelBufferHeight = CVPixelBufferGetHeight(pixelBuffer)
        // Vision will automatically resize the input image.
        let handler = VNImageRequestHandler(cvPixelBuffer: pixelBuffer)
        try? handler.perform([request])
    }

    private func setUpVision() {
        if #available(iOS 12.0, *) {
            guard let visionModel = try? VNCoreMLModel(for: ObjectDetector().model) else {
                print("Error: could not create Vision model")
                return
            }
            request = VNCoreMLRequest(model: visionModel, completionHandler: visionRequestDidComplete)
        } else {
            guard let visionModel = try? VNCoreMLModel(for: yolo.model.model) else {
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

        var objectName: String = ""
        var objectRect: CGRect = .zero

        if #available(iOS 12.0, *) {
            guard let observations = request.results as? [VNRecognizedObjectObservation],
                let topObservation = observations.first,
                let topLabelObservation = topObservation.labels.first else {
                    print("Vision failed finding prediction" )
                    showStartButtonIfError()
                    return
            }

            objectRect = VNImageRectForNormalizedRect(topObservation.boundingBox,
                                                      pixelBufferWidth,
                                                      pixelBufferHeight)
            objectName = topLabelObservation.identifier

        } else {
            guard let observations = request.results as? [VNCoreMLFeatureValueObservation],
                let topObservation = observations.first?.featureValue.multiArrayValue else {
                    print("Tiny YOLO failed finding prediction" )
                    showStartButtonIfError()
                    return
            }

            guard let prediction = predictionForTinyYOLO(topObservation: topObservation),
                let objectBounds = boundingBoxRectForTinyYOLO(prediction: prediction) else {
                    showStartButtonIfError()
                    print("Tiny YOLO failed finding top prediction" )
                    return
            }
            objectName = objectNameForTinyYOLO(prediction: prediction)
            objectRect = objectBounds
        }

        showOnMainThread(objectRect, objectName: objectName)
    }

    private func predictionForTinyYOLO(topObservation: MLMultiArray) -> YOLO.Prediction? {
        let boundingBoxes = yolo.computeBoundingBoxes(features: topObservation)
        let prominentBox = boundingBoxes.sorted{ $0.score > $1.score}
        return prominentBox.first
    }

    private func boundingBoxRectForTinyYOLO(prediction: YOLO.Prediction) -> CGRect? {
        let viewRect = CGRect(x: 0, y: 0, width: pixelBufferWidth, height: pixelBufferHeight)
        return yolo.scaleImageForCameraOutput(predictionRect: prediction.rect, viewRect: viewRect)
    }

    private func objectNameForTinyYOLO(prediction: YOLO.Prediction) -> String {
        return labels[prediction.classIndex]
    }

    //MARK: Prediction

    private func showOnMainThread(_ boundingBox: CGRect, objectName: String) {
        DispatchQueue.main.async { [weak self] in
            self?.show(boundingBox, objectName: objectName)
        }
    }

    private func show(_ boundingBox: CGRect, objectName: String) {
        guard let model = arViewModel.createSceneNodeForAsset(nodeName,
                                                              fileName: fileName,
                                                              assetExtension: fileExtension) else {
                                                                showStartButtonIfError()
                                                                print("we have no model")
                                                                return
        }
        let text = SCNText(string: objectName, extrusionDepth: 0.5)
        text.styleFirstMaterial(with: UIColor.blue)
        text.containerFrame = boundingBox
        let textNode = SCNNode(geometry: text)
        let node = SCNNode()
        node.addChildNode(textNode)
        node.addChildNode(model)
        

        let scaledPoint = CGPoint(x: boundingBox.origin.x, y: boundingBox.origin.y)
        guard let hitPoint = arViewModel.hitResult(at: scaledPoint, in: sceneView, withType: [.estimatedHorizontalPlane, .existingPlaneUsingExtent]) else {
            showStartButtonIfError()
            print("failed finding hit point")
            return
        }
        let pointTranslation = hitPoint.worldTransform.translation
        node.position = SCNVector3(pointTranslation.x, pointTranslation.y, pointTranslation.z)
        sceneView.scene.rootNode.addChildNode(node)
    }

    private func showStartButtonIfError() {
        DispatchQueue.main.async { [weak self] in
            self?.startButton.isHidden = false
        }
    }
}



