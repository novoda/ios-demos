//
// Created by Niamh Power on 30/01/2018.
// Copyright (c) 2018 Novoda. All rights reserved.
//

import Foundation
import UIKit

class ListCell: UITableViewCell, ConfigurableCell {
    @IBOutlet weak var label: UILabel!

    // MARK: - ReusableCell
    public static var height: CGFloat = 128.0

    // MARK: - ConfigurableCell
    func configure(_ item: ListItemViewData, at indexPath: IndexPath) {
        //label.text = item.caption
        //imageView.image = UIImage(named: item.imageName)
    }
}
