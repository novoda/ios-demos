//
// Created by Niamh Power on 30/01/2018.
// Copyright (c) 2018 Novoda. All rights reserved.
//

import Foundation
import UIKit

public typealias TableItemSelectionHandlerType = (IndexPath) -> Void

open class TableDataSource<Provider: TableDataProvider, Cell: UITableViewCell>:
        NSObject,
        UITableViewDataSource,
        UITableViewDelegate
        where Cell: ConfigurableCell, Provider.T == Cell.T {
    // MARK: - Private Properties
    let provider: Provider
    let tableView: UITableView

    // MARK: - Lifecycle
    init(tableView: UITableView, provider: Provider) {
        self.tableView = tableView
        self.provider = provider
        super.init()
        setUp()
    }

    func setUp() {
        tableView.dataSource = self
        tableView.delegate = self
    }

    // MARK: - UITableViewDataSource
    public func numberOfSections(in tableView: UITableView) -> Int {
        return provider.numberOfSections()
    }

    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return provider.numberOfItems(in: section)
    }

    open func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: Cell.reuseIdentifier, for: indexPath) as? Cell else {
            return UITableViewCell()
        }

        let item = provider.item(at: indexPath)
        if let item = item {
            cell.configure(item, at: indexPath)
        }
        return cell
    }

    // MARK: - Delegates
    public var tableItemSelectionHandler: TableItemSelectionHandlerType?

    // MARK: UITableViewDelegate
    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableItemSelectionHandler?(indexPath)
    }
}
