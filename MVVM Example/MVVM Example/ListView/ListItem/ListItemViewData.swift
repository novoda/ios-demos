//
// Created by Niamh Power on 30/01/2018.
// Copyright (c) 2018 Novoda. All rights reserved.
//

import Foundation

struct ListCellViewData {
    var title: String
    var subtitle: String
}

extension ListCellViewData {
    static func defaultData() -> ListCellViewData {
        return ListCellViewData(title: "cell title", subtitle: "cell subtitle")
    }
}
