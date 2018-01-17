import Foundation
import SceneKit

struct SceneSettings: Decodable {
    let showsStatistics: Bool
    let autoenablesDefaultLighting: Bool
    let antialiasingMode: AntialiasingOption
    let debugOptions: DebugOption
}

enum AntialiasingOption: String, Decodable {
    case none = "none"
    case multisampling2X = "multisampling2X"
    case multisampling4X = "multisampling4X"
}

extension AntialiasingOption {
    func getMode() -> SCNAntialiasingMode {
        switch self {
        case .none: return .none
        case .multisampling2X: return .multisampling2X
        case .multisampling4X: return .multisampling4X
        }
    }
}

struct DebugOption: Decodable, Loopable {
    let showPhysicsShapes: Bool
    let showBoundingBoxes: Bool
    let showLightInfluences: Bool
    let showLightExtents: Bool
    let showPhysicsFields: Bool
    let showWireframe: Bool
    let renderAsWireframe: Bool
    let showSkeletons: Bool
    let showCreases: Bool
    let showConstraints: Bool
    let showCameras: Bool
}

extension DebugOption {
    func getOptionSet() -> SCNDebugOptions {
        var optionSet = SCNDebugOptions()
        let allPropertyValues = self.allProperties
        allPropertyValues.forEach { property in
            guard let valueIsTrue = property.value as? Bool else { return }
            let propertyAsOption = keyStringAsOption(property.key)
            if valueIsTrue {
                optionSet.insert(propertyAsOption!)
            }
        }
        return optionSet
    }
    
    private func keyStringAsOption(_ propertyString: String) -> SCNDebugOptions? {
        switch propertyString {
        case "showPhysicsShapes": return .showPhysicsShapes
        case "showBoundingBoxes": return .showBoundingBoxes
        case "showLightInfluences": return .showLightInfluences
        case "showLightExtents": return .showLightExtents
        case "showPhysicsFields": return .showPhysicsFields
        case "showWireframe": return .showWireframe
        case "renderAsWireframe": return .renderAsWireframe
        case "showSkeletons": return .showSkeletons
        case "showCreases": return .showCreases
        case "showConstraints": return .showConstraints
        case "showCameras": return .showCameras
        default: return nil
        }
    }
}
