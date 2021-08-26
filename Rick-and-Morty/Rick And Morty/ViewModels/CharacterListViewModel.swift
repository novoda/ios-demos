import Foundation
import SwiftUI

final class CharacterListViewModel: ObservableObject {
    @Published var characterListViewState: CharacterListViewState = CharacterListViewState(characters: [])
    
    struct CharacterListViewState {
        let title: LocalizedStringKey = "charactersListTitle"
        var errorMessage: LocalizedStringKey? = nil
        var characters: [Character]
        var state: State = .doneLoading
        
        enum State {
            case loading
            case doneLoading
            case error
        }
    }
    
    private let characterRepository: CharacterRepositoryProtocol = CharacterRepository()
    private let characterCardStateFactory = CharacterCardStateFactory()
    
    init() {
        loadCharacters()
    }
    
    func loadCharacters() {
        characterListViewState.state = .loading
        
        characterRepository.getCharacters { characters in
            self.characterListViewState.state = .doneLoading
            self.characterListViewState.errorMessage = nil
            
            for character in characters {
                self.characterListViewState.characters.append(character)
            }
        } fail: { error in
            
            self.characterListViewState.state = .error
            self.characterListViewState.errorMessage = "errorMessage"
        }
    }
    
    func loadIfNeeded(characterID: Int) {
        if characterID == characterListViewState.characters.last?.id {
            loadCharacters()
        }
    }
}
