//
//  Created by Sergey Shulga on 24/05/2017.
// Copyright (c) 2018 Novoda. All rights reserved.
//

import Foundation
import UIKit

final class TransitionDelegate: NSObject, UIViewControllerTransitioningDelegate {
    let presentAnimator: UIViewControllerAnimatedTransitioning?
    let dismissAnimator: UIViewControllerAnimatedTransitioning?
    let presentInteractiveAnimator: UIViewControllerInteractiveTransitioning?
    let dismissInteractiveAnimator: UIViewControllerInteractiveTransitioning?
    let presentationController: UIPresentationController?

    init(presentAnimator: UIViewControllerAnimatedTransitioning? = nil,
         dismissAnimator: UIViewControllerAnimatedTransitioning? = nil,
         presentInteractiveAnimator: UIViewControllerInteractiveTransitioning? = nil,
         dismissInteractiveAnimator: UIViewControllerInteractiveTransitioning? = nil,
         presentationController: UIPresentationController? = nil) {
        self.presentAnimator = presentAnimator
        self.dismissAnimator = dismissAnimator
        self.presentInteractiveAnimator = presentInteractiveAnimator
        self.dismissInteractiveAnimator = dismissInteractiveAnimator
        self.presentationController = presentationController
    }

    func animationController(forPresented presented: UIViewController,
                             presenting: UIViewController,
                             source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return presentAnimator
    }

    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return dismissAnimator
    }

    func interactionControllerForPresentation(using animator: UIViewControllerAnimatedTransitioning) -> UIViewControllerInteractiveTransitioning? {
        return presentInteractiveAnimator
    }

    func interactionControllerForDismissal(using animator: UIViewControllerAnimatedTransitioning) -> UIViewControllerInteractiveTransitioning? {
        return dismissInteractiveAnimator
    }

    func presentationController(forPresented presented: UIViewController,
                                presenting: UIViewController?,
                                source: UIViewController) -> UIPresentationController? {
        return presentationController
    }
}
