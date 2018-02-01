//
//  Created by Sergey Shulga on 07/04/2017.
// Copyright (c) 2018 Novoda. All rights reserved.
//

import Foundation
import UIKit

protocol ReusableView {
    static var reuseID: String { get }
}

extension UITableViewCell: ReusableView {
    static var reuseID: String {
        return String(describing: self)
    }
}

extension UITableViewHeaderFooterView: ReusableView {
    static var reuseID: String {
        return String(describing: self)
    }
}

extension UITableView {
    func registerCell<T>(ofType type: T.Type) where T: UITableViewCell {
        self.register(type, forCellReuseIdentifier: type.reuseID)
    }

    func dequeueReusableCell<T>(ofType type: T.Type, for indexPath: IndexPath) -> T where T: UITableViewCell {
        guard let cell = self.dequeueReusableCell(withIdentifier: type.reuseID, for: indexPath) as? T else {
            fatalError("Failed to dequeue cell with ID: \(T.reuseID)")
        }
        return cell
    }

    func dequeueReusableHeaderFooterView<T>(ofType type: T.Type) -> T where T: UITableViewHeaderFooterView {
        guard let footer = self.dequeueReusableHeaderFooterView(withIdentifier: type.reuseID) as? T else {
            fatalError("Failed to dequeue footer with ID: \(T.reuseID)")
        }

        return footer
    }
}
