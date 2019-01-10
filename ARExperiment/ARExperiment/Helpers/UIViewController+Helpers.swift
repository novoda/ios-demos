import UIKit

extension UIViewController {
    func viewBackgroundColor(to color: UIColor) {
        self.view.backgroundColor = color
    }

    func styleNavigationBar(with color: UIColor) {
        navigationController?.navigationBar.tintColor = color
    }
}
