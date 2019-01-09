import UIKit

extension UIViewController {
    func viewBackgroundColor(to color: UIColor) {
        self.view.backgroundColor = color
    }

    func navigationBar(with color: UIColor, and name: String) {
        navigationController?.navigationBar.tintColor = color
        title = name
    }
}
