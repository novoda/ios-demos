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
    var characters: [Character]
}

struct CharacterResponseInfo: Codable {
    let count: Int
    let next: String?
    let pages: Int
    let prev: String?
}

struct Character: Codable {
    enum CodingKeys: String, CodingKey {
        case id = "id"
        case name = "name"
        case species = "species"
        case lastLocation = "location"
        case status = "status"
        case imageURL = "image"
        case episodeURLs = "episode"
    }
    
    let id: Int
    let name: String
    let species: String
    let lastLocation: LastLocation
    let status: String
    let imageURL: String
    let episodeURLs: [String]
}

struct LastLocation: Codable {
    let name: String
    let url: String
}
