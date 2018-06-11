import RxSwift

/**
 If needed it will contains logical conditions used to constrain a fetch
 */
public protocol FetcherPredicate {}

/**
 Every Domain Model associated have a dedicated Fetcher
 that is responsibile to retrieve the information.
 The fetcher will always use a Service to fetch the model
 */
public protocol Fetcher {
    associatedtype Model
    func fetch(predicate: FetcherPredicate?) -> Observable<Model>
}
