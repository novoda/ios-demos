import Foundation
import SceneKit

struct Model: Decodable {
    let filePath: String
    let fileName: String
    let fileExtension: String
    let nodes: [Node]
    let lightSettings: LightSetting
    let planeSettings: PlaneSettings
}

struct Node: Decodable {
    let name: String
    let type: NodeType
}

enum NodeType: String, Decodable {
    case object = "object"
    case plane = "plane"
    case light = "light"
}

struct LightSetting: Decodable {
    let intensity: CGFloat
    let shadowMode: ShadowOptions
    let shadowSampleCount: Int
}

enum ShadowOptions: String, Decodable {
    case deferred = "deferred"
    case forward = "forward"
    case modulated = "modulated"
}

extension ShadowOptions {
    func getMode() -> SCNShadowMode {
        switch self {
        case .deferred: return .deferred
        case .forward: return .forward
        case .modulated: return .modulated
        }
    }
}

struct PlaneSettings: Decodable {
    let writesToDepthBuffer: Bool
    let colorBufferWriteMask: ColorBufferOptions
}

struct ColorBufferOptions: Decodable, Loopable {
    let all: Bool
    let red: Bool
    let green: Bool
    let blue: Bool
    let alpha: Bool
    
    func getOptionSet() -> SCNColorMask {
        var optionSet = SCNColorMask()
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
    
    private func keyStringAsOption(_ propertyString: String) -> SCNColorMask? {
        switch propertyString {
            case "all": return .all
            case "red": return .red
            case "green": return .green
            case "blue": return .blue
            case "alpha": return .alpha
            default: return nil
        }
    }
}
