//
// Created by Niamh Power on 30/01/2018.
// Copyright (c) 2018 Novoda. All rights reserved.
//

import Foundation
import UIKit

class ListCellView: UITableViewCell {
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func update(with viewData: ListCellViewData) {
        self.textLabel?.text = viewData.title
    }
}
