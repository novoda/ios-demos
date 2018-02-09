import RxSwift

/**
 If needed it will contains logical conditions used to constrain a fetch
 */
protocol FetcherPredicate {}

/**
 Every Domain Model associated have a dedicated Fetcher
 that is responsibile to retrieve the information.
 The fetcher will always use a Service to fetch the model
 */
protocol Fetcher {
    associatedtype Model
    func fetch(predicate: FetcherPredicate?) -> Observable<Model>
}

extension Fetcher {
    func fetch(predicate: FetcherPredicate? = nil) -> Observable<Model> {
        preconditionFailure("This method must be implemented in your fetcher or not used")
    }
}
