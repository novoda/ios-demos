import ARKit
import UIKit

extension ViewController: ARSCNViewDelegate {

    func renderer(_ renderer: SCNSceneRenderer, didAdd node: SCNNode, for anchor: ARAnchor) {
        guard let imageAnchor = anchor as? ARImageAnchor else { return }
        let referenceImage = imageAnchor.referenceImage
        session.setWorldOrigin(relativeTransform: imageAnchor.transform)

        let imageName = referenceImage.name ?? ""
        showStatusMessage("Detected image “\(imageName)”")

        let imageGif: NodeType = .imageGIF("fionaSleep")
        let image: NodeType = .image("fiona")
        let model: NodeType = .model("art.scnassets/Banana/banana-small.dae", "banana")

        DispatchQueue.main.async {
            let nodeFactory = NodeFactory()
            guard let node = nodeFactory.node(for: image, imageAnchor: imageAnchor) else {
                self.showStatusMessage("Could not create node")
                return
            }

            if let nodeExists = node.childNode(withName: node.name ?? "", recursively: true) {
                nodeExists.removeFromParentNode()
            }

            node.addChildNode(node)
        }
    }

    private func showStatusMessage(_ message: String) {
        DispatchQueue.main.async {
            self.statusViewController.cancelAllScheduledMessages()
            self.statusViewController.showMessage(message)
        }
    }
}

extension UIImage {
    static func imageWithLabel(label: UILabel) -> UIImage? {
        UIGraphicsBeginImageContextWithOptions(label.bounds.size, false, 0.0)
        guard let context = UIGraphicsGetCurrentContext() else {
            return nil
        }
        label.layer.render(in: context)
        let img = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return img
    }
}

