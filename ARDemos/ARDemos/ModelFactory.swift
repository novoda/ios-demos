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
    let shadowMode: String = "deferred"
    let shadowSampleCount: Int = 10
}

struct PlaneSettings: Decodable {
    let writesToDepthBuffer: Bool = false
    let colorBufferWriteMask: [ColorBufferOptions] = []
}

enum ColorBufferOptions: String, Decodable {
    case all = "all"
    case red = "red"
    case green = "green"
    case blue = "blue"
    case alpha = "alpha"
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
        case .none: return SCNAntialiasingMode.none
        case .mutisampling2X: return SCNAntialiasingMode.multisampling2X
        case .mutisampling4X: return SCNAntialiasingMode.multisampling4X
        }
    }
}

struct DebugOption: Decodable {
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
