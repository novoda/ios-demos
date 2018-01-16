import Foundation

class DataFactory {
    
    func parseJSON(fileName: String) -> ResponseData? {
        if let url = Bundle.main.url(forResource: fileName, withExtension: "json") {
            do {
                let data = try Data(contentsOf: url)
                let decoder = JSONDecoder()
                let jsonData = try decoder.decode(ResponseData.self, from: data)
                
                return jsonData
            } catch {
                print("error:\(error)")
            }
        }
        return nil
    }
}
