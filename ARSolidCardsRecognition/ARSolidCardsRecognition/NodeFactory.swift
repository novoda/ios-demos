import Foundation
import ARKit

class NodeFactory {

    func node(for nodeType: NodeType, image: ARReferenceImage) -> SCNNode? {
        switch nodeType {
        case .planeText:
            return planeTextNode(for: image)
        case .model:
        case.text:
        case .imageGIF:
        case .image:
        }
    }

    private func planeTextNode(for image: ARReferenceImage) -> SCNNode? {
        let nodeData = PlaneNodeData(name: image.name ?? "",
                                     text: textForCard(imageName: image.name ?? ""),
                                     frame: CGRect(x: 0, y: 0, width: image.physicalSize.width, height: image.physicalSize.height))
        let planeNode = PlaneTextNode(nodeData: nodeData)
        return SCNNode(geometry: planeNode)
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
    case model
    case text
    case imageGIF
    case image
}
