import UIKit

class BottomBar: UIView {
    
    typealias BindTap = ((String) -> Void)?

    private let scrollView = UIScrollView()
    private let buttonsStackView = UIStackView()
    
    var onTap: BindTap

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setUpViews()
        setUpLayout()
    }

    private func setUpViews() {
        backgroundColor = .bottomBar
        
        buttonsStackView.backgroundColor = .clear
        buttonsStackView.alignment = .center
        buttonsStackView.distribution = .fillEqually
        buttonsStackView.axis = .horizontal
        buttonsStackView.spacing = 5
        
        scrollView.backgroundColor = .clear
        scrollView.addSubview(buttonsStackView)
        addSubview(scrollView)
    }
    
    private func setUpLayout() {
        scrollView.pinToSuperview(edges: [.top, .bottom, .left, .right],
                                  constant: 0,
                                  priority: .defaultHigh)
        buttonsStackView.pinToSuperview(edges: [.top, .bottom, .left, .right],
                                        constant: 5,
                                        priority: .defaultHigh)
        buttonsStackView.widthAnchor.constraint(greaterThanOrEqualTo: scrollView.widthAnchor,
                                                multiplier: 1,
                                                constant: -10).isActive = true
        buttonsStackView.heightAnchor.constraint(greaterThanOrEqualTo: scrollView.heightAnchor,
                                                 multiplier: 1,
                                                 constant: -10).isActive = true
    }

    func addModelButtons(models: [Model]) {
        
        models.forEach { model in
            let modelButton = UIButton()
            modelButton.backgroundColor = .unSelectedButton
            modelButton.setTitleColor(.buttonText, for: .normal)
            modelButton.setTitle(model.fileName, for: .normal)
            modelButton.addTarget(self, action: #selector(modelButtonTapped), for: .touchUpInside)

            buttonsStackView.addArrangedSubview(modelButton)

            if model == models[0] {
                updateSelectedButtonColor(modelButton)
            }
        }
    }
    
    @objc private func modelButtonTapped(button: UIButton) {
        guard let modelName = button.titleLabel?.text else { return }
            onTap?(modelName)
            resetButtonColors()
            updateSelectedButtonColor(button)
    }
    
    private func resetButtonColors() {
        for case let button as UIButton in buttonsStackView.subviews {
            button.backgroundColor = .unSelectedButton
        }
    }
    
    private func updateSelectedButtonColor(_ button: UIButton) {
        button.backgroundColor = .selectedButton
    }
}
