//
//  MortyCollectionViewCell.swift
//  Rick And Morty
//
//  Created by Scottie Gray on 2021-07-20.
//  Copyright © 2021 Novoda. All rights reserved.
//

import Foundation

import UIKit

class MortyCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    
    func setForMorty(morty: Morty) {
        imageView.image = UIImage(named: morty.image)
        nameLabel.text = morty.name
        descriptionLabel.text = morty.description
    }
}
