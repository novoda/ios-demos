//
//  ListViewCoordinator.swift
//  MVVM Example
//
//  Created by Niamh Power on 30/01/2018.
//  Copyright © 2018 Novoda. All rights reserved.
//

import Foundation

import UIKit

//
//  AppStatusNavigator.swift
//  mydriveapp
//
//  Created by Sergey Shulga on 13/04/2017.
//  Copyright © 2017 MyDrive. All rights reserved.
//

import Foundation

protocol ListViewNavigatorProtocol {
    func toListItemDetail()
}

class ListViewNavigator: ListViewNavigatorProtocol {
    fileprivate let application: UIApplication
    fileprivate let viewController: UIViewController

    init(application: UIApplication, viewController: UIViewController) {
        self.application = application
        self.viewController = viewController
    }

    func toListItemDetail() {
        //TODO: show list item detail view
    }
}
