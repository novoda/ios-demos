import UIKit
import ARKit
import SceneKit
import Vision

class RecognizeObjectsViewController: UIViewController {
    
    @IBOutlet weak var sceneView: ARSCNView!
    private let startButton = UIButton()
    private let arAsset = ARAsset.cubeWireframe
    private var arViewModel: ARViewModel!
    private let arSessionDelegate = ARExperimentSession()
    private var nodesForSession: [SCNNode]?
    private let recognizeObjectsViewModel = RecognizeObjectsViewModel()

    override func viewDidLoad() {
        super.viewDidLoad()

        arViewModel = ARViewModel(arAsset: arAsset)
        arSessionDelegate.sessionHandler = self
        sceneView.session.delegate = arSessionDelegate
        sceneView.delegate = self
        sceneView.showsStatistics = true
        sceneView.debugOptions = [ARSCNDebugOptions.showFeaturePoints]

        setupStartButton()
        recognizeObjectsViewModel.setUpVision()
        view.backgroundColor = .white
        styleNavigationBar(with: .white)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        let configuration = ARWorldTrackingConfiguration()
        configuration.planeDetection = .horizontal
        sceneView.session.run(configuration)
        recognizeObjectsViewModel.setCurrentFrameForModel(sceneView.frame)
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
        view.addSubview(startButton)
        
        startButton.translatesAutoresizingMaskIntoConstraints = false
        startButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        startButton.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        startButton.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.6).isActive = true
    }
    
    @objc private func startButtonHasBeenPressed(_ sender: UIButton) {
        guard let pixelBuffer = sceneView.session.currentFrame?.capturedImage else { return }
        startButton.isHidden = true
        DispatchQueue.global().async { [weak self] in
            self?.recognizeObjectsViewModel.predictUsingVision(pixelBuffer: pixelBuffer)
        }
    }

    private func showStartButtonIfError() {
        DispatchQueue.main.async { [weak self] in
            self?.startButton.isHidden = false
        }
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

