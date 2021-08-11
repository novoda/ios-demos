//
//  Character.swift
//  Rick And Morty
//
//  Created by Scottie Gray on 2021-08-09.
//  Copyright © 2021 Novoda. All rights reserved.
//

import Foundation

struct CharactersResponse: Codable {
    enum CodingKeys: String, CodingKey {
        case info = "info"
        case characters = "results"
    }
    
    let info: CharacterResponseInfo
    let characters: [Character]
}

struct CharacterResponseInfo: Codable {
    let count: Int
    let next: String?
    let pages: Int
    let prev: String?
}

struct Character: Codable {
    let id: Int
    let name: String
    let species: String
    let location: LastLocation
    let status: String
    let image: String
    let episode: [String]
}

struct LastLocation: Codable {
    let name: String
    let url: String
}
