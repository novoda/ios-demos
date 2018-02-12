import Foundation
import RxSwift

public final class UserFetcher: Fetcher {
    private let service: APIService

    init(service: APIService) {
        self.service = service
    }

    public func fetch(predicate: FetcherPredicate? = nil) -> Observable<User> {
        let url = URL(string: "https://randomuser.me/api/")!
        return service.fetch(request: URLRequest(url: url))
    }
}
