import Foundation
import ARKit

class NodeFactory {

    func node(for nodeType: NodeType, imageAnchor: ARImageAnchor) -> SCNNode? {
        switch nodeType {
        case .planeText:
            return planeTextNode(for: imageAnchor.referenceImage)
        case .model(let assetName, let assetPath):
            return modelNode(for: imageAnchor, with: assetName, assetPath: assetPath)
        case .imageGIF(let assetName):
            return imageGifNode(for: imageAnchor.referenceImage, assetName: assetName)
        case .image(let assetName):
            return imageNode(for: imageAnchor.referenceImage, assetName: assetName)
        default: return nil
        }
    }

    private func planeTextNode(for image: ARReferenceImage) -> SCNNode? {
        let nodeData = PlaneNodeData(name: image.name ?? "",
                                     text: textForCard(imageName: image.name ?? ""),
                                     frame: CGRect(x: 0, y: 0, width: image.physicalSize.width, height: image.physicalSize.height))
        let planeNode = PlaneTextNode(nodeData: nodeData)
        return SCNNode(geometry: planeNode)
    }

    private func modelNode(for imageAnchor: ARImageAnchor, with assetName: String, assetPath: String) -> SCNNode? {
        guard let scene = SCNScene(named: assetPath),
            let node = scene.rootNode.childNode(withName: assetName, recursively: true) else {
            return nil
        }

        // 2. Calculate size based on node's bounding box.
        let (min, max) = node.boundingBox
        let size = SCNVector3Make(max.x - min.x, max.y - min.y, max.z - min.z)
        // 3. Calculate the ratio of difference between real image and object size.
        // Ignore Y axis because it will be pointed out of the image.
        let widthRatio = Float(imageAnchor.referenceImage.physicalSize.width)/size.x
        let heightRatio = Float(imageAnchor.referenceImage.physicalSize.height)/size.z
        // Pick smallest value to be sure that object fits into the image.
        let finalRatio = [widthRatio, heightRatio].min() ?? 1

        node.transform = SCNMatrix4(imageAnchor.transform)
        node.scale = SCNVector3Make(size.x * finalRatio, size.y * finalRatio, size.z * finalRatio)
        return node
    }

    private func imageGifNode(for image: ARReferenceImage, assetName: String) -> SCNNode? {
        let layer = CALayer()
        layer.bounds = CGRect(x: 0,
                              y: 0,
                              width: image.physicalSize.width,
                              height: image.physicalSize.height)
        layer.contents = UIImage.gifImageWithName(assetName)

        let newMaterial = SCNMaterial()
        newMaterial.isDoubleSided = true
        newMaterial.diffuse.contents = layer

        // Create a plane to visualize the initial position of the detected image.
        let plane = SCNPlane(width: image.physicalSize.width,
                             height: image.physicalSize.height)
        plane.materials = [newMaterial]

        let node = SCNNode(geometry: plane)
        node.eulerAngles.x = -.pi / 2
        return node
    }

    private func imageNode(for image: ARReferenceImage, assetName: String) -> SCNNode? {

        let newMaterial = SCNMaterial()
        newMaterial.isDoubleSided = true
        newMaterial.diffuse.contents = UIImage(named: assetName)

        // Create a plane to visualize the initial position of the detected image.
        let plane = SCNPlane(width: image.physicalSize.width,
                             height: image.physicalSize.height)
        plane.materials = [newMaterial]

        let node = SCNNode(geometry: plane)
        node.eulerAngles.x = -.pi / 2
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

enum NodeType {
    case planeText
    case model(String, String)
    case text
    case imageGIF(String)
    case image(String)
}
