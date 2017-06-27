import UIKit

class ViewController: UIViewController {

  let button = UIButton()
  let textField = UITextField()

  override func viewDidLoad() {
    super.viewDidLoad()
    title = "First"

    view.backgroundColor = .white

    view.addSubview(textField)
    textField.translatesAutoresizingMaskIntoConstraints = false
    textField.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
    textField.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
    textField.topAnchor.constraint(equalTo: topLayoutGuide.bottomAnchor).isActive = true

    view.addSubview(button)
    button.translatesAutoresizingMaskIntoConstraints = false
    button.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
    button.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
    button.topAnchor.constraint(equalTo: textField.bottomAnchor).isActive = true
    button.heightAnchor.constraint(equalToConstant: 50).isActive = true

    textField.accessibilityLabel = "Input"
    button.setTitle("Go", for: .normal)
    button.setTitleColor(.red, for: .normal)
    button.addTarget(self, action: #selector(buttonTapped), for: .touchUpInside)
  }

  func buttonTapped() {
    show(SecondViewController(input: textField.text), sender: self)
  }

}

