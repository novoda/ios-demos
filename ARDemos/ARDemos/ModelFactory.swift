import Foundation

struct ResponseData: Decodable {
    var model: [Model]
}

struct Model: Decodable {
    let filePath: String
    let fileName: String
    let fileExtension: String
    let nodes: [Node]
}

struct Node: Decodable {
    let name: String
    let type: NodeType
}

enum NodeType: String, Decodable {
    case object = "object"
    case plane = "plane"
    case lightSource = "light source"
}

class ModelFactory {

    func parseJSON() -> [Model]? {
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
        return nil
    }
}
