//
// Created by Niamh Power on 30/01/2018.
// Copyright (c) 2018 Novoda. All rights reserved.
//

import Foundation

public protocol TableDataProvider {
    associatedtype T

    func numberOfSections() -> Int
    func numberOfItems(in section: Int) -> Int
    func item(at indexPath: IndexPath) -> T?

    func updateItem(at indexPath: IndexPath, value: T)
}
