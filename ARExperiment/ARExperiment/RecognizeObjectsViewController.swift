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
    private let arSessionDelegate = ARExperimentSession()

    override func viewDidLoad() {
        super.viewDidLoad()

        arSessionDelegate.sessionHandler = self
        sceneView.session.delegate = arSessionDelegate
        sceneView.delegate = self
        sceneView.showsStatistics = true
        sceneView.debugOptions = [ARSCNDebugOptions.showFeaturePoints, ARSCNDebugOptions.showWorldOrigin]

        setupStartButton()
        setUpVision()
        setupCompoundingBox()
        setViewBackgroundColor(to: .white)
        styleNavigationBar(with: .white)
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

        guard let model = arViewModel.createSceneNodeForAsset(nodeName,
                                                              fileName: fileName,
                                                              assetExtension: fileExtension) else {
            print("we have no model")
            return
        }

        compoundingBox.frame = scaledRect
        predictionLabel.text = "\(labels[prediction.classIndex])"
        compoundingBox.isHidden = false

        let scaledPoint = CGPoint(x: scaledRect.origin.x, y: scaledRect.origin.y)
        if let hitPoint = arViewModel.hitResult(at: scaledPoint, in: sceneView, withType: [.existingPlaneUsingExtent, .estimatedHorizontalPlane]) {
            let pointTranslation = hitPoint.worldTransform.translation
            model.position = SCNVector3(pointTranslation.x, pointTranslation.y, pointTranslation.z)
            sceneView.scene.rootNode.addChildNode(model)

        }
    }
}

extension RecognizeObjectsViewController: ARExperimentSessionHandler {
    var stateDescription: String {
        get {
            return title ?? "\(type(of: self))"
        }
        set {
            title = newValue
        }
    }
}
