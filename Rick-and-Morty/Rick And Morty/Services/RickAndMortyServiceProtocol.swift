import Foundation

protocol RickAndMortyServiceProtocol {
    func fetchData<T:Decodable>(url: URL, success: @escaping (T) -> (), error: @escaping (Error?) -> ())
}
