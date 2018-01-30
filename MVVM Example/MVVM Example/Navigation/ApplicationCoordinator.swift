//
//  File.swift
//  MVVM Example
//
//  Created by Niamh Power on 30/01/2018.
//  Copyright © 2018 Novoda. All rights reserved.
//

import Foundation
import UIKit

protocol NavigatorProtocol {
    func showInitialScreen()
}

class Navigator: NSObject, NavigatorProtocol {
    fileprivate let window: UIWindow
    fileprivate let popupTransitionCoordinator = TransitionDelegate(presentAnimator: FadeInPresentAnimator(),
            dismissAnimator: FadeInDismissAnimator())
    fileprivate let navigatorFactory: NavigatorViewControllerFactory

    init(window: UIWindow,
         navigatorFactory: NavigatorViewControllerFactory) {
        self.window = window
        self.navigatorFactory = navigatorFactory
    }

    func showInitialScreen() {
        dispatchOnMainQueueIfNeeded {
            self.window.rootViewController = self.navigatorFactory.initialViewController(self)
            self.window.makeKeyAndVisible()
        }
    }

    @objc func dismiss() {
        window.rootViewController?.dismiss(animated: true, completion: nil)
    }

    func showListViewScreen() {
        let viewModel = ListViewModel(viewData: .defaultData())
        let vc = ListViewController(viewModel: viewModel)
        window.rootViewController?.present(vc, animated: true, completion: nil)
    }

    @objc fileprivate func dismissViewController() {
        window.rootViewController?.dismiss(animated: true, completion: nil)
    }

    func showAlertDialog(_ title: String, message: String, action: UIAlertAction) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(action)

        window.rootViewController?.present(alert, animated: true, completion: nil)
    }

    func showRegistration(from navigationController: UINavigationController) {
        let registrationController = self.navigatorFactory.registrationViewController(self, showCancel: true)
        navigationController.present(registrationController, animated: true, completion: nil)
    }
}
