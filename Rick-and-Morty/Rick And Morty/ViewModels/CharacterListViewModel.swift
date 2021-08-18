import Foundation

final class CharacterListViewModel: ObservableObject {
    @Published var characterListViewState: CharacterListViewState = CharacterListViewState(characters: [])
    
    struct CharacterListViewState {
        let title: String = "Characters"
        var characters: [Character]
    }
    
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
