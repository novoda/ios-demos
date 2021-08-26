//
//  CharacterCardStateFactory.swift
//  Rick And Morty
//
//  Created by Scottie Gray on 2021-08-13.
//  Copyright © 2021 Novoda. All rights reserved.
//

import Foundation
import SwiftUI

final class CharacterCardStateFactory {
    private func getStatusColor(character: Character) -> Color {
        switch character.status {
        case .alive:
            return .green
        case .dead:
            return .red
        default:
            return .yellow
        }
    }
    
    private func getStatusText(character: Character) -> LocalizedStringKey {
        switch character.status {
        case .alive:
            return "aliveStatus - \(character.species)"
        case .dead:
            return "deadStatus - \(character.species)"
        default:
            return "unknownStatus - \(character.species)"
        }        
    }
    
    func createCharacterCardState(from character: Character) -> CharacterCardViewModel.CharacterCardState {
        let characterCardState = CharacterCardViewModel.CharacterCardState(
                                        id: character.id,
                                        name: character.name,
                                        imageURL: character.imageURL,
                                        statusColor: getStatusColor(character: character),
                                        species: character.species,
                                        lastLocation: character.lastLocation.name,
                                        firstEpisodeName: "",
                                        statusText: getStatusText(character: character)
                                        )
        
        return characterCardState
    }
}
