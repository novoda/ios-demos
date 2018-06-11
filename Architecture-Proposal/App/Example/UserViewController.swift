import Foundation

final class UserViewController: UIViewController {
    fileprivate let nameLabel = UILabel()

    override func viewDidLoad() {
        super.viewDidLoad()

        nameLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        nameLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        nameLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
    }
}

extension UserViewController: UserDisplayer {
    func update(with viewState: UserViewState) {
        self.nameLabel.text = viewState.fullName
    }
}
