//
//  CharacterCardViewModel.swift
//  Rick And Morty
//
//  Created by Scottie Gray on 2021-08-13.
//  Copyright © 2021 Novoda. All rights reserved.
//

import Foundation
import SwiftUI


struct CharacterCardState {
    var id: Int
    var name: String
    var imageURL: String
    var statusColor: Color
    var species: String
    var lastLocation: String
    var firstEpisodeName: String
    var statusText: String
}

final class CharacterCardViewModel: ObservableObject {
    @Published var cardState: CharacterCardState
    
    let character: Character
    private let episodeRepository: EpisodeRepositoryProtocol = EpisodeRepository()
    
    init(character: Character) {
        let cardStateFactory = CharacterCardStateFactory()
        
        self.character = character
        self.cardState = cardStateFactory.createCharacterCardState(from: character)
        
        loadFirstEpisodeName()
    }
    
    func loadFirstEpisodeName() {
        if let firstURL = character.episodeURLs.first {
            episodeRepository.getEpisode(from: firstURL) { episode in
                self.cardState.firstEpisodeName = episode.name
            }
        }
    }
}
