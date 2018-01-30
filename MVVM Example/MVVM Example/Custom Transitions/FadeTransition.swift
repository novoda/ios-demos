//
//  Created by Sergey Shulga on 24/05/2017.
// Copyright (c) 2018 Novoda. All rights reserved.
//

import Foundation
import UIKit

final class FadeInPresentAnimator: NSObject, UIViewControllerAnimatedTransitioning {

    @objc func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return 0.3
    }

    @objc func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        let container = transitionContext.containerView
        let toView = transitionContext.view(forKey: UITransitionContextViewKey.to)!
        container.addSubview(toView)
        toView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        toView.alpha = 0
        UIView.animate(withDuration: 0.3, animations: {
            toView.alpha = 1
        }, completion: { (finished) in
            transitionContext.completeTransition(finished)
        })
    }
}

final class FadeInDismissAnimator: NSObject, UIViewControllerAnimatedTransitioning {
    @objc func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return 0.3
    }

    @objc func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        let container = transitionContext.containerView
        let toView = transitionContext.view(forKey: UITransitionContextViewKey.from)!
        container.addSubview(toView)
        UIView.animate(withDuration: 0.3, animations: {
            toView.alpha = 0
        }, completion: { (finished) in
            transitionContext.completeTransition(finished)
        })
    }
}
