import UIKit

class BottomBar: UIView {

    private let scrollView = UIScrollView()
    private var models: [Model]?
    
    var onTap: ((String) -> Void)?

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        setUpViews()
        setUpLayout()
    }

    private func setUpViews() {
        addSubview(scrollView)
    }

    private func setUpLayout() {
        applyConstraint(for: .top)
        applyConstraint(for: .right)
        applyConstraint(for: .bottom)
        applyConstraint(for: .left)
    }
    
    private func applyConstraint(for attribute: NSLayoutAttribute) {
        let constraint = NSLayoutConstraint(item: scrollView,
                                  attribute: attribute,
                                  relatedBy: .equal,
                                  toItem: self,
                                  attribute: attribute,
                                  multiplier: 1,
                                  constant: 0)
        
        scrollView.addConstraint(constraint)
    }

    func addModelButtons(models: [Model]) {
        let height = scrollView.bounds.height
        let width = scrollView.bounds.width/4
        let frame = CGRect(x: 0, y: 0, width: width, height: height)
        
        models.forEach { model in
            let modelButton = UIButton(frame: frame)
            modelButton.backgroundColor = .lightGray
            modelButton.setTitle(model.fileName, for: .normal)
            modelButton.addTarget(self, action: #selector(modelButtonTapped), for: .touchUpInside)
            
            scrollView.addSubview(modelButton)
        }
    }
    
    @objc private func modelButtonTapped(button: UIButton) {
        guard let modelName = button.titleLabel?.text else { return }
            onTap?(modelName)
    }
}
