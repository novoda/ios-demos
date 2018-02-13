import UIKit

class StartViewController: UIViewController {

    @IBOutlet weak var oneModelUsingVectorsButton: UIButton!
    @IBOutlet weak var oneModelUsingAnchorsButton: UIButton!
    @IBOutlet weak var sizeComparisonButton: UIButton!
    @IBOutlet weak var recognizeObjectsButton: UIButton!
    @IBOutlet weak var lightsAnimationButton: UIButton!

    override func viewDidLoad() {
        setupButtonsTitles()
        setupButtonView()
    }

    private func setupButtonsTitles() {
        oneModelUsingVectorsButton.setTitle(OneModelUsingVectorsViewController.getName(), for: .normal)
        oneModelUsingAnchorsButton.setTitle(OneModelUsingAnchorsViewController.getName(), for: .normal)
        sizeComparisonButton.setTitle(SizeComparisonViewController.getName(), for: .normal)
        recognizeObjectsButton.setTitle(RecognizeObjectsViewController.getName(), for: .normal)
        lightsAnimationButton.setTitle(LightsAnimationsViewController.getName(), for: .normal)
    }

    private func setupButtonView() {
        oneModelUsingVectorsButton.backgroundColor = ButtonStyle.startButtonStyle.backgroundColor
        oneModelUsingVectorsButton.tintColor = ButtonStyle.startButtonStyle.textColor
        oneModelUsingVectorsButton.alpha = ButtonStyle.startButtonStyle.backgroundAlpha

        oneModelUsingAnchorsButton.backgroundColor = ButtonStyle.startButtonStyle.backgroundColor
        oneModelUsingAnchorsButton.tintColor = ButtonStyle.startButtonStyle.textColor
        oneModelUsingAnchorsButton.alpha = ButtonStyle.startButtonStyle.backgroundAlpha

        sizeComparisonButton.backgroundColor = ButtonStyle.startButtonStyle.backgroundColor
        sizeComparisonButton.tintColor = ButtonStyle.startButtonStyle.textColor
        sizeComparisonButton.alpha = ButtonStyle.startButtonStyle.backgroundAlpha

        recognizeObjectsButton.backgroundColor = ButtonStyle.startButtonStyle.backgroundColor
        recognizeObjectsButton.tintColor = ButtonStyle.startButtonStyle.textColor
        recognizeObjectsButton.alpha = ButtonStyle.startButtonStyle.backgroundAlpha

        lightsAnimationButton.backgroundColor = ButtonStyle.startButtonStyle.backgroundColor
        lightsAnimationButton.tintColor = ButtonStyle.startButtonStyle.textColor
        lightsAnimationButton.alpha = ButtonStyle.startButtonStyle.backgroundAlpha
    }

}

private struct ButtonStyle {
    let backgroundColor: UIColor
    let textColor: UIColor
    let backgroundAlpha: CGFloat
}

private extension ButtonStyle {
    static var startButtonStyle = ButtonStyle(
        backgroundColor: .blue,
        textColor: .white,
        backgroundAlpha: 0.65)
}

private extension UIViewController {
    static func getName() -> String {
        return String(describing: self)
    }
}
