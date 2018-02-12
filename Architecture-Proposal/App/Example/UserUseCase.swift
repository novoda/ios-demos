import RxSwift
import Core

protocol UserUseCase {
    func user() -> Observable<DataState<User>>
}

final class DefaultUseCase: UserUseCase {
    let fetcher: UserFetcher

    init(fetcher: UserFetcher) {
        self.fetcher = fetcher
    }

    func user() -> Observable<DataState<User>> {
        return fetcher
            .fetch()
        .toDataState(currentData: nil)
    }
}
