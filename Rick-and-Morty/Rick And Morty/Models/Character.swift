//
//  Character.swift
//  Rick And Morty
//
//  Created by Scottie Gray on 2021-07-16.
//  Copyright © 2021 Novoda. All rights reserved.
//

import Foundation

protocol Character {
    var id: UUID { get }
    var name: String { get }
    var image: String { get }
    var description: String { get }
}

extension Character {
    var id: UUID { UUID() }
}
