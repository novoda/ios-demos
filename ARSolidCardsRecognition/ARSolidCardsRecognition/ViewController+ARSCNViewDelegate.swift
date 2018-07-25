import ARKit
import UIKit

extension ViewController: ARSCNViewDelegate {

    func renderer(_ renderer: SCNSceneRenderer, didAdd node: SCNNode, for anchor: ARAnchor) {
        guard let imageAnchor = anchor as? ARImageAnchor else { return }
        let referenceImage = imageAnchor.referenceImage
        session.setWorldOrigin(relativeTransform: imageAnchor.transform)

        if labelView != nil {
            labelView = nil
        }

        let imageName = referenceImage.name ?? ""
        showStatusMessage("Detected image “\(imageName)”")

        DispatchQueue.main.async {
            guard let textNode = self.getNode(for: referenceImage) else {
                self.showStatusMessage("Could not create node")
                return
            }

            if let nodeExists = node.childNode(withName: textNode.name ?? "", recursively: true) {
                nodeExists.removeFromParentNode()
            }

            node.addChildNode(textNode)
        }
    }

    private func showStatusMessage(_ message: String) {
        DispatchQueue.main.async {
            self.statusViewController.cancelAllScheduledMessages()
            self.statusViewController.showMessage(message)
        }
    }

    private func getNode(for image: ARReferenceImage) -> SCNNode? {
        let label = UILabel()
        label.text = textForCard(imageName: image.name ?? "")
        label.textColor = .gray
        label.numberOfLines = 0
        label.adjustsFontSizeToFitWidth = true
        let imageLabel = UIImage.imageWithLabel(label: label)

        let frame = CGRect(x: 0, y: 0, width: image.physicalSize.width, height: image.physicalSize.height)
        labelView = UIView(frame: frame)
        labelView?.addSubview(label)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.topAnchor.constraint(equalTo: (labelView?.topAnchor)!).isActive = true
        label.leadingAnchor.constraint(equalTo: (labelView?.leadingAnchor)!).isActive = true
        label.trailingAnchor.constraint(equalTo: (labelView?.trailingAnchor)!).isActive = true
        label.bottomAnchor.constraint(equalTo: (labelView?.bottomAnchor)!).isActive = true

        let labelMaterial = SCNMaterial()
        labelMaterial.diffuse.contents = imageLabel

        let plane = SCNPlane(width: image.physicalSize.width, height: image.physicalSize.height)
        plane.firstMaterial?.diffuse.contents =  UIColor(white: 1, alpha: 0.8)
        plane.firstMaterial?.transparency = 0.5
        plane.materials = [labelMaterial]


        let node = SCNNode(geometry: plane)
        node.eulerAngles.x = -.pi / 2
        node.name = image.name
        return node
    }

    private func textForCard(imageName: String) -> String {
        switch imageName {
        case "SOLID-substitution-principle":
            return "Substitutability is a principle in object-oriented programming stating that," +
                "in a computer program, if S is a subtype of T, " +
                "then objects of type T may be replaced with objects of type S "
                + "without altering any of the desirable properties of the program"
        case "SOLID-open-close":
            return "The open/closed principle states software entities (classes, modules, functions, etc.) should be open for extension, but closed for modification"

        case "SOLID-dependency-injection":
            return "The interface-segregation principle states " +
                "that no client should be forced to depend on " +
            "methods it does not use"
        case "SOLID-single-responsibility":
            return "The single responsibility principle states that every module or class should have responsibility over a single part of the functionality provided by the software, and that responsibility should be entirely encapsulated by the class."
        case "SOLID-segregation":
            return "The dependency inversion principle states that High-level modules should not depend on low-level modules. Both should depend on abstractions and abstractions should not depend on details. Details should depend on abstractions."
        default:
            return ""
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

