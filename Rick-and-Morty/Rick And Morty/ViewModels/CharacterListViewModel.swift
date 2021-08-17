//
//  CharacterListViewModel.swift
//  Rick And Morty
//
//  Created by Scottie Gray on 2021-08-13.
//  Copyright © 2021 Novoda. All rights reserved.
//

import Foundation


struct CharacterListViewState {
    let title: String = "Characters"
    var characters: [Character]
}

final class CharacterListViewModel: ObservableObject {
    @Published var characterListViewState: CharacterListViewState = CharacterListViewState(characters: [])
    
    private let characterRepository: CharacterRepositoryProtocol = CharacterRepository()
    private let characterCardStateFactory = CharacterCardStateFactory()
    
    init() {
        loadCharacters()
    }
    
    func loadCharacters() {
        characterRepository.getCharacters { characters in
            for character in characters {
                self.characterListViewState.characters.append(character)
            }
        }
    }
    
    func loadIfNeeded(characterID: Int) {
        if characterID == characterListViewState.characters.last?.id {
            loadCharacters()
        }
    }
}
