import UIKit
import ARKit
import SceneKit
import Vision

class RecognizeObjectsViewController: UIViewController {

    @IBOutlet weak var sceneView: ARSCNView!
    fileprivate var nodeModel: SCNNode?
    fileprivate let yolo = YOLO()
    private let semaphore = DispatchSemaphore(value: 2)
    private var request: VNCoreMLRequest!
    private var touchPoint: float4x4?
    private let startButton = UIButton()
    private let compoundingBox = UIView()
    private let predictionLabel = UILabel()

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
        sceneView.debugOptions = [ARSCNDebugOptions.showFeaturePoints]

        nodeModel = createSceneNodeForAsset(nodeName, assetPath: "art.scnassets/\(fileName).\(fileExtension)")

        setupStartButton()
        setUpVision()
        setupCompoundingBox()
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
        guard let pixelBuffer = getCurrentFrame() else { return }
        startButton.isHidden = true
        semaphore.wait()
        DispatchQueue.global().async { [weak self] in
            self?.predictUsingVision(pixelBuffer: pixelBuffer)
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

    //MARK: ARKit functions

    private func createSceneNodeForAsset(_ assetName: String, assetPath: String) -> SCNNode? {
        guard let paperPlaneScene = SCNScene(named: assetPath) else {
            return nil
        }
        let carNode = paperPlaneScene.rootNode.childNode(withName: assetName, recursively: true)
        return carNode
    }

    private func getCurrentFrame() -> CVPixelBuffer? {
        let pixelBufferCameraCapture = (sceneView.session.currentFrame?.capturedImage)
        return pixelBufferCameraCapture
    }

     //MARK: CoreML Functions

    private func predictUsingVision(pixelBuffer: CVPixelBuffer) {
        // Vision will automatically resize the input image.
        let handler = VNImageRequestHandler(cvPixelBuffer: pixelBuffer)
        try? handler.perform([request])
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

    func visionRequestDidComplete(request: VNRequest, error: Error?) {
        if let observations = request.results as? [VNCoreMLFeatureValueObservation],
            let features = observations.first?.featureValue.multiArrayValue {

            let boundingBoxes = yolo.computeBoundingBoxes(features: features)
            print("bounding boxes \(boundingBoxes)")
            let prominentBox = boundingBoxes.sorted{ $0.score > $1.score}.first
            print("box: \(prominentBox)")
            self.semaphore.signal()
            showOnMainThread(prominentBox)
        }
    }

    func showOnMainThread(_ boundingBox: YOLO.Prediction?) {
        DispatchQueue.main.async { [weak self] in
            if let prominentBox = boundingBox {
                self?.show(prediction: prominentBox)
            } else {
                self?.startButton.isHidden = false
            }
        }
    }

    func show(prediction: YOLO.Prediction) {
        guard let scaledRect = scaleImageForCameraOutput(predictionRect: prediction.rect) else {
            print("could not scale the POint vectors")
            return
        }
        compoundingBox.frame = scaledRect
        predictionLabel.text = "\(labels[prediction.classIndex])"
        compoundingBox.isHidden = false

        let hitPoint = CGPoint(x: scaledRect.origin.x, y: scaledRect.origin.y)
        nodeModel?.boundingBox
        let hitResultsFeaturePoints: [ARHitTestResult] =
            sceneView.hitTest(hitPoint, types: .featurePoint)
        if let hit = hitResultsFeaturePoints.first {
            let anchor = ARAnchor(transform: hit.worldTransform)
            sceneView.session.add(anchor: anchor)
        }
    }

    //MARK: Processing Image

    private func scaleImageForCameraOutput(predictionRect: CGRect) -> CGRect? {
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


