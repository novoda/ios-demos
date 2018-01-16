import Foundation
import SceneKit

class SceneSettingsFactory {
    
    func parseJSON() -> SceneSettings? {
        if let url = Bundle.main.url(forResource: "ModelsData", withExtension: "json") {
            do {
                let data = try Data(contentsOf: url)
                let decoder = JSONDecoder()
                let jsonData = try decoder.decode(ResponseData.self, from: data)
                
                return jsonData.sceneSettings
            } catch {
                print("error:\(error)")
            }
        }
        return nil
    }
}

struct SceneSettings: Decodable {
    let showsStatistics: Bool = false
    let autoenablesDefaultLighting: Bool = false
    let antialiasingMode: AntialiasingOption = .none
    let debugOptions: DebugOption
}

enum AntialiasingOption: String, Decodable {
    case none = "none"
    case mutisampling2X = "mutisampling2X"
    case mutisampling4X = "mutisampling4X"
}

extension AntialiasingOption {
    func getMode() -> SCNAntialiasingMode {
        switch self {
        case .none: return .none
        case .mutisampling2X: return .multisampling2X
        case .mutisampling4X: return .multisampling4X
        }
    }
}

struct DebugOption: Decodable, Loopable {
    let showPhysicsShapes: Bool = false
    let showBoundingBoxes: Bool  = false
    let showLightInfluences: Bool = false
    let showLightExtents: Bool = false
    let showPhysicsFields: Bool = false
    let showWireframe: Bool = false
    let renderAsWireframe: Bool = false
    let showSkeletons: Bool = false
    let showCreases: Bool = false
    let showConstraints: Bool = false
    let showCameras: Bool = false
    
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
