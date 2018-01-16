import UIKit

class BottomBar: UIView {

    private let scrollView = UIScrollView()
    private let buttonsStackView = UIStackView()
    
    var onTap: ((String) -> Void)?

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setUpViews()
        setUpLayout()
    }

    private func setUpViews() {
        buttonsStackView.alignment = .fill
        buttonsStackView.distribution = .fillEqually
        buttonsStackView.axis = .horizontal
        buttonsStackView.spacing = 5

        scrollView.addSubview(buttonsStackView)
        addSubview(scrollView)
    }

    private func setUpLayout() {

        buttonsStackView.pinToSuperview(edges: [.top, .bottom, .left, .right], constant: 5, priority: .defaultHigh)
        scrollView.pinToSuperview(edges: [.top, .bottom, .left, .right], constant: 0, priority: .defaultHigh)
    }

    func addModelButtons(models: [Model]) {
        
        models.forEach { model in
            let modelButton = UIButton()
            modelButton.backgroundColor = .lightGray
            modelButton.setTitle(model.fileName, for: .normal)
            modelButton.addTarget(self, action: #selector(modelButtonTapped), for: .touchUpInside)
            modelButton.reversesTitleShadowWhenHighlighted = true

            buttonsStackView.addArrangedSubview(modelButton)

            if let first = models.first,
                first.fileName == model.fileName {
                modelButton.isSelected = true
            }
        }
    }
    
    @objc private func modelButtonTapped(button: UIButton) {
        guard let modelName = button.titleLabel?.text else { return }
            onTap?(modelName)
    }
}
