//
// Created by Niamh Power on 30/01/2018.
// Copyright (c) 2018 Novoda. All rights reserved.
//

import Foundation

struct ListItemViewData {
    var title: String
    var subTitle: String
}

extension ListItemViewData {
    static func defaultData() -> ListItemViewData {
        return ListItemViewData(title: "List item title", subTitle: "List item subtitle")
    }
}