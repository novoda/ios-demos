import Foundation

struct Models {
    let fileName: String
    let fileExtension: String
    let nodes: [Node]
}

struct Node {
    let name: String
    let nodeType: NodeType
}

enum NodeType {
    case light
    case plane
    case object
}

class ObjectModel {

    func getModels() -> [Models] {

    }

}
