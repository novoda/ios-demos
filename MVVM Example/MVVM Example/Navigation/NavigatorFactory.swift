//
// Created by Niamh Power on 30/01/2018.
// Copyright (c) 2018 Novoda. All rights reserved.
//

import Foundation
import UIKit

protocol NavigatorViewControllerFactory {
    func initialViewController(_ navigator: NavigatorProtocol) -> UIViewController
}

class NavigatorFactory: NavigatorViewControllerFactory {

    func initialViewController(_ navigator: NavigatorProtocol) -> UIViewController {
        return listViewController(navigator: navigator)
    }

    func listViewController(navigator: NavigatorProtocol) -> UIViewController {
        let viewModel = ListViewModel(viewData: .defaultData())
        return ListViewController(viewModel: viewModel)
    }
}
