//
//  Character.swift
//  Rick And Morty
//
//  Created by Scottie Gray on 2021-08-09.
//  Copyright © 2021 Novoda. All rights reserved.
//

import Foundation

struct Character: Decodable {
    let id: Int
    let name: String
    let species: String
    let location: LastLocation
    let status: String
    let image: String
    let episode: [String]
}

struct LastLocation: Decodable {
    let name: String
    let url: String
}
