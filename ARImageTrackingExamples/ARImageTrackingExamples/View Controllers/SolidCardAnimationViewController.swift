import Foundation
import UIKit
import ARKit

class SolidCardAnimationViewController: UIViewController, ARExperimentSessionHandler {

    @IBOutlet var sceneView: ARSCNView!
    private let arSessionDelegate = ARExperimentSession()
    private let arViewModel = ARViewModel()

    override func viewDidLoad() {
        super.viewDidLoad()
        sceneView.delegate = self
        arSessionDelegate.sessionHandler = self
        sceneView.session.delegate = arSessionDelegate
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        let configuration = arViewModel.imageTrackingConfiguration()
        sceneView.session.run(configuration, options: [.removeExistingAnchors, .resetTracking])
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        sceneView.session.pause()
    }
}

extension SolidCardAnimationViewController: ARSCNViewDelegate {

    func renderer(_ renderer: SCNSceneRenderer, didAdd node: SCNNode, for anchor: ARAnchor) {
        guard let imageAnchor = anchor as? ARImageAnchor else {
            return
        }

        guard let image = arViewModel.image(correspondingTo: imageAnchor.referenceImage) else {
            print("could not find image")
            return
        }

        let mainNode = arViewModel.planeNode(with: nil,
                                             imageSize: imageAnchor.imageSize(),
                                             colorBufferWriteMask: .alpha)
        mainNode.eulerAngles.x = -.rightAngle
        mainNode.renderingOrder = .renderFirst

        let solidDataPlaneNode = cardNode(for: imageAnchor.imageSize(),
                                          withImage: image)
        mainNode.addChildNode(solidDataPlaneNode)
        webViewNode(for: imageAnchor.imageSize()) { webViewNode in
            if let webViewNode = webViewNode {
                 mainNode.addChildNode(webViewNode)
            }
        }
        node.addChildNode(mainNode)
    }

    private func cardNode(for size: CGSize, withImage image: UIImage) -> SCNNode {
        let cardSize = CGSize(width: size.width * .half,
                              height: size.height)
        let solidDataPlaneNode = arViewModel.planeNode(with: image,
                                                       imageSize: cardSize)
        solidDataPlaneNode.opacity = 0
        solidDataPlaneNode.position.z -= 0.01
        solidDataPlaneNode.animate(xOffset: -size.width * .third)
        return solidDataPlaneNode
    }

    private func webViewNode(for size: CGSize, onComplete: @escaping (SCNNode?) -> ()) {
        guard let url = URL(string: "https://blog.novoda.com/designing-something-solid/") else {
            print("invalid URL")
            return
        }
        let request = URLRequest(url: url)
        DispatchQueue.main.async { [weak self] in
            let webView = UIWebView(frame: CGRect(x: 0,
                                                  y: 0,
                                                  width: size.width * .half,
                                                  height: size.height))
            webView.loadRequest(request)
            let cardSize = CGSize(width: size.width * .half,
                                  height: size.height)
            let webViewNode = self?.arViewModel.planeNode(with: webView, imageSize: cardSize)
            if let plane = webViewNode?.geometry as? SCNPlane {
                plane.cornerRadius = 0.25
            }
            webViewNode?.position.z -= 0.01
            webViewNode?.opacity = 0
            webViewNode?.animate(xOffset: size.width * .third)
            onComplete(webViewNode)
        }
    }
}

extension SCNNode {
    func animate(xOffset: CGFloat) {
        self.runAction(SCNAction.sequence([
                .wait(duration: 0.5),
                .fadeOpacity(by: 1.0, duration: 1.5),
                .moveBy(x: xOffset, y: 0, z: 0, duration: 1.5),
                .moveBy(x: 0, y: 0, z: 0.01, duration: 0.2)
            ]))
    }
}
