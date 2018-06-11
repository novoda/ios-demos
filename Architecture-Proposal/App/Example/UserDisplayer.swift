import Foundation

struct UserViewState {
    let fullName: String
}

protocol UserDisplayer: Displayer {
    func update(with viewState: UserViewState)
}
