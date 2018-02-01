//
// Created by Niamh Power on 30/01/2018.
// Copyright (c) 2018 Novoda. All rights reserved.
//

import Foundation
import UIKit

protocol ListViewActionDelegate: class {
    func itemPressed()
}

class ListViewDataSource: NSObject, UITableViewDataSource {
    typealias CellFactory = (UITableView, IndexPath, ListCellViewData) -> ListCellView

    var cellFactory: CellFactory!
    weak var actionDelegate: ListViewActionDelegate!

    fileprivate var items: [ListCellViewData] = []

    func item(atIndexPath indexPath: IndexPath) -> ListCellViewData {
        return items[indexPath.row]
    }

    func updateItems(with items: [ListCellViewData]) {
        self.items = items
    }

    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return cellFactory(tableView, indexPath, item(atIndexPath: indexPath))
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60.0
    }
}
