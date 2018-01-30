//
// Created by Niamh Power on 30/01/2018.
// Copyright (c) 2018 Novoda. All rights reserved.
//

import Foundation

public protocol ReusableCell {
    static var reuseIdentifier: String { get }
}

public extension ReusableCell {
    static var reuseIdentifier: String {
        return String(describing: self)
    }
}

public protocol ConfigurableCell: ReusableCell {
    associatedtype T

    func configure(_ item: T, at indexPath: IndexPath)
}
