import Foundation

struct ResponseData: Decodable {
    var models: [Model]
    var sceneSettings: SceneSettings
}
