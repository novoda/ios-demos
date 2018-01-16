import Foundation
import SceneKit

struct ResponseData: Decodable {
    var model: [Model]
    var sceneSettings: SceneSettings
}

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
    let intensity: CGFloat = 0
    let shadowMode: ShadowOptions = .deferred
    let shadowSampleCount: Int = 10
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
    let writesToDepthBuffer: Bool = false
    let colorBufferWriteMask: ColorBufferOptions
}

struct ColorBufferOptions: Decodable, Loopable {
    let all: Bool = false
    let red: Bool = false
    let green: Bool = false
    let blue: Bool = false
    let alpha: Bool = false
    
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

class ModelFactory {

    func parseJSON() -> [Model] {
        if let url = Bundle.main.url(forResource: "ModelsData", withExtension: "json") {
            do {
                let data = try Data(contentsOf: url)
                let decoder = JSONDecoder()
                let jsonData = try decoder.decode(ResponseData.self, from: data)
                
                return jsonData.model
            } catch {
                print("error:\(error)")
            }
        }
        return []
    }
}
