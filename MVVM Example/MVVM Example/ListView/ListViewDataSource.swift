//
// Created by Niamh Power on 30/01/2018.
// Copyright (c) 2018 Novoda. All rights reserved.
//

import Foundation
import UIKit

typealias OnListDataSourceItemSelectionHandlerType = (IndexPath, Bool) -> Void

class ListDataSource: TableArrayDataSource<ListItemViewData, ListCell> {
    var isGrouped: Bool = false
    var onListDataSourceItemSelectionHandler: OnListDataSourceItemSelectionHandlerType?

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = super.tableView(tableView, cellForRowAt: indexPath)
        if let listCell = cell as? ListCell {
            //any callbacks initialised here
        }
        return cell
    }
}

fileprivate extension ListDataSource {
    func updateListViewData(at indexPath: IndexPath) {
        guard let viewData = item(at: indexPath) else {
            return
        }
        let data = ListItemViewData.defaultData()
        updateItem(at: indexPath, value: data)
    }
}
