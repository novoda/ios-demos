//
// Created by Niamh Power on 30/01/2018.
// Copyright (c) 2018 Novoda. All rights reserved.
//

import Foundation
import UIKit

open class TableArrayDataSource<T, Cell: UITableViewCell>:
        TableDataSource<ArrayDataProvider<T>, Cell>
        where Cell: ConfigurableCell, Cell.T == T {
    // MARK: - Lifecycle
    public convenience init(tableView: UITableView, array: [T]) {
        self.init(tableView: tableView, array: [array])
    }

    public init(tableView: UITableView, array: [[T]]) {
        let provider = ArrayDataProvider(array: array)
        super.init(tableView: tableView, provider: provider)
    }

    // MARK: - Public Methods
    public func item(at indexPath: IndexPath) -> T? {
        return provider.item(at: indexPath)
    }

    public func updateItem(at indexPath: IndexPath, value: T) {
        provider.updateItem(at: indexPath, value: value)
    }
}
