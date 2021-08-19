//
//  Episode.swift
//  Rick And Morty
//
//  Created by Scottie Gray on 2021-08-13.
//  Copyright © 2021 Novoda. All rights reserved.
//

import Foundation

struct Episode: Codable {
    enum CodingKeys: String, CodingKey {
        case name = "name"
        case airDate = "air_date"
        case episodeString = "episode"
        case characterURLs = "characters"
    }
    
    let name: String
    let airDate: String
    let episodeString: String
    let characterURLs: [String]
}
