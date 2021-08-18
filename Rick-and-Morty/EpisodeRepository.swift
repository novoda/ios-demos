//
//  EpisodeRepository.swift
//  Rick And Morty
//
//  Created by Scottie Gray on 2021-08-13.
//  Copyright © 2021 Novoda. All rights reserved.
//

import Foundation

protocol EpisodeRepositoryProtocol {
    func getEpisode(from urlString: String, completion: @escaping ((Episode) -> Void))
}

final class EpisodeRepository: EpisodeRepositoryProtocol {
    private let rickAndMortyService: RickAndMortyServiceProtocol = RickAndMortyService()
    static private var cachedEpisodeNames: [String : Episode] = [:]
    
    func getEpisode(from urlString: String, completion: @escaping ((Episode) -> Void)) {
        if let episode = EpisodeRepository.cachedEpisodeNames[urlString] {
            completion(episode)
        } else {
            if let url = URL(string: urlString) {
                rickAndMortyService.fetchData(url: url) { (episode: Episode) in
                    EpisodeRepository.cachedEpisodeNames[urlString] = episode
                    completion(episode)
                } error: { error in
                    print(error.debugDescription)
                    return
                }
            }
        }
    }
}
