import Foundation

protocol Displayer {
    associatedtype ViewState

    func update(with viewState: ViewState)
}
