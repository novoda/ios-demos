import RxSwift

protocol DomainModel: Decodable {}

/**
 Provides DomainModel
 */
protocol Service {}

/**
 Service that fetches objects from the API
 */
protocol APIService: Service {
    func fetch<T>(request: URLRequest) -> Observable<T> where T: DomainModel
}
