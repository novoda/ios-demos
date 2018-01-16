import UIKit

class BottomBar: UIView {

    private let scrollView = UIScrollView()
    private let buttonsStackView = UIStackView()
    
    var onTap: ((String) -> Void)?

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    private func setUpViews() {
        buttonsStackView.alignment = .fill
        buttonsStackView.distribution = .fillEqually

        scrollView.addSubview(buttonsStackView)
        addSubview(scrollView)
    }

    private func setUpLayout() {

        scrollView.pinToSuperview(edges: [.top, .bottom, .left, .right], constant: 0, priority: .defaultHigh)

        buttonsStackView.pinToSuperview(edges: [.top, .bottom, .left, .right], constant: 5, priority: .defaultHigh)
    }

    func setupView() {
        setUpViews()
        setUpLayout()
    }

    func addModelButtons(models: [Model]) {
        
        models.forEach { model in
            let modelButton = UIButton()
            modelButton.backgroundColor = .lightGray
            modelButton.setTitle(model.fileName, for: .normal)
            modelButton.addTarget(self, action: #selector(modelButtonTapped), for: .touchUpInside)
            
            buttonsStackView.addArrangedSubview(modelButton)
        }
    }
    
    @objc private func modelButtonTapped(button: UIButton) {
        guard let modelName = button.titleLabel?.text else { return }
            onTap?(modelName)
    }
}
