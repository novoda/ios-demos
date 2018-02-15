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

extension Model {
    static func ==(lhs: Model, rhs: Model) -> Bool {
        
        return lhs.filePath == rhs.filePath &&
                lhs.fileName == rhs.fileName &&
                lhs.fileExtension == rhs.fileExtension &&
                lhs.nodes.count == rhs.nodes.count &&
                lhs.lightSettings == rhs.lightSettings &&
                lhs.planeSettings == rhs.planeSettings
    }
}

struct Node: Decodable {
    let name: String
    let type: NodeType
}

extension Node  {
    static func ==(lhs: Node, rhs: Node) -> Bool {
        return lhs.name == rhs.name &&
                lhs.type == rhs.type
    }
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
    let shadowRadius: CGFloat
}

extension LightSetting  {
    static func ==(lhs: LightSetting, rhs: LightSetting) -> Bool {
        return lhs.intensity == rhs.intensity &&
                lhs.shadowMode == rhs.shadowMode &&
                lhs.shadowSampleCount == rhs.shadowSampleCount &&
                lhs.shadowRadius == rhs.shadowRadius
    }
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

extension PlaneSettings  {
    static func ==(lhs: PlaneSettings, rhs: PlaneSettings) -> Bool {
        return lhs.writesToDepthBuffer == rhs.writesToDepthBuffer &&
                lhs.colorBufferWriteMask == rhs.colorBufferWriteMask
    }
}

struct ColorBufferOptions: Decodable, Loopable {
    let all: Bool
    let red: Bool
    let green: Bool
    let blue: Bool
    let alpha: Bool
}

extension ColorBufferOptions  {
    static func ==(lhs: ColorBufferOptions, rhs: ColorBufferOptions) -> Bool {
        return lhs.all == rhs.all &&
                lhs.red == rhs.red &&
                lhs.green == rhs.green &&
                lhs.blue == rhs.blue &&
                lhs.alpha == rhs.alpha
    }
    
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
