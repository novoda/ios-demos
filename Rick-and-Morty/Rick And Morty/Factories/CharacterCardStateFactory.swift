//
//  CharacterCardStateFactory.swift
//  Rick And Morty
//
//  Created by Scottie Gray on 2021-08-13.
//  Copyright © 2021 Novoda. All rights reserved.
//

import Foundation

final class CharacterCardStateFactory {
    private func getIsAlive(character: Character) -> Bool {
        if character.status == "Alive" {
            return true
        }
        
        return false
    }
    
    private func getFirstEpisode(character: Character) -> String? {
        if let firstEpisode = character.episodeURLs.first {
            return firstEpisode
        }
        
        return nil
    }
    
    func createCharacterCardState(from character: Character) -> CharacterCardState {
        let isAlive = getIsAlive(character: character)
        let firstEpisode = getFirstEpisode(character: character) ?? "Unknown"
        let characterCardState = CharacterCardState(id: character.id, name: character.name, imageURL: character.imageURL, isAlive: isAlive, species: character.species, lastLocation: character.lastLocation.name, firstEpisodeURL: firstEpisode)
        
        return characterCardState
    }
}
