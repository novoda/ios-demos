import UIKit
import Foundation

class SecondViewController: UIViewController {

  private let label = UILabel()
  private var input: String?

  convenience init(input: String?) {
    self.init(nibName: nil, bundle: nil)
    self.input = input
  }

  override func viewDidLoad() {
    super.viewDidLoad()
    title = "Second"

    view.backgroundColor = .white
    view.addSubview(label)
    label.translatesAutoresizingMaskIntoConstraints = false
    label.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
    label.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
    label.topAnchor.constraint(equalTo: topLayoutGuide.bottomAnchor).isActive = true
    label.bottomAnchor.constraint(equalTo: bottomLayoutGuide.topAnchor).isActive = true
    label.textAlignment = .center
    label.accessibilityLabel = "welcome"

    if let input = input, input.characters.count > 0 {
      label.text = "Welcome, \(input)"
    } else {
      label.text = "Welcome stranger!"
    }
  }

}
