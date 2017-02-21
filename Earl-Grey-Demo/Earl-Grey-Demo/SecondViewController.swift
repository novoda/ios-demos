//
// Created by Alex on 21/02/2017.
// Copyright (c) 2017 Alex Curran. All rights reserved.
//

import UIKit
import Foundation

class SecondViewController: UIViewController {

    let label = UILabel()

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Second"

        view.backgroundColor = .white
        view.addSubview(label)
		label.translatesAutoresizingMaskIntoConstraints = false
        label.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        label.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        label.topAnchor.constraint(equalTo: topLayoutGuide.bottomAnchor).isActive = true
        label.bottomAnchor.constraint(equalTo: bottomLayoutGuide.topAnchor).isActive = true
        label.textAlignment = .center

        label.text = "Welcome to the second controller!";
    }

}
