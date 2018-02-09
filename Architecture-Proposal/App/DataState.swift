import RxSwift

enum DataState<T> {
    case idle(T)
    case loading()
    case error(T?, Error)

    var data: T? {
        switch self {
        case .idle(let data): return data
        case .loading(): return nil
        case .error(let data, _): return data
        }
    }

    var isLoading: Bool {
        switch self {
        case .loading: return true
        default: return false
        }
    }
}

extension ObservableType {
    func toDataState(currentData: E?) -> Observable<DataState<E>> {
        return self
            .map { .idle($0) }
            .catchError({ .just(.error(currentData, $0)) })
            .startWith(.loading())
    }
}

