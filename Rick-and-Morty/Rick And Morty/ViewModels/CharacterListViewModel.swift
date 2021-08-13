//
//  CharacterListViewModel.swift
//  Rick And Morty
//
//  Created by Scottie Gray on 2021-08-13.
//  Copyright © 2021 Novoda. All rights reserved.
//

import Foundation

final class CharacterListViewModel: ObservableObject {
    @Published var characterListViewState: CharacterListViewState = CharacterListViewState(characterCardStates: [])
    
    private let characterRepository: CharacterRepositoryProtocol = CharacterRepository()
    private let characterCardStateFactory = CharacterCardStateFactory()
    
    init() {
        getCardStates()
    }
    
    func getCardStates() {
        characterRepository.getCharacters { characters in
            for character in characters {
                let cardState = self.characterCardStateFactory.createCharacterCardState(from: character)
                self.characterListViewState.characterCardStates.append(cardState)
            }
        }
    }
}
