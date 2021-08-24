import Foundation

final class CharacterListViewModel: ObservableObject {
    @Published var characterListViewState: CharacterListViewState = CharacterListViewState(characters: [])
    
    struct CharacterListViewState {
        let title: String = "Characters"
        var errorMessage: String? = nil
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
        } error: { error in
            
            self.characterListViewState.state = .error
            
            if let err = error {
                if err.code == 4864 {
                    self.characterListViewState.errorMessage = "Wubba Lubba Dub Dub! There was a problem loading the characters."
                } else {
                    self.characterListViewState.errorMessage = err.localizedDescription
                }
                
                self.characterListViewState.errorMessage?.append(" Tap the refresh button to try again..")
            }
        }
    }
    
    func loadIfNeeded(characterID: Int) {
        if characterID == characterListViewState.characters.last?.id {
            loadCharacters()
        }
    }
}
