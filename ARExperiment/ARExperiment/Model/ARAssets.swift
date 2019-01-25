import Foundation
import SceneKit
import ARKit

struct ARAsset {
    let fileName: String
    let fileExtension: String
    let assetFolder: String?
    let nodes: [ARNode]
}

struct ARNode {
    let name: String
    let nodeType: NodeType
}

enum NodeType {
    case model
    case light
    case plane
}

extension ARAsset {
    func filePath() -> String {
        if let assetFolder = assetFolder {
            return "art.scnassets/\(assetFolder)/\(fileName).\(fileExtension)"
        }
        return "art.scnassets/\(fileName).\(fileExtension)"
    }

    func nodesOfType(_ type: NodeType) -> [ARNode] {
        return nodes.filter{$0.nodeType == type}
    }

    func nodeWithName(_ name: String) -> ARNode? {
        return nodes.filter{$0.name == name}.first
    }
}

extension ARAsset {
    static let novodaPlaneExterior = ARAsset(fileName: "plane-exterior",
                                             fileExtension: "scn",
                                             assetFolder: "plane-exterior",
                                             nodes: [ARNode(name: "plane", nodeType: .model)])
    static let novodaPlaneInterior = ARAsset(fileName: "cabin",
                                             fileExtension: "scn",
                                             assetFolder: "plane-interior-reduced",
                                             nodes: [ARNode(name: "First_Class_Passenger_Cabin", nodeType: .model)])
}
