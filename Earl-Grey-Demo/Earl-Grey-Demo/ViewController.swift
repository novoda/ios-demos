//
//  ViewController.swift
//  Earl-Grey-Demo
//
//  Created by Alex Curran on 15/02/2017.
//  Copyright © 2017 Alex Curran. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    let button = UIButton()

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "First"

        view.backgroundColor = .white
        view.addSubview(button)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        button.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        button.topAnchor.constraint(equalTo: topLayoutGuide.bottomAnchor).isActive = true
        button.heightAnchor.constraint(equalToConstant: 50).isActive = true

        button.setTitle("Go", for: .normal)
        button.backgroundColor = .red
        button.addTarget(self, action: #selector(buttonTapped), for: .touchUpInside)
    }

    func buttonTapped() {
        show(SecondViewController(), sender: self)
    }

}

