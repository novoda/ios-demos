import Foundation

final class RickAndMortyService: RickAndMortyServiceProtocol {
    static let baseURL = URL(string: "https://rickandmortyapi.com/api")!
    
    func fetchData<T:Decodable>(url: URL, success: @escaping (T) -> (), error: @escaping (NSError?) -> ()) {
        
        let request = URLRequest(url: url)

        URLSession.shared.dataTask(with: request) { data, response, requestError in
            if let data = data {
                let decoder = JSONDecoder()
                
                do {
                    let decodedData = try decoder.decode(T.self, from: data)
                    DispatchQueue.main.async {
                        success(decodedData)
                    }
                } catch let decodingError {
                    if let err = decodingError as NSError? {
                        DispatchQueue.main.async {
                            error(err)
                        }
                    }
                }
            } else {
                if let err = requestError as NSError? {
                    DispatchQueue.main.async {
                        error(err)
                    }
                }
            }
        }.resume()
    }
}
