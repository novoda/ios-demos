import UIKit

extension UIViewController {
    func setViewBackgroundColor(to color: UIColor) {
        self.view.backgroundColor = color
    }

    func styleNavigationBar(with color: UIColor) {
        navigationController?.navigationBar.tintColor = color
    }
}
