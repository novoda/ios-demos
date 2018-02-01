//
//  ListViewData.swift
//  MVVM Example
//
//  Created by Niamh Power on 30/01/2018.
//  Copyright © 2018 Novoda. All rights reserved.
//

import Foundation

struct ListViewData {
    var title: String
    var items: [ListCellViewData]
}

extension ListViewData {
    static func defaultData() -> ListViewData {
        return ListViewData(title: "List View Title",
                items: [.defaultData(), .defaultData(), .defaultData()])
    }
}
