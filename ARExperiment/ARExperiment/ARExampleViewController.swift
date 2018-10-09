import UIKit

class ARExampleViewController: UIViewController {

    func setbackgroundColor() {
        self.view.backgroundColor = .white
    }

    func setNavigationBar(controllerName: String) {
        navigationController?.navigationBar.tintColor = .white
        title = controllerName
    }

}
