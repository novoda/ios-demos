//
//  ListViewModel.swift
//  MVVM Example
//
//  Created by Niamh Power on 30/01/2018.
//  Copyright © 2018 Novoda. All rights reserved.
//

import Foundation

class ListViewModel: ListViewActionDelegate {
    fileprivate var viewData: ListViewData {
        didSet {
            didChangeData?(viewData)
        }
    }

//    TODO: navigation
//  fileprivate let navigator: TYPE

    var didChangeData: ((ListViewData) -> Void)?

    init(viewData: ListViewData) {
        self.viewData = viewData
    }

    func ready() {
        self.viewData = .defaultData()
    }

    func itemPressed() {
        //do stuff!
    }
}
