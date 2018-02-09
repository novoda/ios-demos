import Foundation
import RxSwift

final class UserFetcher: Fetcher {
    private let service: APIService

    init(service: APIService) {
        self.service = service
    }

    func fetch(predicate: FetcherPredicate? = nil) -> Observable<User> {
        let url = URL(string: "https://randomuser.me/api/")!
        return service.fetch(request: URLRequest(url: url))
    }
}
