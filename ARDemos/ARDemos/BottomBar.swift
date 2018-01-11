import UIKit

class BottomBar: UIView {

    private let scrollView = UIScrollView()

    required init?(coder aDecoder: NSCoder) {
        <#code#>
    }

    override init(frame: CGRect) {
        setUpViews()
        setUpLayout()
    }

    private func setUpViews() {

        addSubview(scrollView)
    }

    private func setUpLayout() {

    }

    func setUpModels(models: [Models]) {
        
    }
}
