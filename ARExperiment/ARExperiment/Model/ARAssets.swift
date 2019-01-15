import Foundation
import SceneKit
import ARKit

struct ARAsset {
    let fileName: String
    let fileExtension: String
    let assetFolder: String?
    let nodes: [ARNode]
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
    static let banana = ARAsset(fileName: "banana-small",
                                     fileExtension: "dae",
                                     assetFolder: "Banana",
                                     nodes: [ARNode(name: "banana",
                                                    nodeType: .model)])
    static let measuringUnits = ARAsset(fileName: "measuring-units",
                                        fileExtension: "scn",
                                        assetFolder: nil,
                                        nodes: [ARNode(name: "text_5", nodeType: .model),
                                                ARNode(name: "cube_5", nodeType: .model),
                                                ARNode(name: "text_1", nodeType: .model),
                                                ARNode(name: "cube_1", nodeType: .model),
                                                ARNode(name: "text_0.1", nodeType: .model),
                                                ARNode(name: "cube_0.1", nodeType: .model)])
    static let cubeWireframe = ARAsset(fileName: "cubewireframe",
                                       fileExtension: "dae",
                                       assetFolder: nil,
                                       nodes: [ARNode(name: "cubewireframe",
                                                      nodeType: .model)])
    static let earthMoon = ARAsset(fileName: "earth-moon",
                                   fileExtension: "dae",
                                   assetFolder: "EarthMoon",
                                   nodes: [ARNode(name: "Sphere", nodeType: .model),
                                           ARNode(name: "Moon_Orbit", nodeType: .model),
                                           ARNode(name: "Plane", nodeType: .plane),
                                           ARNode(name: "Sun", nodeType: .light)])

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
